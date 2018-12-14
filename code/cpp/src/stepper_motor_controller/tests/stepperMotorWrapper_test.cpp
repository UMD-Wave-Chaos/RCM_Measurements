#include "stepperMotorWrapper.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;


namespace stepperMotorWrapper_Test
{
namespace testing
{
  class stepperMotorWrapper_Test : public Test
    {
    protected:
       stepperMotorWrapper_Test(){}
       ~stepperMotorWrapper_Test(){}

      virtual void SetUp()
      {


      }
      virtual void TearDown()
       {
           if (sm != nullptr)
               delete sm;
       }

      stepperMotorWrapper *sm;
      std::string comport;

    };

    //creation, connection and disconnection test
    TEST_F(stepperMotorWrapper_Test,create_mock)
    {
        try
        {
           sm = new stepperMotorWrapper(true);
           EXPECT_THAT(sm->getTestMode(),Eq(true));
           EXPECT_THAT(sm->getConnected(), Eq(false));

           sm->openConnection();
           EXPECT_THAT(sm->getConnected(), Eq(true));

           sm->closeConnection();
           EXPECT_THAT(sm->getConnected(), Eq(false));

           sm->openConnection();
           EXPECT_THAT(sm->getConnected(), Eq(true));

           sm->listPorts();
           QString qs = sm->getPortName();
           std::cout<<"Current Port: " << qs.toStdString();

           //throw an exception
           sm->openConnection();

        }

        catch (stepperMotorException & e)
       {
          std::cout<< e.what();
       }

    }

    //create mock test
    TEST_F(stepperMotorWrapper_Test,create_full)
    {
        try
        {

        sm = new stepperMotorWrapper(false);
        EXPECT_THAT(sm->getTestMode(),Eq(false));

        sm->listPorts();

        QString qs = sm->getPortName();
        std::cout<<"Current Port: " << qs.toStdString();

        }
        catch (stepperMotorException & e)
        {
          std::cout<< e.what();
        }
    }

    //set and check the configuration
    TEST_F(stepperMotorWrapper_Test,set_config)
    {
        sm = new stepperMotorWrapper(true);
        //sm->setPortConfig();

    }

}//end namespace testing

} //end namespace stepperMotorWrapper_Test
