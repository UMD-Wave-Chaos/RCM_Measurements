/**
* @file measurementThread.cpp
* @brief Implementation of the measurementThread class
* @details This class handles the threading to separate measurement functionality
* @author Ben Frazier
* @date 12/13/2018*/
#include "measurementThread.h"

//need to make the mutex and wait condition global so they can be accessed by
//both the measurement thread and the main window
//the single declaration is here, the "extern" declaration is in the .h file
QMutex globalMutex;
QWaitCondition globalWaitCondition;

/**
 * \brief constructor
 *
 * Primary constructor for the measurementThread class
*/
measurementThread::measurementThread(QObject *parent )
    : QThread(parent)
{
    restart = false;
    abort = false;

    requestAbort = false;
    initialized = false;

}

/**
 * \brief destructor
 *
 * Primary constructor for the measurementThread class
*/
measurementThread::~measurementThread()
{
    globalMutex.lock();
    abort = true;
    globalWaitCondition.wakeOne();
    globalMutex.unlock();

    wait();
}

/**
 * \brief measure
 *
 * This function initializes the measurement controller in the thread
*/
void measurementThread::measure(measurementController *mControl)
{
    QMutexLocker locker(&globalMutex);

    this->mc = mControl;

    if (!isRunning())
    {
        start(LowPriority);
    }
    else
    {
        restart = true;
        globalWaitCondition.wakeOne();
    }
}


/**
 * \brief run
 *
 * Primary method for the measurementThread class
*/
void measurementThread::run()
{

 std::string infoString;

  try
    {
      bool calibrated = mc->getCalibrated();
      std::string cname = removeLineBreaks(mc->getCalibrationInfo());
      emit calFileNameAvailable(calibrated,mc->getCalibrationInfo());

      //TBD - throw error if not calibrated

      mc->prepareLogging();

      globalMutex.lock();
      measurementSettings Settings = mc->getSettings();

      emit outputFileNameAvailable(Settings.outputFileName);

      infoString = "Starting Measurement " + std::to_string(1) + " of " + std::to_string(Settings.numberOfRealizations) + ".";
      emit infoStringAvailable(infoString,"info");

      time_t beginTime, endTime;
      double averageTime, predictedTime, predictedTimeMin, elapsedTime, elapsedTimeMin;

      time(&beginTime);
      for (unsigned int cnt = 0; cnt < Settings.numberOfRealizations; cnt ++)
      {
          //Step 1 - Move the stepper motor
          infoString = "Moving mode stirrer for position " + std::to_string(cnt + 1) +
                        ". Moving " + std::to_string(mc->getStepDistance()) +
                        " steps at " + std::to_string(mc->getRunSpeed() )+ " steps per second.";

          emit infoStringAvailable(infoString,"default");
          //don't actually step the motor but request the main thread to do so
          //this prevents problems in QT with accessing the socket from multiple threads
          emit readyToStepMotor();

          //Step 2 - Wait
          if (Settings.waitForUserInput == false)
          {
              infoString = "Waiting " + std::to_string(Settings.waitTime_ms) + " ms to Settle.";
              emit infoStringAvailable(infoString, "default");
              globalMutex.unlock();
              msleep(Settings.waitTime_ms);
          }
          else
          {
            infoString = "Waiting For User Response.";
            emit infoStringAvailable(infoString, "default");
            emit readyForUserInput();
            globalWaitCondition.wait(&globalMutex);
            globalMutex.unlock();
          }

          //Step 3 - Take the Ungated Frequency Measurement
          globalMutex.lock();
          infoString = "Measuring Ungated Frequency Domain";
          emit infoStringAvailable(infoString, " default");
          mc->measureUngatedFrequencyDomainSParameters();

          emit freqDataAvailable();

          //Step 4 - Take the Time Domain Measurement
          infoString = "Measuring Time Domain";
          emit infoStringAvailable(infoString, " default");
          mc->measureTimeDomainSParameters(Settings.xformStartTime,Settings.xformStopTime);

          //Step 5 - Take the Gated Frequency Domain Measurement (if requested)
          if (Settings.takeGatedMeasurement == true)
          {
              infoString = "Measuring Gated Frequency Domain";
              emit infoStringAvailable(infoString, "default");
              mc->measureGatedFrequencyDomainSParameters(Settings.gateStartTime, Settings.gateStopTime);
          }

          time(&endTime);

          elapsedTime = difftime(endTime,beginTime);
          elapsedTimeMin = elapsedTime/60.0;
          averageTime = difftime(endTime,beginTime)/static_cast<double>(cnt + 1);
          predictedTime = averageTime * static_cast<double>(Settings.numberOfRealizations - (cnt + 1));
          predictedTimeMin = predictedTime/60.0;

          infoString = "Measurement Step " + std::to_string(cnt + 1) + " of " + std::to_string(Settings.numberOfRealizations) +
                       " Completed. Elapsed time = " + to_string_with_precision(elapsedTime,2) + " s (" +
                       to_string_with_precision(elapsedTimeMin,2) + " min), Predicted remaining time = " +
                       to_string_with_precision(predictedTime,2) + " s (" +
                       to_string_with_precision(predictedTimeMin,2) + " min).";

          emit infoStringAvailable(infoString, "info");

          //Check the user requested abort
         if (requestAbort == true)
             break;
      } //end the for loop

      mc->closeLogFile();

     if (!restart)
        globalWaitCondition.wait(&globalMutex);
      restart = false;
      globalMutex.unlock();
    }//end the try statement

    catch (measurementException me)
    {
        emit infoStringAvailable(me.what(), "error");
    }

  //Announce that the measurements are finished (either aborted or naturally finished)
  if (requestAbort == true)
  {
      infoString = "Measurement Aborted.";
  }
  else
  {
      infoString = "Measurements Finished.";
  }
  emit infoStringAvailable(infoString, " default");
  emit measurementComplete();

}
