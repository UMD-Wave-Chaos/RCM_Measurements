#include "measurementController.h"

measurementController::measurementController()
{
    initialized = false;

    settingsFileName = "config.xml";

    //temporary test mode - allows testing without hardware present
    testMode = true;


    //create the pnaController object
    if(testMode == true)
        pnaObj = new pnaControllerMock();
    else
        pnaObj = new pnaController();

    //updateSettings(settingsFileName);

    //connect to the PNA
    pnaObj->connectToInstrument();

    //TBD - connect to the stepper motor
    //sObj = new stepperMotorController();


}

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

measurementController::~measurementController()
{
    //remove the pna object
    delete pnaObj;
}

 bool measurementController::measureData()
 {

     //need to loop over the number of realizations
    // for (size_t cnt = 0; cnt < pnaObj.getNumberOfRealizations(); cnt++)
  //   {
         //move the stepper motor and wait for it to settle
         //TBD

         //take the frequency domain measurements
         //pnaObj.getFrequencyDomainSParameters();
         //log to HDF5
         //TBD
         //display

         //take the time domain measurements
        // pnaObj.getTimeDomainSParameters();
         //log to HDF5
    // }

     return true;
 }
