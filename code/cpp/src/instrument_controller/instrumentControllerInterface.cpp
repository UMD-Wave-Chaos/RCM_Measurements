/**
* @file instrumentControllerInterface.cpp
* @brief Implementation of the instrumentControllerInterface class
* @details This is the abstratct interface for the abstract instrument controllers, the .cpp provides the virtual destructor.
* @author Ben Frazier
* @date 04/17/2019*/
#include "instrumentControllerInterface.h"

instrumentControllerInterface::~instrumentControllerInterface() {std::cout<<"Deleting instrumentControllerInterface" << std::endl;}
