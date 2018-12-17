#include "DataLogger_HDF5.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;


namespace DataLogger_Test
{
namespace testing
{
  class DataLogger_Test : public TestWithParam<std::tr1::tuple<int, int> >
    {
    protected:
       DataLogger_Test(){}
       ~DataLogger_Test(){}

      virtual void SetUp()
      {
		fileName = "test.h5";
        dl = new DataLoggerHDF5(fileName);
        size = 10;
	
      }
      virtual void TearDown(){ delete dl;}

      DataLoggerHDF5* dl;
      std::string fileName;

      int size;

    };
    
    //creation and initialization test
    TEST_F(DataLogger_Test,create_init)
    {
    	EXPECT_THAT(dl->getInitialized(),Eq(true));
    	
    	DataLoggerHDF5 dl2;
    	EXPECT_THAT(dl2.getInitialized(),Eq(false));
    	dl2.CreateFile("test2.h5");
    	EXPECT_THAT(dl2.getInitialized(),Eq(true));
    	
    }

    //write Settings
    TEST_F(DataLogger_Test, Settings)
    {
        double testInputDouble = 15.74;
        double testOutputDouble = 0;

        dl->WriteSettings(testInputDouble, "doubleValue");
     //   dl->ReadSettings(testOutputDouble, "doubleValue");
        //EXPECT_THAT(testInputDouble, Eq(testOutputDouble));


        std::string testInputString = "test input string";
        std::string testOutputString = "";
        dl->WriteSettings(testInputString, "stringValue");
       // dl->ReadSettings(testOutputString,"stringValue");

        std::string longString = "This is a long test comment that is not intended to convey any useful information otherwise. Now there are just random words being written. ";
        longString += "The intent is to exceed the typical value that a user may input as a comment to bound a maximum value for writing Settings variables as attributes. ";
        longString += "The underlying implementation of the WriteSettings function for strings uses the length of the string to set the datastorage type.";

        dl->WriteSettings(longString, "commentValue");
    }

    
    //test the write and read for std::vectors using a single operation
    TEST_F(DataLogger_Test,write_read_vector)
    {
    	std::vector<double> wVector(size);
    	for(int i = 0; i < size; i++)
			wVector[i] = rand();

    	dl->WriteData(wVector,"vector");
    	
    	std::vector<double> rVector = dl->ReadVector("vector");
	
    	EXPECT_THAT(wVector.size(), Eq(rVector.size()));
    	for(int i = 0; i < size; i++)
    		EXPECT_THAT(wVector[i], Eq(rVector[i]));

    }
    
   //test the write and read for std::vectors using two operations
   TEST_P(DataLogger_Test,write_read_vector_multiple)
    {
    	std::vector<double> wVector1(size);
    	for(int i = 0; i < size; i++)
			wVector1[i] = rand();
    	dl->WriteData(wVector1,"vector");
    	
    	std::vector<double> wVector2(size);
    	for(int i = 0; i < size; i++)
			wVector2[i] = rand();
    	dl->WriteData(wVector2,"vector");
    	
    	std::vector<double> rVector1 = dl->ReadVector(0,"vector");
    	std::vector<double> rVector2 = dl->ReadVector(1,"vector");
	
    	EXPECT_THAT(wVector1.size(), Eq(rVector1.size()));
    	EXPECT_THAT(wVector2.size(), Eq(rVector2.size()));
    	for(int i = 0; i < size; i++)
    	{
    		EXPECT_THAT(wVector1[i], Eq(rVector1[i]));
    		EXPECT_THAT(wVector2[i], Eq(rVector2[i]));
    	}
    	
    }

//test the write and read for std::vectors using different sizes
TEST_P(DataLogger_Test, write_read_vector_variable_sizes)
  {
    int const size = std::tr1::get<0>(GetParam());

    std::vector<double> wVector(size);
    for(int i = 0; i < size; i++)
		wVector[i] = rand();

    dl->WriteData(wVector,"vector");
    std::vector<double> rVector = dl->ReadVector("vector");

    EXPECT_THAT(wVector.size(), Eq(rVector.size()));
    for(int i = 0; i < size; i++)
    	EXPECT_THAT(wVector[i], Eq(rVector[i]));
  
  }
  
//test the write and read for doubles using a single operation
    TEST_F(DataLogger_Test,write_read_double)
    {
    	double w = rand();

    	dl->WriteData(w,"double");
    	
    	double r = dl->ReadDouble("double");
	
       EXPECT_THAT(w, Eq(r));
    }
    

  
 //test the write and read for everything
  TEST_P( DataLogger_Test, write_read_everything)
  {
    int const rows = std::tr1::get<0>(GetParam());
    int const cols = std::tr1::get<1>(GetParam());
    int const size = std::tr1::get<0>(GetParam());

    
    std::vector<double> wVector1(size);
    for (int i = 0; i < rows; i++)
    	wVector1[i] = rand();
    dl->WriteData(wVector1,"vector");

     double w1 = rand();
    dl->WriteData(w1,"double");

    
    //read in the first set
    std::vector<double> rVector1 = dl->ReadVector(0,"vector");
    double r1 = dl->ReadDouble(0,"double");


	EXPECT_THAT(wVector1.size(), Eq(rVector1.size()));
    for(int i = 0; i < size; i++)
    {
    	EXPECT_THAT(wVector1[i], Eq(rVector1[i]));
    }
    
    EXPECT_THAT(w1, Eq(r1));
    	
  }

    std::tr1::tuple<int,int> const SizeTable[] = {
    std::tr1::make_tuple( 1, 10),
    std::tr1::make_tuple( 10,  35),
    std::tr1::make_tuple(5, 4),
    std::tr1::make_tuple(17, 27),
    std::tr1::make_tuple(50,50),
    std::tr1::make_tuple(500,750),
};

 INSTANTIATE_TEST_CASE_P(TestWithParameters, DataLogger_Test, ::testing::ValuesIn(SizeTable));


} // namespace testing
} // namespace DataLogger_Test
