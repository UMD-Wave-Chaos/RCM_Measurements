/**
* @file measurementController.cpp
* @brief Implementation of the measurementController class
* @details This class handles high level control and interface with the pna and stepper motor
* @author Ben Frazier
* @date 12/13/2018*/
#include "clnt_find_services.h"
#include "measurementController.h"


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

    //create the pna and sm objects
    pna = new pnaWrapper(testMode);
    sm = new stepperMotorWrapper(testMode);

}

/**
 * \brief updateSettings
 *
 * This function loads the settings from an input configuration file
 * @param filename the name of the configuration file to open*/
bool measurementController::updateSettings(std::string filename)
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
    xml_node<> *ipAddressNode = configNode->first_node("IP_Address");
    Settings.ipAddress = ipAddressNode->value();


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

    // dataLogger.CreateFile(Settings.outputFileName);
     return true;
}

 /**
  * \brief destructor
  *
  * Primary destructor for the measurement controller class*/

measurementController::~measurementController()
{
    delete pna;
    delete sm;
}

/**
 * \brief establishConnections
 *
 * This function opens connections to the PNA and stepper motor */
void measurementController::establishConnections()
{
    pna->openConnection();
    sm->openConnection();
}

/**
 * \brief closeConnections
 *
 * This function closes connections to the PNA and stepper motor */
void measurementController::closeConnections()
{
    pna->closeConnection();
    sm->closeConnection();
}

/**
 * \brief measureTimeDomainSParameters
 *
 * This function commands the pna to take a time domain measurement and then logs the output to the specified HDF5 file */
void measurementController::measureTimeDomainSParameters()
{
    pna->getTimeDomainSParameters();

    std::vector<double> timeData;
    pna->getTimeData(timeData);
    dataLogger.WriteData(timeData,"t");

    std::vector<double> S11R, S11I;
    pna->getS11Data(S11R, S11I);
    dataLogger.WriteData(S11R,"S11Rt");
    dataLogger.WriteData(S11I,"S11It");

    std::vector<double> S12R, S12I;
    pna->getS12Data(S12R, S12I);
    dataLogger.WriteData(S12R,"S12Rt");
    dataLogger.WriteData(S12I,"S12It");

    std::vector<double> S21R, S21I;
    pna->getS21Data(S21R, S21I);
    dataLogger.WriteData(S21R,"S21Rt");
    dataLogger.WriteData(S21I,"S21It");

    std::vector<double> S22R, S22I;
    pna->getS22Data(S22R, S22I);
    dataLogger.WriteData(S22R,"S22Rt");
    dataLogger.WriteData(S22I,"S22It");
}

/**
 * \brief measureUngatedFrequencyDomainSParameters
 *
 * This function commands the pna to take an ungated frequency domain measurement and then logs the output to the specified HDF5 file */

void measurementController::measureUngatedFrequencyDomainSParameters()
{
    pna->getUngatedFrequencyDomainSParameters();

    std::vector<double> freqData;
    pna->getFrequencyData(freqData);
    dataLogger.WriteData(freqData,"f");

    std::vector<double> S11R, S11I;
    pna->getS11Data(S11R, S11I);
    dataLogger.WriteData(S11R,"S11Rf");
    dataLogger.WriteData(S11I,"S11If");

    std::vector<double> S12R, S12I;
    pna->getS12Data(S12R, S12I);
    dataLogger.WriteData(S12R,"S12Rf");
    dataLogger.WriteData(S12I,"S12If");

    std::vector<double> S21R, S21I;
    pna->getS21Data(S21R, S21I);
    dataLogger.WriteData(S21R,"S21Rf");
    dataLogger.WriteData(S21I,"S21If");

    std::vector<double> S22R, S22I;
    pna->getS22Data(S22R, S22I);
    dataLogger.WriteData(S22R,"S22Rf");
    dataLogger.WriteData(S22I,"S22If");
}

/**
 * \brief measureGatedFrequencyDomainSParameters
 *
 * This function commands the pna to take a gated frequency domain measurement and then logs the output to the specified HDF5 file */
void measurementController::measureGatedFrequencyDomainSParameters()
{
    pna->getGatedFrequencyDomainSParameters();

    std::vector<double> freqData;
    pna->getFrequencyData(freqData);
    dataLogger.WriteData(freqData,"f");


    std::vector<double> S11R, S11I;
    pna->getS11Data(S11R, S11I);
    dataLogger.WriteData(S11R,"S11Rfg");
    dataLogger.WriteData(S11I,"S11Ifg");

    std::vector<double> S12R, S12I;
    pna->getS12Data(S12R, S12I);
    dataLogger.WriteData(S12R,"S12Rfg");
    dataLogger.WriteData(S12I,"S12Ifg");

    std::vector<double> S21R, S21I;
    pna->getS21Data(S21R, S21I);
    dataLogger.WriteData(S21R,"S21Rfg");
    dataLogger.WriteData(S21I,"S21Ifg");

    std::vector<double> S22R, S22I;
    pna->getS22Data(S22R, S22I);
    dataLogger.WriteData(S22R,"S22Rfg");
    dataLogger.WriteData(S22I,"S22Ifg");

}
