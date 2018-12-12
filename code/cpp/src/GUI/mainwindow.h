#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QtCharts/QChartGlobal>
#include <QtCharts/QChartView>
#include <QtCharts/QLineSeries>
#include <QTimer>

#include "measurementModes.h"
#include "measurementController.h"
#include "measurementSettings.h"

#include "rapidxml.hpp"
#include "rapidxml_utils.hpp"

#include "stepperMotorControllerInterface.h"
#include "stepperMotorController.h"
#include "stepperMotorControllerMock.h"

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
    void initializeStepperMotorController();

    void logMessage(std::string text, std::string severity);
    void logMessage(std::string text);
    void logSettings(measurementSettings settings);

    void updateGUIMode(measurementModes mode);
    bool updateSettings(std::string filename);

    void initializeGUI();

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

    measurementController mControl;

    measurementSettings Settings;

    stepperMotorControllerInterface *sObj;
    bool testMode;

private slots:
    void updateStepperMotorStatus();
};

#endif // MAINWINDOW_H