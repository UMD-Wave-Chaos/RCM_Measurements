/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.12.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>
#include "qchartview.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QGroupBox *groupBox;
    QLabel *label;
    QLabel *label_2;
    QLabel *label_3;
    QLabel *pnaConnectionLabel;
    QLabel *motorStatusLabel;
    QLabel *systemStatusLabel;
    QPushButton *calibrateButton;
    QPushButton *measureDataButton;
    QPushButton *editConfigButton;
    QPushButton *reloadConfigButton;
    QPushButton *stopMeasurementButton;
    QLabel *label_4;
    QLabel *label_5;
    QLabel *motorPositionLabel;
    QLabel *calibrationStatusLabel;
    QLabel *label_6;
    QLabel *fileNameLabel;
    QtCharts::QChartView *realChartView;
    QtCharts::QChartView *imagChartView;
    QTextBrowser *logMessageWindow;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(1194, 821);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        groupBox = new QGroupBox(centralWidget);
        groupBox->setObjectName(QString::fromUtf8("groupBox"));
        groupBox->setGeometry(QRect(10, 420, 1171, 141));
        QFont font;
        font.setBold(false);
        font.setWeight(50);
        groupBox->setFont(font);
        label = new QLabel(groupBox);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(10, 50, 131, 16));
        label_2 = new QLabel(groupBox);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(10, 80, 171, 16));
        label_3 = new QLabel(groupBox);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(10, 110, 131, 16));
        pnaConnectionLabel = new QLabel(groupBox);
        pnaConnectionLabel->setObjectName(QString::fromUtf8("pnaConnectionLabel"));
        pnaConnectionLabel->setGeometry(QRect(140, 50, 200, 16));
        pnaConnectionLabel->setScaledContents(false);
        pnaConnectionLabel->setAlignment(Qt::AlignCenter);
        motorStatusLabel = new QLabel(groupBox);
        motorStatusLabel->setObjectName(QString::fromUtf8("motorStatusLabel"));
        motorStatusLabel->setGeometry(QRect(140, 80, 200, 16));
        motorStatusLabel->setScaledContents(false);
        motorStatusLabel->setAlignment(Qt::AlignCenter);
        systemStatusLabel = new QLabel(groupBox);
        systemStatusLabel->setObjectName(QString::fromUtf8("systemStatusLabel"));
        systemStatusLabel->setGeometry(QRect(140, 110, 200, 16));
        systemStatusLabel->setScaledContents(false);
        systemStatusLabel->setAlignment(Qt::AlignCenter);
        calibrateButton = new QPushButton(groupBox);
        calibrateButton->setObjectName(QString::fromUtf8("calibrateButton"));
        calibrateButton->setGeometry(QRect(780, 105, 165, 32));
        measureDataButton = new QPushButton(groupBox);
        measureDataButton->setObjectName(QString::fromUtf8("measureDataButton"));
        measureDataButton->setGeometry(QRect(780, 45, 165, 32));
        editConfigButton = new QPushButton(groupBox);
        editConfigButton->setObjectName(QString::fromUtf8("editConfigButton"));
        editConfigButton->setGeometry(QRect(780, 75, 165, 32));
        reloadConfigButton = new QPushButton(groupBox);
        reloadConfigButton->setObjectName(QString::fromUtf8("reloadConfigButton"));
        reloadConfigButton->setGeometry(QRect(990, 75, 165, 32));
        stopMeasurementButton = new QPushButton(groupBox);
        stopMeasurementButton->setObjectName(QString::fromUtf8("stopMeasurementButton"));
        stopMeasurementButton->setGeometry(QRect(990, 45, 165, 32));
        label_4 = new QLabel(groupBox);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setGeometry(QRect(380, 50, 131, 16));
        label_5 = new QLabel(groupBox);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setGeometry(QRect(380, 80, 131, 16));
        motorPositionLabel = new QLabel(groupBox);
        motorPositionLabel->setObjectName(QString::fromUtf8("motorPositionLabel"));
        motorPositionLabel->setGeometry(QRect(510, 80, 200, 16));
        motorPositionLabel->setScaledContents(false);
        motorPositionLabel->setAlignment(Qt::AlignCenter);
        calibrationStatusLabel = new QLabel(groupBox);
        calibrationStatusLabel->setObjectName(QString::fromUtf8("calibrationStatusLabel"));
        calibrationStatusLabel->setGeometry(QRect(510, 50, 200, 16));
        calibrationStatusLabel->setScaledContents(false);
        calibrationStatusLabel->setAlignment(Qt::AlignCenter);
        label_6 = new QLabel(groupBox);
        label_6->setObjectName(QString::fromUtf8("label_6"));
        label_6->setGeometry(QRect(380, 110, 131, 16));
        fileNameLabel = new QLabel(groupBox);
        fileNameLabel->setObjectName(QString::fromUtf8("fileNameLabel"));
        fileNameLabel->setGeometry(QRect(510, 110, 200, 16));
        fileNameLabel->setScaledContents(false);
        fileNameLabel->setAlignment(Qt::AlignCenter);
        realChartView = new QtCharts::QChartView(centralWidget);
        realChartView->setObjectName(QString::fromUtf8("realChartView"));
        realChartView->setGeometry(QRect(10, 10, 591, 401));
        imagChartView = new QtCharts::QChartView(centralWidget);
        imagChartView->setObjectName(QString::fromUtf8("imagChartView"));
        imagChartView->setGeometry(QRect(610, 10, 571, 401));
        logMessageWindow = new QTextBrowser(centralWidget);
        logMessageWindow->setObjectName(QString::fromUtf8("logMessageWindow"));
        logMessageWindow->setGeometry(QRect(10, 570, 1171, 181));
        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1194, 22));
        MainWindow->setMenuBar(menuBar);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QString::fromUtf8("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindow->setStatusBar(statusBar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "RCM Measurement GUI", nullptr));
        groupBox->setTitle(QApplication::translate("MainWindow", "Status and Control", nullptr));
        label->setText(QApplication::translate("MainWindow", "PNA Connection:", nullptr));
        label_2->setText(QApplication::translate("MainWindow", "Motor Connection:", nullptr));
        label_3->setText(QApplication::translate("MainWindow", "Mode:", nullptr));
        pnaConnectionLabel->setText(QApplication::translate("MainWindow", "PNA Status", nullptr));
        motorStatusLabel->setText(QApplication::translate("MainWindow", "Motor Status", nullptr));
        systemStatusLabel->setText(QApplication::translate("MainWindow", "System Status", nullptr));
        calibrateButton->setText(QApplication::translate("MainWindow", "Calibrate", nullptr));
        measureDataButton->setText(QApplication::translate("MainWindow", "Measure Data", nullptr));
        editConfigButton->setText(QApplication::translate("MainWindow", "Edit Config", nullptr));
        reloadConfigButton->setText(QApplication::translate("MainWindow", "Reload Config", nullptr));
        stopMeasurementButton->setText(QApplication::translate("MainWindow", "Stop Measurements", nullptr));
        label_4->setText(QApplication::translate("MainWindow", "Calibration Status:", nullptr));
        label_5->setText(QApplication::translate("MainWindow", "Motor Position:", nullptr));
        motorPositionLabel->setText(QApplication::translate("MainWindow", "Motor Position", nullptr));
        calibrationStatusLabel->setText(QApplication::translate("MainWindow", "Calibration Status", nullptr));
        label_6->setText(QApplication::translate("MainWindow", "Output File Name:", nullptr));
        fileNameLabel->setText(QApplication::translate("MainWindow", "File Name", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
