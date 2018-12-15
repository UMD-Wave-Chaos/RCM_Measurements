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
  std::string infoString;
  mutex.lock();
  measurementSettings Settings = mc->getSettings();

 //for loop here
  infoString = "Moving Stepper Motor";
  emit infoStringAvailable(infoString, " default");
  mc->moveStepperMotorNoWait();


  infoString = "Waiting " + std::to_string(Settings.waitTime_ms) + " ms";
  emit infoStringAvailable(infoString, " default");
  mutex.unlock();
  msleep(Settings.waitTime_ms);

  mutex.lock();
  infoString = "Measuring Ungated Frequency Domain";
  emit infoStringAvailable(infoString, " default");
  mc->measureUngatedFrequencyDomainSParameters();
  infoString = "Measuring Time Domain";
  emit infoStringAvailable(infoString, " default");
  mc->measureTimeDomainSParameters(Settings.xformStartTime,Settings.xformStopTime);
  if (Settings.takeGatedMeasurement == true)
  {
      infoString = "Measuring Gated Frequency Domain";
      emit infoStringAvailable(infoString, " default");
    mc->measureGatedFrequencyDomainSParameters(Settings.gateStartTime, Settings.gateStopTime);
  }

  //End for loop
  infoString = "Measurements Finished";
  emit infoStringAvailable(infoString, " default");
  emit measurementComplete();

  if (!restart)
      condition.wait(&mutex);
  restart = false;
  mutex.unlock();

}
