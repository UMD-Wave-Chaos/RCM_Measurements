#include "instrumentWrapper.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;


namespace instrumentWrapper_Test
{
namespace testing
{
  class instrumentWrapper_Test : public Test
    {
    protected:
       instrumentWrapper_Test(){}
       ~instrumentWrapper_Test(){}

      virtual void SetUp()
      {

        fStart = 9.5e9;
        fStop = 11e9;
        gateStart = -10e-9;
        gateStop = 15e-9;
        xformStart = -5e-6;
        xformStop = 5e-6;
        ipAddress = "169.254.13.58";
        NOP = 32001;
      }
      virtual void TearDown()
       {
           if (inst != nullptr)
               delete inst;
       }

      instrumentWrapper *inst;
      double fStart, fStop;
      double gateStart, gateStop;
      double xformStart, xformStop;
      std::string ipAddress;
      unsigned int NOP;

      void runTestSequence ()
      {
          try
          {
              std::cout<<"Listing Clients ... " << std::endl;
              std::cout<< inst->findClients();

              ipAddress = inst->getConnectionIpAddress(0);

              std::cout<<"found ip address: " << ipAddress << " now connecting ... " << std::endl;

              if (inst->getConnected() == true)
              {
                  std::cout<<"Device Info: " << inst->getInstrumentDeviceString();

                  std::cout<<"Closing Connection ... " << std::endl;
                  inst->closeConnection();
                  EXPECT_THAT(inst->getConnected(), Eq(false));
              }
          }//try block
          catch (instrumentException& e)
          {
             std::cout<< e.what();
          }

      }

    };

  TEST_F(instrumentWrapper_Test,test_full)
  {
      std::cout<<"Running Test Sequence with Full PNA Object" << std::endl;
      inst = new instrumentWrapper(false);
      EXPECT_THAT(inst->getTestMode(),Eq(FALSE));

  }


    //creation, connection and disconnection test
    TEST_F(instrumentWrapper_Test,test_mock)
    {
        std::cout<<"Running Test Sequence with Mock PNA Object" << std::endl;
        inst = new instrumentWrapper(true);
        EXPECT_THAT(inst->getTestMode(),Eq(TRUE));

    }

    //create mock test


}//end namespace testing

} //end namespace pnaWrapper_Test
