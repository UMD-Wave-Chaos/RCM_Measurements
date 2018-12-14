#include "measurementController.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;


namespace measurementController_Test
{
namespace testing
{
  class measurementController_Test : public Test
    {
    protected:
       measurementController_Test(){}
       ~measurementController_Test(){}

      virtual void SetUp()
      {


      }
      virtual void TearDown()
       {
           if (mc != nullptr)
               delete mc;
       }

      measurementController *mc;


    };

    //creation, connection and disconnection test
    TEST_F(measurementController_Test,create_mock)
    {
        try
        {
           mc = new measurementController(true);

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
