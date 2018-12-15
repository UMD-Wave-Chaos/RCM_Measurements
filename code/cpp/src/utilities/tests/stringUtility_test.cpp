#include "stringUtilities.h"

#include <iostream>
#include <string>
  using std::string;

#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
using ::testing::TestWithParam;


namespace stringUtility_Test
{
namespace testing
{
  class stringUtility_Test : public Test
    {
    protected:
       stringUtility_Test(){}
       ~stringUtility_Test(){}

      virtual void SetUp()
      {

      }
      virtual void TearDown()
       {

       }

};


    TEST_F(stringUtility_Test,test1)
    {

        std::string foo = "    too much\t   \tspace\t\t\t  ";
        std::string bar = "one\ntwo";

        std::cout<<"foo = " << foo << std::endl;

        std::string trimFoo = trim(foo);
        std::cout<<"Trim(foo) = " << trimFoo << std::endl;

        std::string reducedFoo = reduce(foo);
        std::cout<<"reduce(foo) = " << reducedFoo << std::endl;

        std::string reducedFooSep = reduce(foo,"-");
        std::cout<<"reduce(foo,""-"") = "<< reducedFooSep << std::endl;

        std::cout<<"bar = " << bar << std::endl;

        std::string trimBar = trim(bar);
        std::cout<<"trim(bar) = " << trimBar << std::endl;

    }

}//end namespace testing

} //end namespace stringUtility_Test
