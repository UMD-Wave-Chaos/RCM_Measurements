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
    attrDataSpace = DataSpace(H5S_SCALAR);
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

 /**
* \brief WriteAttribute File
* @param input The input string to use as an attribute
* @param attrName The attribute name to use
*/
void DataLoggerHDF5::WriteAttribute(std::string input, std::string attrName)
{
/*
    //need to create a new dataset with Unlimited size to allow extending
    hsize_t      maxdims = H5S_UNLIMITED;
    hsize_t msize = 1;
    DataSpace mspace( 1, &msize, &maxdims);

    DSetCreatPropList cparms;

    cparms.setChunk( 1, &msize);

    int fill_val = 0;
    cparms.setFillValue( PredType::NATIVE_DOUBLE, &fill_val);

    attrDataSet = file_.createDataSet( "Settings", PredType::NATIVE_DOUBLE, mspace,cparms);

    StrType strtype = StrType(PredType::C_S1,H5T_VARIABLE);

    Attribute att = attrDataSet.createAttribute(attrName,strtype,DataSpace(H5S_SCALAR));
    att.write(strtype,"help");
    */
}
