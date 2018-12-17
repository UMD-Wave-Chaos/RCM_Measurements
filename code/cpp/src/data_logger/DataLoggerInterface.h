/**
* @file DataLoggerInterface.h
* @brief Virtual class definition for DataLogger, defines the interface
* @author Ben Frazier
* @date 08/12/2017 */

#ifndef DATALOGGER_INTERFACE_H
#define DATALOGGER_INTERFACE_H
#include <iostream>
#include <vector>

  
class DataLoggerInterface
  {
  public:
  
  	//CreateFile
    virtual void CreateFile(std::string fileName) = 0;
    
    //WriteData overloaded types
     virtual void WriteData(std::vector<double>data, std::string datasetName) = 0;
     virtual void WriteData(double data, std::string datasetName) = 0;

    //Write Settings overloaded types
    virtual void WriteSettings(std::string input, std::string attrName)=0;
    virtual void WriteSettings(double input, std::string attrName)=0;

    //ReadData overloaded types
    virtual std::vector<double> ReadVector(std::string fileName, std::string datasetName)=0;
    virtual std::vector<double> ReadVector(std::string datasetName)=0;
    virtual std::vector<double> ReadVector(int index, std::string fileName, std::string datasetName)=0;
    virtual std::vector<double> ReadVector(int index, std::string datasetName)=0;
    
    virtual double ReadDouble(std::string fileName, std::string datasetName)=0;
    virtual double ReadDouble(std::string datasetName)=0;
    virtual double ReadDouble(int index, std::string fileName, std::string datasetName)=0;
    virtual double ReadDouble(int index, std::string datasetName)=0;
    
    //Read Settings overloaded types
    virtual void ReadSettings(std::string &output, std::string attrName)=0;
    virtual void ReadSettings(double &output, std::string attrName)=0;

    //Get functions
    virtual bool getInitialized() = 0;
    virtual std::string getFileName() = 0;    
  };


#endif
