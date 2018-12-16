/**
* @file measurementThread.cpp
* @brief Implementation of the measurementThread class
* @details This class handles the threading to separate measurement functionality
* @author Ben Frazier
* @date 12/13/2018*/

#include "measurementThread.h"
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
    mutex.lock();
    abort = true;
    condition.wakeOne();
    mutex.unlock();

    wait();
}

/**
 * \brief measure
 *
 * This function initializes the measurement controller in the thread
*/
void measurementThread::measure(measurementController *mControl)
{
    QMutexLocker locker(&mutex);

    this->mc = mControl;

    if (!isRunning())
    {
        start(LowPriority);
    }
    else
    {
        restart = true;
        condition.wakeOne();
    }
}


/**
 * \brief run
 *
 * Primary method for the measurementThread class
*/
void measurementThread::run()
{

  bool calibrated = mc->getCalibrated();
  std::string cname = mc->getCalibrationInfo();
  emit calFileNameAvailable(calibrated,mc->getCalibrationInfo());

  //TBD - throw error if not calibrated

  mc->prepareLogging();

  std::string infoString;
  mutex.lock();
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
      infoString = "Waiting " + std::to_string(Settings.waitTime_ms) + " ms to Settle.";
      emit infoStringAvailable(infoString, "default");
      mutex.unlock();
      msleep(Settings.waitTime_ms);

      //Step 3 - Take the Ungated Frequency Measurement
      mutex.lock();
      infoString = "Measuring Ungated Frequency Domain";
      emit infoStringAvailable(infoString, " default");
      mc->measureUngatedFrequencyDomainSParameters();

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

  if (!restart)
      condition.wait(&mutex);
  restart = false;
  mutex.unlock();

}
