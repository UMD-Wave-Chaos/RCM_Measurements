/**
* @file stepperMotorExceptions.h
* @brief Header File for the stepperMotorException class
* @details This is the base class to handle exceptions for the stepper motor controller library
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef STEPPERMOTOR_EXCEPTIONS_H
#define STEPPERMOTOR_EXCEPTIONS_H
#include <iostream>
#include <exception>

class stepperMotorException : public std::exception
{
public:
    stepperMotorException(const std::string& msg) : m_msg(msg)
    {
        std::cout << "Stepper Motor Control Library Exception - Error Message: " << m_msg << std::endl;
    }

   ~stepperMotorException()
   {

   }

   virtual const char* what() const throw ()
   {
        return m_msg.c_str();
   }

   const std::string m_msg;
};

#endif // STEPPERMOTOR_EXCEPTIONS_H
