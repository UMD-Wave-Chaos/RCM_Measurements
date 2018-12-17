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

    StrType strdatatype(PredType::C_S1, 500);
    Attribute att = groupPlatform.createAttribute(attrName,strdatatype,dspace);
    att.write(strdatatype,&inputH5String);

/*
     DataSet dataset = file_.openDataSet( datasetName);
    // Create new dataspace for attribute
    DataSpace attr_dataspace = DataSpace(H5S_SCALAR);

    // Create new string datatype for attribute
    StrType strdatatype(PredType::C_S1, H5T_VARIABLE); // of length 256 characters

    // Set up write buffer for attribute
    const H5std_string strwritebuf ("This attribute is of type StrType");

    Attribute myatt_in = dataset.createAttribute(attrName, strdatatype, attr_dataspace);
    myatt_in.write(strdatatype, input);

*/
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

/**
* \brief ReadSettings
* @param output The input string to return
* @param attrName The attribute name to use
*/
void DataLoggerHDF5::ReadSettings(std::string &output, std::string attrName)
{
    Group groupPlatform = file_.openGroup("/Settings");
    Attribute att = groupPlatform.openAttribute(attrName);
     att.read(StrType(PredType::C_S1, 500), output);

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
