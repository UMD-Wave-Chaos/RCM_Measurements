/**
* @file DataLogger_HDF5_Vector.cpp
* @brief Implementation of the Vector functions for the  DataLogger_HDF5 class
* @author Ben Frazier
* @date 08/12/2017 */

#include "DataLogger_HDF5.h"

//************************************************************************************************************
    /**
   * \brief ReadDouble function
   * @param fileName The file name to read
   * @param datasetName The data set to read
   */
    double DataLoggerHDF5::ReadDouble(std::string fileName, std::string datasetName)
    {
     //open the file and get the requested dataset
     H5File file( fileName, H5F_ACC_RDONLY);
    double data_out = ReadDouble(0,file,datasetName);
    return data_out;
    }

//************************************************************************************************************
    /**
   * \brief ReadDouble function
   * @param datasetName The data set to read
   */
    double DataLoggerHDF5::ReadDouble(std::string datasetName)
    {
      double data_out = ReadDouble(0,file_,datasetName);
      return data_out;
    }
    
//************************************************************************************************************
     /**
   * \brief ReadDouble function
   * @param index the index to use into the file
   * @param fileName The file name to read
   * @param datasetName The data set to read
   */
    double DataLoggerHDF5::ReadDouble(int index, std::string fileName, std::string datasetName)
    {
     H5File file( fileName, H5F_ACC_RDONLY);
     double data_out = ReadDouble(index, file, datasetName);
  	 return data_out;
    }
  
//************************************************************************************************************
   /**
   * \brief ReadDouble function
   * @param index the index to use into the file
   * @param datasetName The data set to read
   */
    double DataLoggerHDF5::ReadDouble(int index, std::string datasetName)
    {
     double data_out = ReadDouble(index,file_,datasetName);
  	 return data_out;
    }

//************************************************************************************************************
   /**
   * \brief ReadDouble function - this is the private version that is used by all the other overloaded functions
   * @param index the index to use into the file
   * @param file The H5File object read
   * @param datasetName The data set to read
   */
	double DataLoggerHDF5::ReadDouble(int index, H5File file, std::string datasetName)
    {
    
    std::vector<double> data_out = ReadVector(index,file,datasetName);
    return data_out[0];
    }
    
//************************************************************************************************************
   /**
   * \brief Write a double to the File
   *
   * This function writes a double data value to the specified dataset
   * @param data The data to write
   * @param datasetName The dataset to use*/
void DataLoggerHDF5::WriteData(double data, std::string datasetName)
{
	std::vector<double> dataVec;
	dataVec.push_back(data);
	WriteData(dataVec, datasetName);
}