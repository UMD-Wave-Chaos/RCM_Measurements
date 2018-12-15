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

class measurementThread : public QThread
{
    Q_OBJECT

public:
    measurementThread(QObject *parent = 0);
    ~measurementThread();

    void measure(measurementController *mControl);

signals:
    void measuredSParametersAvailable(const double d );
    void infoStringAvailable(const std::string infoString, const std::string severity);
    void measurementComplete();

protected:
    void run();

private:

    QMutex mutex;
    QWaitCondition condition;
    bool restart;
    bool abort;
    bool initialized;
    measurementController *mc;

};

#endif // MEASUREMENTTHREAD_H
