/**
* @file measurementThread.h
* @brief Header File for the measurementThread class
* @details This class handles the threading to separate measurement functionality
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef MEASUREMENTTHREAD_H
#define MEASUREMENTTHREAD_H
#include <QThread>
#include <QWaitCondition>
#include <QSize>
#include "measurementController.h"
#include "stringUtilities.h"

extern QMutex globalMutex;
extern QWaitCondition globalWaitCondition;

class measurementThread : public QThread
{
    Q_OBJECT

public:
    measurementThread(QObject *parent = 0);
    ~measurementThread();

    void measure(measurementController *mControl);

    bool requestAbort;

signals:
    void infoStringAvailable(const std::string infoString, const std::string severity);
    void measurementComplete();
    void calFileNameAvailable(bool status, std::string calName);
    void readyToStepMotor();
    void outputFileNameAvailable(std::string fileName);
    void freqDataAvailable();
    void readyForUserInput();

protected:
    void run();

private:
    bool restart;
    bool abort;
    bool initialized;
    measurementController *mc;

};

#endif // MEASUREMENTTHREAD_H
