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

      void testSParameters()
      {
          std::vector<double> S11R, S11I;
          inst->getS11Data(S11R, S11I);
          EXPECT_THAT(S11R.size(),Eq(NOP));
          EXPECT_THAT(S11I.size(),Eq(NOP));

          std::vector<double> S12R, S12I;
          inst->getS11Data(S12R, S12I);
          EXPECT_THAT(S12R.size(),Eq(NOP));
          EXPECT_THAT(S12I.size(),Eq(NOP));

          std::vector<double> S21R, S21I;
          inst->getS11Data(S21R, S21I);
          EXPECT_THAT(S21R.size(),Eq(NOP));
          EXPECT_THAT(S21I.size(),Eq(NOP));

          std::vector<double> S22R, S22I;
          inst->getS11Data(S22R, S22I);
          EXPECT_THAT(S22R.size(),Eq(NOP));
          EXPECT_THAT(S22I.size(),Eq(NOP));
      }

      void runTestSequence ()
      {
          try
          {
              std::cout<<"Listing Clients ... " << std::endl;
              std::cout<< inst->findClients();

              ipAddress = inst->getConnectionIpAddress(0);

              std::cout<<"found ip address: " << ipAddress << " now connecting ... " << std::endl;

              std::cout<<"Setting Configuration ... " << std::endl;
              inst->setInstrumentConfiguration(fStart, fStop, ipAddress, NOP);

              if (inst->getConnected() == true)
              {
                  std::cout<<"Device Info: " << inst->getInstrumentDeviceString();

                  /*std::cout << "Getting Ungated Frequency Domain S-Parameters" << std::endl;
                  inst->getUngatedFrequencyDomainSParameters();
                  std::vector<double> testFreq;
                  inst->getFrequencyData(testFreq);
                  EXPECT_THAT(testFreq.size(),Eq(NOP));
                  EXPECT_THAT(testFreq[0],Eq(fStart));
                  EXPECT_THAT(testFreq[NOP-1],Eq(fStop));
                  testSParameters();

                  std::cout << "Getting Gated Frequency Domain S-Parameters" << std::endl;
                  inst->getGatedFrequencyDomainSParameters(gateStart, gateStop);
                  std::vector<double> testFreq1;
                  inst->getFrequencyData(testFreq1);
                  EXPECT_THAT(testFreq1.size(),Eq(NOP));
                  EXPECT_THAT(testFreq1[0],Eq(fStart));
                  EXPECT_THAT(testFreq1[NOP-1],Eq(fStop));
                  testSParameters();

                  std::cout << "Getting Time Domain S-Parameters";
                  inst->getTimeDomainSParameters(xformStart, xformStop);
                  std::vector<double> testTime;
                  inst->getTimeData(testTime);
                  EXPECT_THAT(testTime.size(),Eq(NOP));
                  EXPECT_THAT(testTime[0],Eq(xformStart));
                  EXPECT_THAT(testTime[NOP-1],Eq(xformStop));
                  testSParameters();*/


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

      runTestSequence();
  }


    //creation, connection and disconnection test
    TEST_F(instrumentWrapper_Test,test_mock)
    {
        std::cout<<"Running Test Sequence with Mock PNA Object" << std::endl;
        inst = new instrumentWrapper(true);
        EXPECT_THAT(inst->getTestMode(),Eq(TRUE));

        runTestSequence();
    }

    //create mock test


}//end namespace testing

} //end namespace pnaWrapper_Test
