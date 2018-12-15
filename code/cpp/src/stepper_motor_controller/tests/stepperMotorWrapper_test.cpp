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
        comport = "/dev/tty.usbserial-A600eOXn";

      }
      virtual void TearDown()
       {
           if (sm != nullptr)
               delete sm;
       }

      stepperMotorWrapper *sm;
      std::string comport;


      void runTestSequence()
      {
          try
          {
             EXPECT_THAT(sm->getConnected(), Eq(false));

             std::string pString = sm->listPorts();
             std::cout<<pString << std::endl;

             sm->setPortConfig(comport,256,1000);
             if(sm->getConnected() == true)
             {
                 EXPECT_THAT(sm->getConnected(), Eq(true));

                 std::string qs = sm->getPortName();
                 std::cout<<"Current Port: " << qs << std::endl;

                 std::cout<<"Motor Position: " << sm->getPosition() << std::endl;

                 sm->moveStepperMotor();
                 std::cout<<"Motor Position: " << sm->getPosition() << std::endl;
                 std::cout<<"Motor Position: " << sm->getPosition() << std::endl;
                 std::cout<<"Motor Position: " << sm->getPosition() << std::endl;
                 std::cout<<"Motor Position: " << sm->getPosition() << std::endl;
                 std::cout<<"Motor Position: " << sm->getPosition() << std::endl;
             }

             else if (sm->getTestMode() == true)
             {
                 std::cout<<"Running true Serial Port commands without Stepper Motor present" << std::endl;
             }

             sm->closeConnection();
             EXPECT_THAT(sm->getConnected(), Eq(false));
          }

          catch (stepperMotorException & e)
         {
            std::cout<< e.what();
         }

      }

    };

    //creation, connection and disconnection test
    TEST_F(stepperMotorWrapper_Test,test_mock)
    {
        std::cout<<"Running Mock Test Sequence of Stepper Motor" << std::endl;
        sm = new stepperMotorWrapper(true);
        EXPECT_THAT(sm->getTestMode(),Eq(true));

        runTestSequence();

    }

    //create mock test
    TEST_F(stepperMotorWrapper_Test,test_full)
    {

        std::cout<<"Running Mock Test Sequence of Stepper Motor" << std::endl;
        sm = new stepperMotorWrapper(false);
        EXPECT_THAT(sm->getTestMode(),Eq(false));

        runTestSequence();
    }

}//end namespace testing

} //end namespace stepperMotorWrapper_Test
