/**
* @file instrumentControllerBase.cpp
* @brief Implementation of the instrumentControllerBase class
* @details This is the base class for the abstract instrument controllers
* @author Ben Frazier
* @date 04/17/2019*/
#include "instrumentControllerBase.h"

#include <functional>

/**
 * \brief constructor
 *
 * This is the primary constructor for the base pna class*/
instrumentControllerBase::instrumentControllerBase()
{
   connected = false;
}

/**
 * \brief destructor
 *
 * This is the primary destructor for the base pna class*/
instrumentControllerBase::~instrumentControllerBase()
{

}

