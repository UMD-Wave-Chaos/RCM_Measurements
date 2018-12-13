/**
* @file pnaControllerMock.cpp
* @brief Implementation of the pnaControllerMock class
* @details This class mocks the class that controls the Agilent PNA for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/

#include "pnaControllerMock.h"


pnaControllerMock::pnaControllerMock()
{
    connected = false;
}

pnaControllerMock::~pnaControllerMock()
{

}
