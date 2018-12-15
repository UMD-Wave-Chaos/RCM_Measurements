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
           gateStart = -10e-9;
           gateStop = 15e-9;
           xformStart = -5e-6;
           xformStop = 5e-6;
      }
      virtual void TearDown()
       {
           if (mc != nullptr)
               delete mc;
       }

      measurementController *mc;
      std::string settingsFileName;
      double gateStart, gateStop;
      double xformStart, xformStop;

      void runTestSequence()
      {
          try
          {
              mc->updateSettings(settingsFileName);
              mc->printSettings();
              mc->establishConnections();
              if(mc->getConnected() == true)
              {
                  mc->measureTimeDomainSParameters(xformStart,xformStop);
                  mc->measureUngatedFrequencyDomainSParameters();
                  mc->measureGatedFrequencyDomainSParameters(gateStart,gateStop);
                  mc->measureTimeDomainSParameters(xformStart,xformStop);
                  mc->measureUngatedFrequencyDomainSParameters();
                  mc->measureGatedFrequencyDomainSParameters(gateStart,gateStop);
              }
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

    };

    //mock sequence
    TEST_F(measurementController_Test,test_mock_sequence)
    {
      std::cout<<"Running test suite with Mock object" << std::endl;
      mc = new measurementController(true);
      EXPECT_THAT(mc->getTestMode(),Eq(true));
      runTestSequence();

    }


    //full sequence
    TEST_F(measurementController_Test,test_full_sequence)
    {
        std::cout<<"Running test suite with True object" << std::endl;
        mc = new measurementController(false);
        EXPECT_THAT(mc->getTestMode(),Eq(false));
        runTestSequence();

    }

    //mock next realization
    TEST_F(measurementController_Test,test_mock_next_realization)
    {
      std::cout<<"Running next realization test with Mock object" << std::endl;
      try
      {
          mc = new measurementController(true);
          EXPECT_THAT(mc->getTestMode(),Eq(true));
          mc->updateSettings(settingsFileName);
          mc->printSettings();
          mc->establishConnections();
          std::cout<<"Starting measurement" << std::endl;
          mc->captureNextRealization();
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


    //full next realization
    TEST_F(measurementController_Test,test_full_next_realization)
    {
        try
        {
            std::cout<<"Running next realization test with True object" << std::endl;
            mc = new measurementController(false);
            EXPECT_THAT(mc->getTestMode(),Eq(false));
            mc->updateSettings(settingsFileName);
            mc->printSettings();
            mc->establishConnections();

            std::cout<<"Starting measurement" << std::endl;
            mc->captureNextRealization();
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
