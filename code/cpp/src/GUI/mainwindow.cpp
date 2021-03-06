#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QMessageBox>

#include <QLineSeries>
#include <QFileDialog>
#include <math.h>
#include <strstream>
#include <complex>

/**
 * \brief constructor
 *
 * Constructor for the main window application
*/
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    //test mode - set to "true" to run with mock interfaces, set to "false" to run with real hardware
    testMode = false;

    setupMenu();

    ui->setupUi(this);

    measurementValid = false;

    Q_INIT_RESOURCE(icons);

    setWindowIcon(QIcon(":/icons/umdlogo.icns"));

    m_axis = new QtCharts::QValueAxis();

    //setup color palettes for good/bad/don't care status
    labelErrorString = "QLabel { background-color : red; color : white; }";
    labelGoodString = "QLabel { background-color : green; color : white; }";
    labelDefaultString = "QLabel { background-color : white; color : black; }";
    labelBusyString = "QLabel { background-color : yellow; color : black; }";

    //limit the length of plots for speed
    maxPlotLength = 257;
    
    mMode = IDLE;

    mControl = new measurementController(testMode);
    initializeGUI();

    //connect the measurement threads emitted signals to the main GUI window slots

    //when a new info string is available, need to show it - first have to register std::string
    //with the queueing operation
    qRegisterMetaType<std::string>();
    connect(&mThread, SIGNAL(infoStringAvailable(std::string,std::string)),
                this, SLOT(updateInfoString(std::string,std::string)));

    //when the measurement is complete, make sure to update
    connect(&mThread, SIGNAL(measurementComplete()),
                this, SLOT(updateMeasurementStatusComplete()));

    //when the frequency data is available to plot, do so
    connect(&mThread, SIGNAL(freqDataAvailable()),
                this, SLOT(plotFreqData()));

    //when a calibration file name is available, make sure to update
    connect(&mThread, SIGNAL(calFileNameAvailable(bool, std::string)),
                this, SLOT(updateCalFileName(bool, std::string)));

    //when a calibration file name is available, make sure to update
    connect(&mThread, SIGNAL(outputFileNameAvailable(std::string)),
                this, SLOT(updateOutputFileName(std::string)));

    //when ready to move the stepper motor do it
    //this prevents problems in QT when trying to access sockets across threads
    connect(&mThread, SIGNAL(readyToStepMotor()),
                this, SLOT(stepMotor()));

    //when a measurement is taken and we need to wait for user input, do so
    connect(&mThread, SIGNAL(readyForUserInput()),
                this, SLOT(getUserInput()));

    //setup the timer to show updates for mode changes
    updateModeTimer = new QTimer(this);
    connect(updateModeTimer, SIGNAL(timeout()), this, SLOT(updateGUICurrentMode()));
    updateModeTimer->start(1000);

    listConnections();
}

/**
 * \brief setupMenu
 *
 * This function handles setting up the menu bar for the application
*/
void MainWindow::setupMenu()
{
    plotReIm = true; //show real/imaginary or magnitude/phase

    // setup the menu
    m_menuBar = new QMenuBar(this);

    menuBar()->setNativeMenuBar(false);

    displayMenu = new QMenu("Display");

    //create the actions for real/imag and mag/phase
    displayRealImag =  new QAction(tr("Real/Imag"), this);
    displayRealImag->setStatusTip(tr("Display Real and Imaginary Components"));
    displayRealImag->setCheckable(true);
    connect(displayRealImag, &QAction::triggered, this, &MainWindow::setDisplayTypeRealImag);

    displayLogMagPhase =  new QAction(tr("Log Mag/Phase"), this);
    displayLogMagPhase->setStatusTip(tr("Display Log Magnitude and Phase Components"));
    displayLogMagPhase->setCheckable(true);
    connect(displayLogMagPhase, &QAction::triggered, this, &MainWindow::setDisplayTypeLogMagPhase);

    //create the action group
    displayGroup = new QActionGroup(this);
    displayGroup->addAction(displayRealImag);
    displayGroup->addAction(displayLogMagPhase);
    displayRealImag->setChecked(true);

    displayMenu->addAction(displayRealImag);
    displayMenu->addAction(displayLogMagPhase);
    m_menuBar->addAction(displayMenu->menuAction());
}

/**
 * \brief plotFreqData
 *
 * Slot for the main window to plot the frequency data received from the meausrement thread
*/
void MainWindow::plotFreqData()
{
    //set the flag for having valid measurements (this should always be true after the first time)
    measurementValid = true;
    //get the decimated measurement vectors (can't plot the full sequence due to time/memory constraints)
    mControl->getS11Decimated(S11R,S11I);
    mControl->getS12Decimated(S12R,S12I);
    mControl->getS22Decimated(S22R,S22I);
    mControl->getFreqDecimated(f);
    //clear the plots before updating
    clearPlots();
    //update the plots with the current measurements
    updatePlots(f,S11R, S11I,  S12R, S12I, S22R, S22I  );
}

/**
 * \brief setDisplayTypeLogMagPhase
 *
 * Slot for the main window to switch to plotting Log Magnitude and Phase
*/
void MainWindow::setDisplayTypeLogMagPhase()
{

if (plotReIm == true)
    {
        plotReIm = false;
        clearPlots();
        updatePlots(f,S11R, S11I,  S12R, S12I, S22R, S22I  );
    }
}

/**
 * \brief setDisplayTypeRealImag
 *
 * Slot for the main window to switch to plotting Real and Imaginary components
*/
void MainWindow::setDisplayTypeRealImag()
{
    if (plotReIm == false)
        {
            plotReIm = true;
            clearPlots();
            updatePlots(f,S11R, S11I,  S12R, S12I, S22R, S22I  );
        }
}

/**
 * \brief listConnections
 *
 * This function queries the VXI11 and Serial clients avaialble and lists them to the output log window
*/
void MainWindow::listConnections()
{
    std::string pnaString = mControl->getVXI11Clients();
    logMessage("Available VXI11 Clients:", "info");
    logMessage(pnaString);

    std::string serialString = mControl->getSerialClients();
    logMessage("Available Serial Clients:", "info");
    logMessage(serialString);
}

/**
 * \brief updateOutputFileName
 *
 * This function updates the output file name that is displayed in the output file label
 * @param[in] fileName string that contains the output file name
*/
void MainWindow::updateOutputFileName(std::string fileName)
{
   ui->fileNameLabel->setText(QString::fromStdString((fileName)));
}

/**
 * \brief updateCalFileName
 *
 * This function updates the calibration file name that is displayed in the calibration file label
 * @param[in] fileName string that contains the calibration file name
*/
void MainWindow::updateCalFileName(bool status, std::string calName)
{
    updateLabel(ui->calibrationStatusLabel,status,QString::fromStdString(calName));
}

/**
 * \brief updateMeasurementStatusComplete
 *
 * Slot that signifies the measurement sequence is done and the timer for the stepper motor can be stopped.
*/
void MainWindow::updateMeasurementStatusComplete()
{
    mMode = IDLE;
    if (smTimer != nullptr)
    {
        smTimer->stop();
        delete smTimer;
    }
}

/**
 * \brief getUserInput
 *
 * Slot for the main window to get user input. This function will put up a message box
 * that allows the user to close when the cavity is ready for the next measurement. The
 * global mutex will be locked while the message box is up so the measurement thread
 * will be paused
*/
void MainWindow::getUserInput()
{
    //first need to lock the mutex
    globalMutex.lock();
    //now create and show the message box
    QMessageBox msgBox;
    msgBox.setText("Press OK when cavity is ready for measurement");
    msgBox.exec();
    //once the "OK" button has been pressed, need to unlock the mutex
    globalMutex.unlock();
    //make sure to signal that the wait condition is ready
    globalWaitCondition.wakeAll();
}

/**
 * \brief stepMotor
 *
 * Slot for the main window to step the motor. The communication is over
 * a serial port, which is not allowed by QT to be cross threaded, so we
 * need to handle this in the main window thread.
*/
void MainWindow::stepMotor()
{
    mControl->moveStepperMotorNoWait();
}

/**
 * \brief updateGUICurrentMode
 *
 * Slot for the main window to signify the measurement mode
*/
void MainWindow::updateGUICurrentMode()
{
    updateGUIMode(mMode);
}

/**
 * \brief updateInfoString
 *
 * Slot for the main window to update the info string that is output to the log message window
 * @param[in] infoString string to be displayed
 * @param[in] severity string that contains the severity (error, warning, info, default)
*/
void MainWindow::updateInfoString(const std::string infoString, const std::string severity)
{
    logMessage(infoString,severity);
}

/**
 * \brief updateGUIMode
 *
 * This function updates the GUI to the current mode and sets all the labels and status
 * @param[in] mode The measurement mode to update the GUI to
*/
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

/**
 * \brief initializeGUI
 *
 * This function handles initialization and creation of all GUI components.
*/
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

/**
 * \brief updateLabel
 *
 * This function handles updating labels on the GUI with a status for color
 * @param[in] label the label handel to update
 * @param[in] status the boolean status to use for coloring (true = Good/Green, false = Error/Red)
 * @param[in] labelText the text to update the label with
*/
void MainWindow::updateLabel(QLabel *label, bool status, QString labelText)
{
 if (status == true)
     label->setStyleSheet(labelGoodString);
 else
    label->setStyleSheet(labelErrorString);

 label->setText(labelText);

}

/**
 * \brief updateLabel
 *
 * This function handles updating labels on the GUI without a status for color
 * @param[in] label the label handel to update
 * @param[in] labelText the text to update the label with
*/
void MainWindow::updateLabel(QLabel *label, QString labelText)
{
 label->setStyleSheet(labelDefaultString);
 label->setText(labelText);
}

/**
 * \brief initializePlots
 *
 * This function handles initalization of the plot windows.
*/
void MainWindow::initializePlots()
{
 std::vector<double> xData(maxPlotLength);
 std::vector<double> yData(maxPlotLength);
 std::vector<double> yData1(maxPlotLength);
 std::vector<double> yData2(maxPlotLength);

 double increment = (11e9 - 9.5e9)/static_cast<double>(maxPlotLength);
 for (size_t i = 0; i < maxPlotLength; i++)
 {
     f.push_back((9.5e9 + increment*i)/1e9);
     S11R.push_back(static_cast<double>(i+1));
     S12R.push_back(2.0*static_cast<double>(i+1));
     S22R.push_back(5.0*static_cast<double>(i+1));
     S11I.push_back(static_cast<double>(i+1));
     S12I.push_back(2.0*static_cast<double>(i+1));
     S22I.push_back(5.0*static_cast<double>(i+1));
 }

    realS11.setName("S11");
    realS12.setName("S12");
    realS22.setName("S22");
    imagS11.setName("S11");
    imagS12.setName("S12");
    imagS22.setName("S22");
    realPlot.setTitle("Real Part of S-Parameters");
    imagPlot.setTitle("Imaginary Part of S-Parameters");

     updatePlots(f,S11R, S11I,  S12R, S12I, S22R, S22I  );

}


/**
 * \brief clearPlots
 *
 * This function removes all data currently plotted on the plot windows.
*/
void MainWindow::clearPlots()
{
    realPlot.removeSeries(&realS11);
    realPlot.removeSeries(&realS12);
    realPlot.removeSeries(&realS22);
    imagPlot.removeSeries(&imagS11);
    imagPlot.removeSeries(&imagS12);
    imagPlot.removeSeries(&imagS22);
}

/**
 * \brief getPhase
 *
 * This function gets the phase of a sequence of complex numbers.
 * @param[in] SR vector of real components
 * @param[in] SI vector of imaginary components
 * \returns Vector of phase
*/
std::vector<double> MainWindow::getPhase(std::vector<double> &SR,std::vector<double> &SI)
{
    std::vector<double> output;
    std::complex<double> Sc;
    double tempValue;
    for (unsigned int cnt = 0; cnt < SR.size(); cnt++)
    {
        Sc = std::complex<double>(SI[cnt],SR[cnt]);

        tempValue = std::arg(Sc);
        output.push_back(tempValue);
    }

    return output;
}

/**
 * \brief getMagnitude
 *
 * This function gets the magnitude of a sequence of complex numbers.
 * @param[in] SR vector of real components
 * @param[in] SI vector of imaginary components
 * \returns Vector of log magnitude
*/
std::vector<double> MainWindow::getMagnitude(std::vector<double> &SR,std::vector<double> &SI)
{
    std::vector<double> output;
    std::complex<double> Sc;
    double tempValue;
    for (unsigned int cnt = 0; cnt < SR.size(); cnt++)
    {
        Sc = std::complex<double>(SI[cnt],SR[cnt]);

        tempValue = 20*log10(std::abs(Sc));
        output.push_back(tempValue);
    }

    return output;
}

/**
 * \brief updatePlots
 *
 * This function updates the plots in the main GUI window
 * @param[in] f vector of frequency points
 * @param[in] S11R vector of real components for S11
 * @param[in] S11I vector of imaginary components for S11
 * @param[in] S12R vector of real components for S12
 * @param[in] S12I vector of imaginary components for S12
 * @param[in] S22R vector of real components for S22
 * @param[in] S22I vector of imaginary components for S22
*/
void MainWindow::updatePlots(std::vector<double> f, std::vector<double> S11R, std::vector<double> S11I, std::vector<double> S12R, std::vector<double> S12I, std::vector<double> S22R,  std::vector<double> S22I  )
{

    if (plotReIm == true) //plot real/imaginary
    {
        updatePlot(&realPlot,&realS11,f,S11R);
        updatePlot(&realPlot,&realS12,f,S12R);
        updatePlot(&realPlot,&realS22,f,S22R);

        realPlot.createDefaultAxes();
        realPlot.axisX()->setTitleText("Frequency (GHz)");
        realPlot.axisY()->setTitleText("Real Part (V/V)");
        realPlot.setTitle("Real Part of S-Parameters");

        updatePlot(&imagPlot,&imagS11,f,S11I);
        updatePlot(&imagPlot,&imagS12,f,S12I);
        updatePlot(&imagPlot,&imagS22,f,S22I);

        imagPlot.createDefaultAxes();
        imagPlot.axisX()->setTitleText("Frequency (GHz)");
        imagPlot.axisY()->setTitleText("Imaginary Part (V/V)");
        imagPlot.setTitle("Imaginary Part of S-Parameters");
    }
    else //plot magnitude/phase
    {

        std::vector<double> magS11 = getMagnitude(S11R,S11I);
        std::vector<double> magS12 = getMagnitude(S12R,S12I);
        std::vector<double> magS22 = getMagnitude(S22R,S22I);
        updatePlot(&realPlot,&realS11,f,magS11);
        updatePlot(&realPlot,&realS12,f,magS12);
        updatePlot(&realPlot,&realS22,f,magS22);

        realPlot.createDefaultAxes();
        realPlot.axisX()->setTitleText("Frequency (GHz)");
        realPlot.axisY()->setTitleText("Magnitude (dB)");
        realPlot.setTitle("Magnitude of S-Parameters");

        std::vector<double> angS11 = getPhase(S11R,S11I);
        std::vector<double> angS12 = getPhase(S12R,S12I);
        std::vector<double> angS22 = getPhase(S22R,S22I);
        updatePlot(&imagPlot,&imagS11,f,angS11);
        updatePlot(&imagPlot,&imagS12,f,angS12);
        updatePlot(&imagPlot,&imagS22,f,angS22);

        imagPlot.createDefaultAxes();
        imagPlot.axisX()->setTitleText("Frequency (GHz)");
        imagPlot.axisY()->setTitleText("Phase (rad)");
        imagPlot.setTitle("Phase of S-Parameters");
    }
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

/**
 * \brief initializeStatusLabels
 *
 * This function handles initalization of the status lables.
*/
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
    CloseDownThreads();

    //TBD - need to wait for the thread to stop
    delete mControl;
    delete updateModeTimer;
    delete m_axis;


     delete ui;
}

void MainWindow::on_measureDataButton_clicked()
{
    logMessage("Measuring Data ...","info");
    measurementValid = false;
    mMode = MEASURING;
    mThread.measure(mControl);

    if (smTimer != nullptr)
     {
       smTimer->stop();
       delete smTimer;
     }
     smTimer = new QTimer(this);
     connect(smTimer, SIGNAL(timeout()), this, SLOT(updateStepperMotorStatus()));
     smTimer->start(250);
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

     try
     {
         mControl->calibratePNA();
    }
     catch(pnaException pe)
     {
         logMessage(pe.what(),"error");
     }
     logMessage("Done");
     mMode = IDLE;
}

void MainWindow::CloseDownThreads()
{

    logMessage("Stopping Measurement, waiting for thread to shutdown ...","warning");

    mThread.requestAbort = true;

    //TBD - handle deleting any partially completed HDF5 files

    logMessage("Done");
}

void MainWindow::on_stopMeasurementButton_clicked()
{
   CloseDownThreads();
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
