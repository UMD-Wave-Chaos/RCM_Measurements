/**
* @file DataLogger_HDF5.cpp
* @brief Implementation of the DataLogger_HDF5 class
* @author Ben Frazier
* @date 08/12/2017 */

#include "DataLogger_HDF5.h"

  /**
   * \brief Standard Constructor
   *
   */
  DataLoggerHDF5::DataLoggerHDF5():
  initialized_(false)
  {
 
  }
  
    /**
   * \brief Overloaded Constructor
   * @param fileName The file name to create
   */
  DataLoggerHDF5::DataLoggerHDF5(std::string fileName)
  {
 	CreateFile(fileName);
  }
  
  
      /**
   * \brief Create File
    * @param fileName The file name to create
   */
 void DataLoggerHDF5::CreateFile(std::string fileName)
    {
     file_ = H5File( fileName, H5F_ACC_TRUNC );
	 initialized_ = true;
	}