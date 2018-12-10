/**
* @file DataLogger_HDF5_Vector.cpp
* @brief Implementation of the Vector functions for the  DataLogger_HDF5 class
* @author Ben Frazier
* @date 08/12/2017 */

#include "DataLogger_HDF5.h"

//************************************************************************************************************
    /**
   * \brief ReadVector function
   * @param fileName The file name to read
   * @param datasetName The data set to read
   */
    std::vector<double> DataLoggerHDF5::ReadVector(std::string fileName, std::string datasetName)
    {
     //open the file and get the requested dataset
     H5File file( fileName, H5F_ACC_RDONLY);
     std::vector<double> data_out = ReadVector(0,file,datasetName);
    return data_out;
    }

//************************************************************************************************************
    /**
   * \brief ReadVector function
   * @param datasetName The data set to read
   */
    std::vector<double> DataLoggerHDF5::ReadVector(std::string datasetName)
    {
      std::vector<double> data_out = ReadVector(0,file_,datasetName);
      return data_out;
    }
    
//************************************************************************************************************
     /**
   * \brief ReadVector function
   * @param index the index to use into the file
   * @param fileName The file name to read
   * @param datasetName The data set to read
   */
    std::vector<double> DataLoggerHDF5::ReadVector(int index, std::string fileName, std::string datasetName)
    {
     H5File file( fileName, H5F_ACC_RDONLY);
     std::vector<double> data_out = ReadVector(index, file, datasetName);
  	 return data_out;
    }
  
//************************************************************************************************************
   /**
   * \brief ReadVector function
   * @param index the index to use into the file
   * @param datasetName The data set to read
   */
    std::vector<double> DataLoggerHDF5::ReadVector(int index, std::string datasetName)
    {
    std::vector<double> data_out = ReadVector(index,file_,datasetName);
  	 return data_out;
    }

//************************************************************************************************************
   /**
   * \brief ReadVector function - this is the private version that is used by all the other overloaded functions
   * @param index the index to use into the file
   * @param file The H5File object read
   * @param datasetName The data set to read
   */
	std::vector<double> DataLoggerHDF5::ReadVector(int index, H5File file, std::string datasetName)
    {
    
     //open the file and get the requested dataset
  	 DataSet dataset = file.openDataSet( datasetName);

     //get the dataspace and determine the size and rank
  	 DataSpace filespace = dataset.getSpace();
  	 int rank = filespace.getSimpleExtentNdims();

  	 DSetCreatPropList plist = dataset.getCreatePlist();
  
  	 //now get the memory size, the new dataset size, and the offset
   	 hsize_t dims[2];
   	 rank = filespace.getSimpleExtentDims( dims );
   	 rank = plist.getChunk(2,dims);
   	 hsize_t offset;
   	 offset = index * dims[0];

   	 //create the memory space
   	 DataSpace mspace(rank, &dims[0]);
    
   	 //get the file space
   	 DataSpace fspace = dataset.getSpace();
   	 //select the hyperslabs
   	 fspace.selectHyperslab( H5S_SELECT_SET, &dims[0],  &offset);
   	 
   	 std::vector<double> data_out;
   	 data_out.resize(dims[0]);
     dataset.read( &data_out[0], PredType::NATIVE_DOUBLE, mspace, fspace );
     file.close();
     
     return data_out;
    }

//************************************************************************************************************
   /**
   * \brief WriteData function - this is the private version that is used by all the other overloaded functions
   * @param index the index to use into the file
   * @param file The H5File object read
   * @param datasetName The data set to read
   */
	void DataLoggerHDF5::WriteData(std::vector<double>data, H5File file, std::string datasetName)
    {
     DataSet dataset;
     
     //check to see if the requested dataset currently exists
     if (file.exists(datasetName))
     {
		//open the dataset
     	dataset = file.openDataSet( datasetName);
     	hsize_t currentSize = dataset.getStorageSize()/8; //Assume 64-bit double values
     
    	//now get the memory size, the new dataset size, and the offset
    	hsize_t msize = data.size();
    	hsize_t offset = currentSize; 
    	hsize_t dsize = offset + data.size();

    	//create the memory space
    	DataSpace mspace( 1, &msize);

    	//extend the data set
    	dataset.extend( &dsize );
	
    	//get the file space
    	DataSpace fspace = dataset.getSpace();
    	//select the hyperslab
    	fspace.selectHyperslab( H5S_SELECT_SET, &msize, &offset);

		//write the vector
    	dataset.write( &data[0], PredType::NATIVE_DOUBLE, mspace, fspace);
     }
     else
     {
		//need to create a new dataset with Unlimited size to allow extending
        hsize_t      maxdims = H5S_UNLIMITED;
        hsize_t msize = data.size();
        DataSpace mspace( 1, &msize, &maxdims);
    
    	DSetCreatPropList cparms;

    	cparms.setChunk( 1, &msize);
        
        int fill_val = 0;
        cparms.setFillValue( PredType::NATIVE_DOUBLE, &fill_val);
       	
     	dataset = file.createDataSet( datasetName, PredType::NATIVE_DOUBLE, mspace,cparms);
		dataset.write( &data[0], PredType::NATIVE_DOUBLE, mspace);
     }
     
   file.close();
    }
  
    //************************************************************************************************************
   /**
   * \brief Write a std::vector to the File
   *
   * This function writes a data array from a std::vector of data to the specified dataset
   * @param data The data to write
   * @param datasetName The dataset to use*/
  void DataLoggerHDF5::WriteData(std::vector<double>data, std::string datasetName)
  {
  	WriteData(data, file_, datasetName);  
  }
