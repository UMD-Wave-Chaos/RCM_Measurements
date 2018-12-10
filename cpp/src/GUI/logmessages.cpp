#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <iostream>
#include <unistd.h>

void MainWindow::logMessage(std::string text)
{
    logMessage(text, "default");
}


void MainWindow::logMessage(std::string text, std::string severity)
{

    std::string colorString;
    std::string fontTypeString;
    std::string iconString;

   if (severity.compare("error") == 0)
   {
       colorString = "red";
       iconString = "<img src=:/icons/icons/warning.gif height=16 width=16>";
       text = "<b>" + text + "</b>";
   }
   else if (severity.compare("warning") == 0)
   {
       colorString = "orange";
       iconString = "";
   }
   else if (severity.compare("info") == 0)
   {
     colorString = "blue";
     iconString = "<img src=:/icons/icons/greenarrowicon.gif height=16 width=16>";
   }
   else //default case
   {
    colorString = "gray";
    iconString = "";
    text = "<i>" + text + "</i>";
   }

   std::string messageString = iconString + " <font color =" + colorString + "> " +  text + "</font>";
   ui->logMessageWindow->append(QString::fromStdString(messageString));

}

void MainWindow::logSettings(measurementSettings settings)
{
    std::string lString;

    lString = "Comments: " + settings.comments;
    logMessage(lString);

    lString = "Number of Realizations: " + std::to_string(settings.numberOfRealizations);
    logMessage(lString);

    lString = "Number of Points: " + std::to_string(settings.numberOfPoints);
    logMessage(lString);

    lString = "Frequency Sweep Start: " + std::to_string(settings.fStart/1.0E9) + " GHz";
    logMessage(lString);

    lString = "Frequency Sweep Stop: " + std::to_string(settings.fStop/1.0E9) + " GHz";
    logMessage(lString);

    lString = "Stepper Motor Steps Per Revolution: " + std::to_string(settings.numberOfStepsPerRevolution);
    logMessage(lString);

    lString = "Stepper Motor Direction: " + std::to_string(settings.direction);
    logMessage(lString);

    lString = "Cavity Volume: " + std::to_string(settings.cavityVolume) + " m^3";
    logMessage(lString);

    lString = "COM Port: " + settings.COMport;
    logMessage(lString);

    lString = "Stepper Motor Direction: " + std::to_string(settings.smDirection);
    logMessage(lString);

    lString = "Output File Name Prefix: " + settings.outputFileNamePrefix;
    logMessage(lString);

    lString = "Use Time/Date Stamp: " + std::to_string(settings.useDateStamp);
    logMessage(lString);

    lString = "Output File Name: " + settings.outputFileName;
    logMessage(lString);

}
