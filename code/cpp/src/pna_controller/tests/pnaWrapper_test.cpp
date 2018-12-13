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

        fStart = 1.23e9;
        fStop = 15.44e9;
        ipAddress = "192.259.13.58";
        NOP = 20000;
      }
      virtual void TearDown()
       {
           if (pna != nullptr)
               delete pna;
       }

      pnaWrapper *pna;
      double fStart;
      double fStop;
      std::string ipAddress;
      int NOP;

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
    TEST_F(pnaWrapper_Test,create_full)
    {
        pna = new pnaWrapper(false);
        EXPECT_THAT(pna->getTestMode(),Eq(FALSE));
    }

    //set and check the configuration
    TEST_F(pnaWrapper_Test,set_config)
    {
        pna = new pnaWrapper(true);
        pna->setPNAConfig(fStart,fStop,ipAddress,NOP);

        double f1, f2;
        pna->getFrequencyRange(f1, f2);
        EXPECT_THAT(f1,Eq(fStart));
        EXPECT_THAT(f2,Eq(fStop));

        std::string address = pna->getIpAddress();
        ASSERT_EQ(address, ipAddress);

        int nPoints = pna->getNumberOfPoints();
        EXPECT_THAT(nPoints,Eq(NOP));
    }

}//end namespace testing

} //end namespace pnaWrapper_Test
