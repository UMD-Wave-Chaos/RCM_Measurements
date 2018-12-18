/**
* @file measurementController.cpp
* @brief Implementation of the measurementController class
* @details This class handles high level control and interface with the pna and stepper motor
* @author Ben Frazier
* @date 12/13/2018*/
#include "clnt_find_services.h"
#include "measurementController.h"
#include <chrono>
#include <thread>
#include <cmath>

/**
 * \brief constructor
 *
 * Primary constructor for the measurement Controller class
*/
measurementController::measurementController(bool mode)
{
    initialized = false;

    settingsFileName = "config.xml";

    testMode = mode;
    pnaConnected = false;
    smConnected = false;

    delayTime_ms = 0;

    fileValid = false;
    loggedFrequencyData = false;
    loggedTimeData = false;

    maxPlotLength = 256;

    //create the pna and sm objects
    pna = new pnaWrapper(testMode);
    sm = new stepperMotorWrapper(testMode);
}

/**
 * \brief getCalibrated
 *
 * This function tests the current calibration*/
bool measurementController::getCalibrated()
{
    try
    {
        return pna->checkCalibration();
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
}

/**
 * \brief getCalibrationInfo
 *
 * This function tests the current calibration and returns the fileName*/
std::string measurementController::getCalibrationInfo()
{
    try
    {
        if (pna->checkCalibration() == true)
        {
            return pna->getCalibrationFile();
        }
        else
        {
            return "Not Calibrated";
        }
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
}

/**
 * \brief downsampleSParameters
 *
 * This function downsamples the S parameters so they can be plotted quickly*/
bool measurementController::downsampleSParameters()
{
    return true;
}

/**
 * \brief updateSettings
 *
 * This function loads the settings from an input configuration file
 * @param filename the name of the configuration file to open*/
bool measurementController::updateSettings(std::string filename)
{
    try
    {
        std::fstream fs;
        fs.open(filename,std::fstream::in);

         rapidxml::file<> xmlFile(filename.c_str()); // Default template is char
         rapidxml::xml_document<> doc;
         doc.parse<0>(xmlFile.data());

         xml_node<> *configNode = doc.first_node();

         //get the comments
         xml_node<> *commentsNode = configNode->first_node("Comments");
         Settings.comments = reduce(commentsNode->value());

        //get the pna settings
        xml_node<> *pnaSettingsNode = configNode->first_node("PNA_Settings");
        xml_node<> *nPointsNode = pnaSettingsNode->first_node("NumberOfPoints");
        Settings.numberOfPoints = atoi(nPointsNode->value());
        xml_node<> *fStartNode = pnaSettingsNode->first_node("FrequencySweepStart");
        Settings.fStart = atof(fStartNode->value());
        xml_node<> *fStopNode = pnaSettingsNode->first_node("FrequencySweepStop");
        Settings.fStop = atof(fStopNode->value());
        xml_node<> *ipAddressNode = pnaSettingsNode->first_node("IP_Address");
        Settings.ipAddress = reduce(ipAddressNode->value());
        xml_node<> *xFormStartNode = pnaSettingsNode->first_node("TransformStartTime");
        Settings.xformStartTime = atof(xFormStartNode->value());
        xml_node<> *xFormStopNode = pnaSettingsNode->first_node("TransformStopTime");
        Settings.xformStopTime = atof(xFormStopNode->value());
        xml_node<> *gatingStartNode = pnaSettingsNode->first_node("GatingStartTime");
        Settings.gateStartTime = atof(gatingStartNode->value());
        xml_node<> *gatingStopNode = pnaSettingsNode->first_node("GatingStopTime");
        Settings.gateStopTime = atof(gatingStopNode->value());
        xml_node<> *takeGatedMeasurementNode = pnaSettingsNode->first_node("TakeGatedMeasurement");
        std::string takeGatedMeasurement  = reduce(takeGatedMeasurementNode->value());

        if (takeGatedMeasurement.compare("Yes") == 0)
             Settings.takeGatedMeasurement = true;
         else
             Settings.takeGatedMeasurement = false;


       //stepper motor settings
        xml_node<> *stepperMotorSettingsNode = configNode->first_node("StepperMotor_Settings");
        xml_node<> *nStepsNode = stepperMotorSettingsNode->first_node("NStepsPerRevolution");
        Settings.numberOfStepsPerRevolution = atoi(nStepsNode->value());
        xml_node<> *comPortNode = stepperMotorSettingsNode->first_node("COMport");
        Settings.COMport = reduce(comPortNode->value());
        xml_node<> *settlingTimeNode = stepperMotorSettingsNode->first_node("Settling_Time");
        Settings.settlingTime = atof(settlingTimeNode->value());
        xml_node<> *movementTimeNode = stepperMotorSettingsNode->first_node("Movement_Time");
        Settings.movementTime = atof(movementTimeNode->value());

        //compute the delay time
        delayTime_ms = static_cast<unsigned int>(Settings.movementTime*1000 + Settings.settlingTime*1000);
        Settings.waitTime_ms = static_cast<unsigned long>(Settings.movementTime*1000 + Settings.settlingTime*1000);

        //experiment settings
        xml_node<> *experimentSettingsNode = configNode->first_node("Experiment_Settings");
        xml_node<> *nRealizationsNode = experimentSettingsNode->first_node("NumberOfRealizations");
        Settings.numberOfRealizations = atoi(nRealizationsNode->value());
        xml_node<> *cavVolumeNode = experimentSettingsNode->first_node("CavityVolume");
        Settings.cavityVolume = atof(cavVolumeNode->value());
        xml_node<> *fNamePrefixNode = experimentSettingsNode->first_node("FileNamePrefix");
        Settings.outputFileNamePrefix = reduce(fNamePrefixNode->value());
        xml_node<> *timeDateStampNode = experimentSettingsNode->first_node("TimeDateStamp");
        std::string useTimeStamp = reduce(timeDateStampNode->value());
         if (useTimeStamp.compare("Yes") == 0)
             Settings.useDateStamp = true;
         else
             Settings.useDateStamp = false;

        updateTimeStamp();

         fs.close();

         //set the valid HDF5 data flags to false
         fileValid = false;
         loggedFrequencyData = false;
         loggedTimeData = false;

        return true;
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
}

bool measurementController::updateTimeStamp()
{
    //get the time stamp
      time_t now;
      time(&now);
      tm *ltm = localtime(&now);

      char timeStampBuff[50];

      std::strftime(timeStampBuff, sizeof(timeStampBuff), "%Y%m%d_%I_%M_%S", ltm);

      Settings.outputFileName = Settings.outputFileNamePrefix + "_" + timeStampBuff + ".h5";

      //For the test mode case, add a mock identifier
      if (testMode == true)
      {
          Settings.outputFileName = "mock_" + Settings.outputFileName;
          Settings.comments += " Mock Interfaces used, not real data";
      }
      return true;
}

/**
 * \brief closeLogFile
 *
 * This function closes the HDF5 file*/
bool measurementController::closeLogFile()
{

    dataLogger.CloseFile();

    return true;
}

/**
 * \brief prepareLogging
 *
 * This function updates the time stamp and opens the HDF5 file*/
bool measurementController::prepareLogging()
{

    updateTimeStamp();
    fileValid = false;

    return true;
}

 /**
  * \brief destructor
  *
  * Primary destructor for the measurement controller class*/
measurementController::~measurementController()
{
    try
   {
        delete pna;
        delete sm;
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
    catch (stepperMotorException se)
    {
        throw measurementException(se.what());
    }
}

/**
 * \brief moveStepperMotor
 *
 * This function moves the stepper motor and waits for the specified time */
void measurementController::moveStepperMotor()
{
   try
   {
        sm->moveStepperMotor();
        std::chrono::milliseconds duration(delayTime_ms);

        std::cout<<"Pausing for " << delayTime_ms/1000.0 << " seconds ... " << std::endl;
        std::this_thread::sleep_for(duration);
    }
    catch (stepperMotorException se)
    {
        throw measurementException(se.what());
    }
}

/**
 * \brief moveStepperMotorNoWait
 *
 * This function moves the stepper motor but does not wait to return - useful for threading operations */
void measurementController::moveStepperMotorNoWait()
{
   try
    {
        sm->moveStepperMotor();
    }
    catch (stepperMotorException se)
    {
        throw measurementException(se.what());
    }
}

/**
 * \brief logSettings
 *
 * This function logs the settings to the HDF5 file*/
void measurementController::logSettings()
{
    //TBD - add HDF5 logging exception
    dataLogger.WriteSettings(removeLineBreaks(Settings.comments),"comments");
    dataLogger.WriteSettings(Settings.numberOfRealizations,"numberOfRealizations");
    dataLogger.WriteSettings(Settings.numberOfPoints,"numberOfPoints");
    dataLogger.WriteSettings(Settings.fStart,"fStart");
    dataLogger.WriteSettings(Settings.fStop,"fStop");
    dataLogger.WriteSettings(Settings.COMport,"COMPort");
    dataLogger.WriteSettings(Settings.numberOfStepsPerRevolution,"numberOfStepsPerRevolution");
    dataLogger.WriteSettings(Settings.cavityVolume,"cavityVolume");
    dataLogger.WriteSettings(Settings.ipAddress,"ipAddress");
    dataLogger.WriteSettings(Settings.movementTime,"movementTime");
    dataLogger.WriteSettings(Settings.settlingTime,"settlingTime");
    dataLogger.WriteSettings(Settings.xformStartTime,"xformStartTime");
    dataLogger.WriteSettings(Settings.xformStopTime,"xformStopTime");

    if(Settings.takeGatedMeasurement == true)
    {
        dataLogger.WriteSettings("Yes","takeGatedMeasurement");
        dataLogger.WriteSettings(Settings.gateStartTime,"gateStartTime");
        dataLogger.WriteSettings(Settings.gateStopTime,"gateStopTime");
    }
    else
        dataLogger.WriteSettings("Yes","takeGatedMeasurement");
    dataLogger.WriteSettings(Settings.waitTime_ms,"waitTime_ms");
}


/**
 * \brief establishConnections
 *
 * This function opens connections to the PNA and stepper motor */
void measurementController::establishConnections()
{
    try
    {
        pna->setPNAConfig(Settings.fStart, Settings.fStop, Settings.ipAddress, Settings.numberOfPoints);

        pnaConnected = pna->getConnected();

        //compute the step distance
        int stepDistance = static_cast<int>(Settings.direction * static_cast<double>(Settings.numberOfStepsPerRevolution)/static_cast<double>(Settings.numberOfRealizations));

        //compute the run speed
        int runSpeed = static_cast<int>(static_cast<double>(stepDistance)/Settings.movementTime);

        sm->setPortConfig(Settings.COMport,stepDistance,runSpeed);
        smConnected = sm->getConnected();
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
    catch (stepperMotorException se)
    {
        throw measurementException(se.what());
    }
}

/**
 * \brief closeConnections
 *
 * This function closes connections to the PNA and stepper motor */
void measurementController::closeConnections()
{
    try
    {
        pna->closeConnection();
        sm->closeConnection();
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
    catch (stepperMotorException se)
    {
        throw measurementException(se.what());
    }
}

/**
 * \brief measureTimeDomainSParameters
 *
 * This function commands the pna to take a time domain measurement and then logs the output to the specified HDF5 file */
void measurementController::measureTimeDomainSParameters(double start_time, double stop_time)
{
    //check if the file is already opened, otherwise open it
    if (fileValid == false)
    {
        //create the HDF5 file and log the Settings
        dataLogger.CreateFile(Settings.outputFileName);
        logSettings();
        fileValid = true;
    }

    try

    {
        pna->getTimeDomainSParameters(start_time, stop_time);

        //only log time for the first measurement
        if (loggedTimeData == false)
        {
            std::vector<double> timeData;
            pna->getTimeData(timeData);
            dataLogger.WriteData(timeData,"time");
            loggedTimeData = true;
        }

        std::vector<double> S11R, S11I;
        pna->getS11Data(S11R, S11I);
        dataLogger.WriteData(S11R,"S11t_real");
        dataLogger.WriteData(S11I,"S11t_imag");

        std::vector<double> S12R, S12I;
        pna->getS12Data(S12R, S12I);
        dataLogger.WriteData(S12R,"S12t_real");
        dataLogger.WriteData(S12I,"S12t_imag");

        std::vector<double> S21R, S21I;
        pna->getS21Data(S21R, S21I);
        dataLogger.WriteData(S21R,"S21t_real");
        dataLogger.WriteData(S21I,"S21t_imag");

        std::vector<double> S22R, S22I;
        pna->getS22Data(S22R, S22I);
        dataLogger.WriteData(S22R,"S22t_real");
        dataLogger.WriteData(S22I,"S22t_imag");
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
}

/**
 * \brief measureUngatedFrequencyDomainSParameters
 *
 * This function commands the pna to take an ungated frequency domain measurement and then logs the output to the specified HDF5 file */
void measurementController::measureUngatedFrequencyDomainSParameters()
{

    //check if the file is already opened, otherwise open it
    if (fileValid == false)
    {
        //create the HDF5 file and log the Settings
        dataLogger.CreateFile(Settings.outputFileName);
        logSettings();
        fileValid = true;
    }

    try
    {
        pna->getUngatedFrequencyDomainSParameters();

        std::vector<double> freqData;
        pna->getFrequencyData(freqData);

        //only log frequency for the first measurement
        if(loggedFrequencyData == false)
        {
            dataLogger.WriteData(freqData,"freq");
            loggedFrequencyData = true;
        }

        std::vector<double> S11R, S11I;
        pna->getS11Data(S11R, S11I);
        dataLogger.WriteData(S11R,"S11f_real");
        dataLogger.WriteData(S11I,"S11f_imag");

        std::vector<double> S12R, S12I;
        pna->getS12Data(S12R, S12I);
        dataLogger.WriteData(S12R,"S12f_real");
        dataLogger.WriteData(S12I,"S12f_imag");

        std::vector<double> S21R, S21I;
        pna->getS21Data(S21R, S21I);
        dataLogger.WriteData(S21R,"S21f_real");
        dataLogger.WriteData(S21I,"S21f_imag");

        std::vector<double> S22R, S22I;
        pna->getS22Data(S22R, S22I);
        dataLogger.WriteData(S22R,"S22f_real");
        dataLogger.WriteData(S22I,"S22f_imag");

        decimateSParameters(S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I, freqData);
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }
}

/**
 * \brief decimateSignals
 *
 * This function decimates the S parameters */
void measurementController::decimateSParameters(std::vector<double> &S11R, std::vector<double> &S11I, std::vector<double> &S12R, std::vector<double> &S12I,
                                                std::vector<double> &S21R, std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I,
                                                std::vector<double> &freq)
{
    int M = floor(S11R.size()/256.0);
    freq_decimated = decimate(M,freq);

    std::transform(freq_decimated.begin(), freq_decimated.end(), freq_decimated.begin(),
                   std::bind1st(std::multiplies<double>(), 1e-9));

    S11R_decimated = decimate(M,S11R);
    S11I_decimated = decimate(M,S11I);
    S12R_decimated = decimate(M,S12R);
    S12I_decimated = decimate(M,S12I);
    S21R_decimated = decimate(M,S21R);
    S21I_decimated = decimate(M,S21I);
    S22R_decimated = decimate(M,S22R);
    S22I_decimated = decimate(M,S22I);
}

/**
 * \brief measureGatedFrequencyDomainSParameters
 *
 * This function commands the pna to take a gated frequency domain measurement and then logs the output to the specified HDF5 file */
void measurementController::measureGatedFrequencyDomainSParameters(double start_time, double stop_time)
{

    //check if the file is already opened, otherwise open it
    if (fileValid == false)
    {
        //create the HDF5 file and log the Settings
        dataLogger.CreateFile(Settings.outputFileName);
        logSettings();
        fileValid = true;
    }

    try
    {
        pna->getGatedFrequencyDomainSParameters(start_time, stop_time);

        //only log frequency for the first measurement
        if(loggedFrequencyData == false)
        {
            std::vector<double> freqData;
            pna->getFrequencyData(freqData);
            dataLogger.WriteData(freqData,"freq");
            loggedFrequencyData = true;
        }

        std::vector<double> S11R, S11I;
        pna->getS11Data(S11R, S11I);
        dataLogger.WriteData(S11R,"S11f_gated_real");
        dataLogger.WriteData(S11I,"S11f_gated_imag");

        std::vector<double> S12R, S12I;
        pna->getS12Data(S12R, S12I);
        dataLogger.WriteData(S12R,"S12f_gated_real");
        dataLogger.WriteData(S12I,"S12f_gated_imag");

        std::vector<double> S21R, S21I;
        pna->getS21Data(S21R, S21I);
        dataLogger.WriteData(S21R,"S21f_gated_real");
        dataLogger.WriteData(S21I,"S21f_gated_imag");

        std::vector<double> S22R, S22I;
        pna->getS22Data(S22R, S22I);
        dataLogger.WriteData(S22R,"S22f_gated_real");
        dataLogger.WriteData(S22I,"S22f_gated_imag");
    }
    catch (pnaException pe)
    {
        throw measurementException(pe.what());
    }

}
