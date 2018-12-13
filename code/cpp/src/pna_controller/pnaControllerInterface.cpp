/**
* @file pnaControllerInterface.cpp
* @brief Implementation of the pnaControllerInterface class
* @details This is the base class for the PNA controllers, the .cpp provides the virtual destructor.
* @author Ben Frazier
* @date 12/13/2018*/
#include "pnaControllerInterface.h"

pnaControllerInterface::~pnaControllerInterface() {std::cout<<"Deleting pnaControllerInterface" << std::endl;}
