#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QLineSeries>
#include <QFileDialog>
#include <math.h>

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
    

    initializeGUI();

    initializeStepperMotorController();
}

bool MainWindow::updateSettings(std::string filename)
{
     std::fstream fs;
     fs.open(filename,std::fstream::in);

     rapidxml::file<> xmlFile(filename.c_str()); // Default template is char
     rapidxml::xml_document<> doc;
     doc.parse<0>(xmlFile.data());

     xml_node<> *configNode = doc.first_node();

     //get the comments
     xml_node<> *commentsNode = configNode->first_node("Comments");
     Settings.comments = commentsNode->value();

    //get the pna settings
    xml_node<> *pnaSettingsNode = configNode->first_node("PNA_Settings");
    xml_node<> *nPointsNode = pnaSettingsNode->first_node("NumberOfPoints");
    Settings.numberOfPoints = atoi(nPointsNode->value());
    xml_node<> *fStartNode = pnaSettingsNode->first_node("FrequencySweepStart");
    Settings.fStart = atof(fStartNode->value());
    xml_node<> *fStopNode = pnaSettingsNode->first_node("FrequencySweepStop");
    Settings.fStop = atof(fStopNode->value());

   //stepper motor settings
    xml_node<> *stepperMotorSettingsNode = configNode->first_node("StepperMotor_Settings");
    xml_node<> *nStepsNode = stepperMotorSettingsNode->first_node("NStepsPerRevolution");
    Settings.numberOfStepsPerRevolution = atoi(nStepsNode->value());
    xml_node<> *comPortNode = stepperMotorSettingsNode->first_node("COMport");
    Settings.COMport = comPortNode->value();

    //experiment settings
    xml_node<> *experimentSettingsNode = configNode->first_node("Experiment_Settings");
    xml_node<> *nRealizationsNode = experimentSettingsNode->first_node("NumberOfRealizations");
     Settings.numberOfRealizations = atoi(nRealizationsNode->value());
    xml_node<> *cavVolumeNode = experimentSettingsNode->first_node("CavityVolume");
    Settings.cavityVolume = atof(cavVolumeNode->value());
    xml_node<> *fNamePrefixNode = experimentSettingsNode->first_node("FileNamePrefix");
    Settings.outputFileNamePrefix = fNamePrefixNode->value();
    xml_node<> *timeDateStampNode = experimentSettingsNode->first_node("TimeDateStamp");
    int useTimeStamp = atoi(timeDateStampNode->value());
     if (useTimeStamp == 1)
         Settings.useDateStamp = true;
     else
         Settings.useDateStamp = false;

   //get the time stamp
     time_t now = time(0);
     tm *ltm = localtime(&now);


     std::string timeStampString = std::to_string(1970 + ltm->tm_year) + std::to_string(1+ltm->tm_mon) + std::to_string(ltm->tm_mday) + "_";
     timeStampString += std::to_string(1+ltm->tm_hour) + "_" + std::to_string(ltm->tm_min) + "_" + std::to_string(ltm->tm_sec);
     Settings.outputFileName = Settings.outputFileNamePrefix + "_" + timeStampString;

     fs.close();
     return true;
}

void MainWindow::initializeStepperMotorController()
{
    if (sObj != nullptr)
        delete sObj;

    //compute the step distance and run speed
    int stepDistance = Settings.direction*static_cast<double>(Settings.numberOfStepsPerRevolution)/static_cast<double>(Settings.numberOfRealizations);
    int waitTime = 15;

    int runSpeed = static_cast<int>(ceil(static_cast<double>(stepDistance)/static_cast<double>(10)));

    //temporary test mode - allows testing without hardware present
    testMode = true;


    //create the pnaController object
    if(testMode == true)
        sObj = new stepperMotorControllerMock(stepDistance, runSpeed, Settings.COMport);
    else
        sObj = new stepperMotorController(stepDistance, runSpeed, Settings.COMport);

    logMessage(sObj->getAvailablePorts());

    std::string sString;

    if (!sObj->getConnectionStatus())
    {
      sString = "Not Connected, Error Code: " + std::to_string(sObj->getConnectionErrors());
    }
    else
    {
     sString = Settings.COMport;
    }

    updateLabel(ui->motorStatusLabel,sObj->getConnectionStatus(),QString::fromStdString(sString));
    updateStepperMotorStatus();

    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateStepperMotorStatus()));
    timer->start(100);
}

void MainWindow::updateStepperMotorStatus()
{
    int pos = sObj->getStepperMotorPosition();
    updateLabel(ui->motorPositionLabel,QString::number(pos));
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
         ui->statusBar->showMessage("Busy");
         ui->systemStatusLabel->setStyleSheet(labelBusyString);
         ui->systemStatusLabel->setText("MEASURING");
        break;
    case CALIBRATING:
         ui->statusBar->showMessage("Busy");
         ui->systemStatusLabel->setStyleSheet(labelBusyString);
         ui->systemStatusLabel->setText("CALIBRATING");
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
    delete sObj;
}

void MainWindow::on_measureDataButton_clicked()
{
    logMessage("Measuring Data ...","info");

    sObj->moveStepperMotor();

    //mControl.measureData();

    logMessage("Done");
}

void MainWindow::on_editConfigButton_clicked()
{
    logMessage("Editing Configuration, Make sure to reload ...","warning");

    logMessage("Done");
}

void MainWindow::on_calibrateButton_clicked()
{
     logMessage("Calibrating ...","info");

     logMessage("Done");
}

void MainWindow::on_stopMeasurementButton_clicked()
{
     logMessage("Stopping Measurement ...","warning");

     logMessage("Done");

}

void MainWindow::on_reloadConfigButton_clicked()
{
     logMessage("Reloading Configuration ...","info");

     QString fileName = QFileDialog::getOpenFileName (this, tr("Open File"), QDir::currentPath(),
                                                      tr("Config File (*.xml)"), 0,
                                                      QFileDialog::DontUseNativeDialog);

     updateSettings(fileName.toStdString());
     logSettings(Settings);
     initializeStepperMotorController();
     logMessage("Done");

}
