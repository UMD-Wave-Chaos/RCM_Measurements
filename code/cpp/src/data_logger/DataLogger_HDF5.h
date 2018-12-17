/**
* @file DataLogger_HDF5.h
* @brief Header File for the DataLogger_HDF5 class
* @author Ben Frazier
* @date 08/12/2017 */

#ifndef DATALOGGER_HDF5_H
#define DATALOGGER_HDF5_H

#include <vector>
#include <string>
#include "H5Cpp.h"

#include "DataLoggerInterface.h"

using namespace H5;

  class DataLoggerHDF5: public DataLoggerInterface
  {
  public:
    DataLoggerHDF5();
    DataLoggerHDF5(std::string fileName);
    
    virtual void CreateFile(std::string fileName);
    virtual void CloseFile();

    //WriteData overloaded types
     virtual void WriteData(std::vector<double>data, std::string datasetName);
     virtual void WriteData(double data, std::string datasetName);

    //Write Settings overloaded types
     virtual void WriteSettings(std::string input, std::string attrName);
     virtual void WriteSettings(double input, std::string attrName);
    
     virtual std::vector<double> ReadVector(std::string fileName, std::string datasetName);
     virtual std::vector<double> ReadVector(std::string datasetName);
     virtual std::vector<double> ReadVector(int index, std::string fileName, std::string datasetName);
     virtual std::vector<double> ReadVector(int index, std::string datasetName);
     
     virtual double ReadDouble(std::string fileName, std::string datasetName);
     virtual double ReadDouble(std::string datasetName);
     virtual double ReadDouble(int index, std::string fileName, std::string datasetName);
     virtual double ReadDouble(int index, std::string datasetName);
    
     virtual std::string getFileName() {return fileName_;}  
     virtual bool getInitialized() {return initialized_;}

    virtual void ReadSettings(std::string &output, std::string attrName);
    virtual void ReadSettings(double &output, std::string attrName);

  private:

	std::vector<double> ReadVector(int index, H5File file, std::string datasetName);
	double ReadDouble(int index, H5File file, std::string datasetName);
	void WriteData(std::vector<double>data, H5File file, std::string datasetName);
	
    H5File file_;
    std::string fileName_;
    bool initialized_;

  };

#endif
