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

 /**
* \brief Close File
*/
void DataLoggerHDF5::CloseFile()
{
    file_.close();
}


 /**
* \brief WriteSettings
* @param input The input numeric value to use
* @param attrName The attribute name to use
*/
void DataLoggerHDF5::WriteSettings(double input, std::string attrName)
{

    DataSpace dspace(H5S_SCALAR);
    Group groupPlatform;

   if ( file_.exists("/Settings") == 0)
   {
        groupPlatform = Group(file_.createGroup("/Settings"));
   }
   else
   {
        groupPlatform = file_.openGroup("/Settings");
   }

    Attribute att = groupPlatform.createAttribute(attrName,PredType::NATIVE_DOUBLE,dspace);
    att.write(PredType::NATIVE_DOUBLE,&input);
}

 /**
* \brief WriteSettings
* @param input The input string to use
* @param attrName The attribute name to use
*/
void DataLoggerHDF5::WriteSettings(std::string input, std::string attrName)
{

    DataSpace dspace(H5S_SCALAR);
    Group groupPlatform;

    H5std_string inputH5String = H5std_string(input.c_str());

    if ( file_.exists("/Settings") == 0)
    {
         groupPlatform = Group(file_.createGroup("/Settings"));
    }
    else
    {
        groupPlatform = file_.openGroup("/Settings");
    }

    StrType strdatatype(PredType::C_S1, HDF5_STRING_SIZE);
    Attribute att = groupPlatform.createAttribute(attrName,strdatatype,dspace);
    att.write(strdatatype,(input.c_str()));
}

/**
* \brief ReadSettings
* @param output The input string to return
* @param attrName The attribute name to use
*/
void DataLoggerHDF5::ReadSettings(std::string &output, std::string attrName)
{
    Group groupPlatform = file_.openGroup("/Settings");
    Attribute att = groupPlatform.openAttribute(attrName);
     att.read(StrType(PredType::C_S1, HDF5_STRING_SIZE), output);

}

/**
* \brief ReadSettings
* @param output The input string to return
* @param attrName The attribute name to use
*/
void DataLoggerHDF5::ReadSettings(double &output, std::string attrName)
{
    Group groupPlatform = file_.openGroup("/Settings");
    Attribute att = groupPlatform.openAttribute(attrName);
    std::string buffer;
    att.read(PredType::NATIVE_DOUBLE, &buffer);
    output = atof(buffer.c_str());
}
