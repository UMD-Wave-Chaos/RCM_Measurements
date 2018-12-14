#include "measurementController.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;

#include <unistd.h>
#define GetCurrentDir getcwd

namespace measurementController_Test
{
namespace testing
{

std::string GetCurrentWorkingDir( void ) {
  char buff[FILENAME_MAX];
  GetCurrentDir( buff, FILENAME_MAX );
  std::string current_working_dir(buff);
  return current_working_dir;
}


  class measurementController_Test : public Test
    {
    protected:
       measurementController_Test(){}
       ~measurementController_Test(){}

      virtual void SetUp()
      {
           std::cout<<"Current Path: " << GetCurrentWorkingDir() << std::endl;
           settingsFileName = "../../../../cpp/config.xml";

      }
      virtual void TearDown()
       {
           if (mc != nullptr)
               delete mc;
       }

      measurementController *mc;
      std::string settingsFileName;


    };

    //creation, connection and disconnection test
    TEST_F(measurementController_Test,create_mock)
    {
        try
        {
           mc = new measurementController(true);


           mc->updateSettings(settingsFileName);
           mc->establishConnections();
           mc->measureTimeDomainSParameters();

        }

        catch (pnaException& e)
       {
          std::cout<< e.what();
       }

       catch (stepperMotorException& e)
        {
            std::cout<< e.what();
        }
    }

}//end namespace testing

} //end namespace measurementController_Test
