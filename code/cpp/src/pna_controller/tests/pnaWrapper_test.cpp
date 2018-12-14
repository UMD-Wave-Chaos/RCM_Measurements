#include "pnaWrapper.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;


namespace pnaWrapper_Test
{
namespace testing
{
  class pnaWrapper_Test : public Test
    {
    protected:
       pnaWrapper_Test(){}
       ~pnaWrapper_Test(){}

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
           if (pna != nullptr)
               delete pna;
       }

      pnaWrapper *pna;
      double fStart, fStop;
      double gateStart, gateStop;
      double xformStart, xformStop;
      std::string ipAddress;
      int NOP;

      void testSParameters()
      {
          std::vector<double> S11R, S11I;
          pna->getS11Data(S11R, S11I);
          EXPECT_THAT(S11R.size(),Eq(NOP));
          EXPECT_THAT(S11I.size(),Eq(NOP));

          std::vector<double> S12R, S12I;
          pna->getS11Data(S12R, S12I);
          EXPECT_THAT(S12R.size(),Eq(NOP));
          EXPECT_THAT(S12I.size(),Eq(NOP));

          std::vector<double> S21R, S21I;
          pna->getS11Data(S21R, S21I);
          EXPECT_THAT(S21R.size(),Eq(NOP));
          EXPECT_THAT(S21I.size(),Eq(NOP));

          std::vector<double> S22R, S22I;
          pna->getS11Data(S22R, S22I);
          EXPECT_THAT(S22R.size(),Eq(NOP));
          EXPECT_THAT(S22I.size(),Eq(NOP));
      }

    };

    //creation, connection and disconnection test
    TEST_F(pnaWrapper_Test,create_mock)
    {
        try
        {
           pna = new pnaWrapper(true);
           EXPECT_THAT(pna->getTestMode(),Eq(TRUE));
           EXPECT_THAT(pna->getConnected(), Eq(FALSE));

           pna->openConnection();
           EXPECT_THAT(pna->getConnected(), Eq(TRUE));

           pna->closeConnection();
           EXPECT_THAT(pna->getConnected(), Eq(FALSE));

           pna->openConnection();
           EXPECT_THAT(pna->getConnected(), Eq(TRUE));

           //throw an exception
           pna->openConnection();
        }

        catch (pnaException& e)
       {
          std::cout<< e.what();
       }

    }

    //create mock test
    TEST_F(pnaWrapper_Test,ungated_full)
    {
        pna = new pnaWrapper(false);
        EXPECT_THAT(pna->getTestMode(),Eq(FALSE));

        std::cout<<"Listing Clients ... " << std::endl;
        pna->listClients();

        std::cout<<"Setting Configuration ... " << std::endl;
        pna->setPNAConfig(fStart, fStop, ipAddress, NOP);

        if (pna->getConnected() == true)
        {
            std::cout<<"Device Info: " << pna->getPNADeviceString();


            pna->getUngatedFrequencyDomainSParameters();
            std::vector<double> testFreq;
            pna->getFrequencyData(testFreq);
            EXPECT_THAT(testFreq.size(),Eq(NOP));
            EXPECT_THAT(testFreq[0],Eq(fStart));
            EXPECT_THAT(testFreq[32000],Eq(fStop));
            testSParameters();

            pna->getGatedFrequencyDomainSParameters(gateStart, gateStop);
            std::vector<double> testFreq1;
            pna->getFrequencyData(testFreq1);
            EXPECT_THAT(testFreq1.size(),Eq(NOP));
            EXPECT_THAT(testFreq1[0],Eq(fStart));
            EXPECT_THAT(testFreq1[32000],Eq(fStop));
            testSParameters();

            pna->getTimeDomainSParameters(xformStart, xformStop);
            std::vector<double> testTime;
            pna->getTimeData(testTime);
            EXPECT_THAT(testTime.size(),Eq(NOP));
            EXPECT_THAT(testTime[0],Eq(xformStart));
            EXPECT_THAT(testTime[32000],Eq(xformStop));
            testSParameters();


            std::cout<<"Closing Connection ... " << std::endl;
            pna->closeConnection();
            EXPECT_THAT(pna->getConnected(), Eq(true));
        }
    }

}//end namespace testing

} //end namespace pnaWrapper_Test
