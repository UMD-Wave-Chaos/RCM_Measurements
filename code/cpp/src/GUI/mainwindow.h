#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "measurementThread.h"

#include <QMainWindow>
#include <QLabel>
#include <QtCharts/QChartGlobal>
#include <QtCharts/QChartView>
#include <QtCharts/QLineSeries>
#include <QtCharts/QValueAxis>
#include <QtCharts/QAbstractAxis>
#include <QTimer>
#include <QThread>

#include "measurementController.h"

#include "rapidxml.hpp"
#include "rapidxml_utils.hpp"

Q_DECLARE_METATYPE(std::string);

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_measureDataButton_clicked();

    void on_editConfigButton_clicked();

    void on_calibrateButton_clicked();

    void on_stopMeasurementButton_clicked();

    void on_reloadConfigButton_clicked();

private:
    Ui::MainWindow *ui;
    void initializeStatusLabels();
    void updateLabel(QLabel *label, bool status, QString labelText);
    void updateLabel(QLabel *label, QString labelText);
    void updatePlot( QtCharts::QChart *plot,  QtCharts::QLineSeries *series, std::vector<double> xData, std::vector<double> yData);
    void updatePlots(std::vector<double> f, std::vector<double> S11R, std::vector<double> S11I, std::vector<double> S12R, std::vector<double> S12I, std::vector<double> S22R,  std::vector<double> S22I  );
    void initializePlots();

    void logMessage(std::string text, std::string severity);
    void logMessage(std::string text);
    void logSettings(measurementSettings settings);

    void CloseDownThreads();

    void updateGUIMode(measurementModes mode);
    bool updateSettings(std::string filename);

    std::vector<double> getMagnitude(std::vector<double> &SR,std::vector<double> &SI);
    std::vector<double> getPhase(std::vector<double> &SR,std::vector<double> &SI);
    void listConnections();

    QString getConfigFileName();

    void initializeGUI();
    void clearPlots();

    //member variables
    QString labelErrorString;
    QString labelGoodString;
    QString labelDefaultString;
    QString labelBusyString;

    QtCharts::QChart realPlot;
    QtCharts::QChart imagPlot;

    QtCharts::QLineSeries realS11, realS12, realS22;
    QtCharts::QLineSeries imagS11, imagS12, imagS22;

    uint maxPlotLength;

    measurementController *mControl;
    measurementModes mMode;

    measurementSettings Settings;

    bool testMode;

    bool plotReIm;

    measurementThread mThread;

    QTimer *updateModeTimer;
    QTimer *smTimer;

    QtCharts::QValueAxis *m_axis;

private slots:
    void updateStepperMotorStatus();
    void updateInfoString(const std::string infoString, const std::string severity);
    void updateMeasurementStatusComplete();
    void updateGUICurrentMode();
    void updateCalFileName(bool status, std::string calName);
    void updateOutputFileName(std::string fileName);
    void stepMotor();
    void plotFreqData();
};

#endif // MAINWINDOW_H
