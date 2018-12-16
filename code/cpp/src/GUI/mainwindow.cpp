#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QLineSeries>
#include <QFileDialog>
#include <math.h>
#include <strstream>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    //setup color palettes for good/bad/don't care status
    labelErrorString = "QLabel { background-color : red; color : white; }";
    labelGoodString = "QLabel { background-color : green; color : white; }";
    labelDefaultString = "QLabel { background-color : white; color : black; }";
    labelBusyString = "QLabel { background-color : yellow; color : black; }";
    //limit the length of plots for speed
    maxPlotLength = 256;

    testMode = false;
    
    mMode = IDLE;

    mControl = new measurementController(testMode);
    initializeGUI();

    //connect the measurement threds emitted signals to the main GUI window slots

    //when new measured S parameters are available, need to display them
    connect(&mThread, SIGNAL(measuredSParametersAvailable(double)),
                this, SLOT(updateSParameterPlots(double)));

    //when a new info string is available, need to show it - first have to register std::string
    //with the queueing operation
    qRegisterMetaType<std::string>();
    connect(&mThread, SIGNAL(infoStringAvailable(std::string,std::string)),
                this, SLOT(updateInfoString(std::string,std::string)));

    //when the measurement is complete, make sure to update
    connect(&mThread, SIGNAL(measurementComplete()),
                this, SLOT(updateMeasurementStatusComplete()));

    //when a calibration file name is available, make sure to update
    connect(&mThread, SIGNAL(calFileNameAvailable(bool, std::string)),
                this, SLOT(updateCalFileName(bool, std::string)));

    //when ready to move the stepper motor do it
    //this prevents problems in QT when trying to access sockets across threads
    connect(&mThread, SIGNAL(readyToStepMotor()),
                this, SLOT(stepMotor()));

    //setup the timer to show updates for mode changes
    updateModeTimer = new QTimer(this);
    connect(updateModeTimer, SIGNAL(timeout()), this, SLOT(updateGUICurrentMode()));
    updateModeTimer->start(1000);

    listConnections();
}

void MainWindow::listConnections()
{
    std::string pnaString = mControl->getVXI11Clients();
    logMessage("Available VXI11 Clients:", "info");
    logMessage(pnaString);

    std::string serialString = mControl->getSerialClients();
    logMessage("Available Serial Clients:", "info");
    logMessage(serialString);
}

void MainWindow::updateCalFileName(bool status, std::string calName)
{
    updateLabel(ui->calibrationStatusLabel,status,QString::fromStdString(calName));
}

void MainWindow::updateMeasurementStatusComplete()
{
    mMode = IDLE;
}

void MainWindow::stepMotor()
{
    mControl->moveStepperMotorNoWait();
}

void MainWindow::updateGUICurrentMode()
{
    updateGUIMode(mMode);
}

void MainWindow::updateInfoString(const std::string infoString, const std::string severity)
{
    logMessage(infoString,severity);
}

void MainWindow::updateGUIMode(measurementModes mode)
{
    switch(mode)
    {
    case IDLE:
         ui->statusBar->showMessage("Ready");
         ui->systemStatusLabel->setStyleSheet(labelDefaultString);
         ui->systemStatusLabel->setText("IDLE");
        break;
    case MEASURING:
         ui->statusBar->showMessage("Busy - Measuring");
         ui->systemStatusLabel->setStyleSheet(labelBusyString);
         ui->systemStatusLabel->setText("MEASURING");
        break;
    case CALIBRATING:
         ui->statusBar->showMessage("Busy - Calibrating");
         ui->systemStatusLabel->setStyleSheet(labelBusyString);
         ui->systemStatusLabel->setText("CALIBRATING");
        break;
    case INITIALIZING:
        ui->statusBar->showMessage("Busy - Initializing");
        ui->systemStatusLabel->setStyleSheet(labelBusyString);
        ui->systemStatusLabel->setText("INITIALIZING");
        break;
     case CONFIGURING:
        ui->statusBar->showMessage("Busy - Configuring");
        ui->systemStatusLabel->setStyleSheet(labelBusyString);
        ui->systemStatusLabel->setText("CONFIGURATION UPDATE");
       break;
    };
}

void MainWindow::initializeGUI()
{
    logMessage("Initializing ...");
    ui->realChartView->setChart(&realPlot);
    ui->imagChartView->setChart(&imagPlot);

    ui->statusBar->showMessage("Ready");
    initializeStatusLabels();
    initializePlots();
    logMessage("Done");
}

void MainWindow::updateLabel(QLabel *label, bool status, QString labelText)
{
 if (status == true)
     label->setStyleSheet(labelGoodString);
 else
    label->setStyleSheet(labelErrorString);

 label->setText(labelText);

}

void MainWindow::updateLabel(QLabel *label, QString labelText)
{
 label->setStyleSheet(labelDefaultString);
 label->setText(labelText);
}


void MainWindow::updatePlot( QtCharts::QChart *plot,  QtCharts::QLineSeries *series, std::vector<double> xData, std::vector<double> yData)
{
    if (xData.size() != yData.size() )
    {
        logMessage("Data Sizes are Not Equal","error");
    }

    series->clear();

    for (size_t i = 0; i < xData.size(); i++)
    {
     series->append(xData[i],yData[i]);
    }

  plot->addSeries(series);
}


void MainWindow::initializePlots()
{
 std::vector<double> xData(maxPlotLength);
 std::vector<double> yData(maxPlotLength);
 std::vector<double> yData1(maxPlotLength);
 std::vector<double> yData2(maxPlotLength);

 double increment = (11e9 - 9.5e9)/static_cast<double>(maxPlotLength);
 for (size_t i = 0; i < maxPlotLength; i++)
 {
     xData[i] = (9.5e9 + increment*i)/1e9;
     yData[i] = static_cast<double>(i);
     yData1[i] = 2.0*static_cast<double>(i);
     yData2[i] = 5.0*static_cast<double>(i);
 }

    realS11.setName("S11");
    realS12.setName("S12");
    realS22.setName("S22");
    imagS11.setName("S11");
    imagS12.setName("S12");
    imagS22.setName("S22");
    realPlot.setTitle("Real Part of S-Parameters");
    imagPlot.setTitle("Imaginary Part of S-Parameters");

 updatePlots(xData,yData,yData1,yData2,yData,yData1,yData2);

}

void MainWindow::updatePlots(std::vector<double> f, std::vector<double> S11R, std::vector<double> S11I, std::vector<double> S12R, std::vector<double> S12I, std::vector<double> S22R,  std::vector<double> S22I  )
{
    realPlot.removeAllSeries();
    updatePlot(&realPlot,&realS11,f,S11R);
    updatePlot(&realPlot,&realS12,f,S12R);
    updatePlot(&realPlot,&realS22,f,S22R);

    realPlot.createDefaultAxes();
    realPlot.axisX()->setTitleText("Frequency (GHz)");
    realPlot.axisY()->setTitleText("Real Part (V/V)");

    imagPlot.removeAllSeries();
    updatePlot(&imagPlot,&imagS11,f,S11I);
    updatePlot(&imagPlot,&imagS12,f,S12I);
    updatePlot(&imagPlot,&imagS22,f,S22I);

    imagPlot.createDefaultAxes();
    imagPlot.axisX()->setTitleText("Frequency (GHz)");
    imagPlot.axisY()->setTitleText("Imaginary Part (V/V)");
}


void MainWindow::initializeStatusLabels()
{
    //initialize the text and coloring of the status labels
    updateLabel(ui->pnaConnectionLabel,false,"Not Connected");
    updateLabel(ui->motorStatusLabel,false,"Not Connected");
    updateLabel(ui->systemStatusLabel,"Idle");
    updateLabel(ui->calibrationStatusLabel,false,"No Calibration File Loaded");
    updateLabel(ui->motorPositionLabel,"0");
    updateLabel(ui->fileNameLabel,"");
}

MainWindow::~MainWindow()
{
    delete ui;
    delete mControl;
    delete updateModeTimer;

    if (smTimer != nullptr)
    {
        smTimer->stop();
        delete smTimer;
    }
}

void MainWindow::on_measureDataButton_clicked()
{
    logMessage("Measuring Data ...","info");
    mMode = MEASURING;
    mThread.measure(mControl);

    if (smTimer != nullptr)
     {
       smTimer->stop();
       delete smTimer;
     }
     smTimer = new QTimer(this);
     connect(smTimer, SIGNAL(timeout()), this, SLOT(updateStepperMotorStatus()));
     smTimer->start(500);
}

void MainWindow::updateStepperMotorStatus()
{
    int pos = mControl->getStepperMotorPosition();
    updateLabel(ui->motorPositionLabel,QString::number(pos));
}


void MainWindow::on_editConfigButton_clicked()
{
    logMessage("Editing Configuration - need to Load to take effect","warning");
    mMode = CONFIGURING;

    QString fileName = getConfigFileName();

    std::cout<<"File Name: " << fileName.toStdString() << std::endl;

    QFile configFile(fileName);

    if (!configFile.open(QIODevice::ReadWrite))
        return;

    QTextEdit *cEdit = new QTextEdit;

    cEdit->setText(configFile.readAll());
    cEdit->show();

    logMessage("Done");
}

void MainWindow::on_calibrateButton_clicked()
{
     logMessage("Calibrating ...","info");
     mMode = CALIBRATING;

     logMessage("Done");
     mMode = IDLE;
}

void MainWindow::on_stopMeasurementButton_clicked()
{
     logMessage("Stopping Measurement, waiting for thread to shutdown ...","warning");

     mThread.requestAbort = true;

     //TBD - handle deleting any partially completed HDF5 files


     logMessage("Done");
}

QString MainWindow::getConfigFileName()
{
    QString fileName = QFileDialog::getOpenFileName (this, tr("Open File"), QDir::currentPath(),
                                                     tr("Config File (*.xml)"), 0,
                                                     QFileDialog::DontUseNativeDialog);

    return fileName;
}


void MainWindow::on_reloadConfigButton_clicked()
{
     logMessage("Reloading Configuration ...","info");
     mMode = CONFIGURING;

     QString fileName = getConfigFileName();

     if (!QFile::exists(fileName))
     {
         mMode = IDLE;
         logMessage("No configuration file selected","warning");
         return;
     }

     mControl->updateSettings(fileName.toStdString());
     std::stringstream SettingsStream;
     std::string SettingsString;
     SettingsStream << mControl->getSettings();

     logMessage("Settings:", "info");
     while(!SettingsStream.eof())
     {

         std::getline(SettingsStream,SettingsString);
         logMessage(SettingsString);
     }

     logMessage("Trying to Connect");
     mControl->establishConnections();

     updateLabel(ui->motorStatusLabel,mControl->getStepperMotorConnected(),QString::fromStdString(mControl->getStepperMotorInfoString()));
     updateLabel(ui->pnaConnectionLabel,mControl->getPNAConnected(),QString::fromStdString(mControl->getPNAInfoString()));
     updateLabel(ui->motorPositionLabel,QString::number(mControl->getStepperMotorPosition()));
     updateLabel(ui->fileNameLabel,QString::fromStdString(mControl->getFileName()));

     logMessage("Done");

     mMode = IDLE;

}

 void MainWindow::updateSParameterPlots(double d )
 {

 }
