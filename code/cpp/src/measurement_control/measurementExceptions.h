/**
* @file measurementExceptions.h
* @brief Header File for the measurementException class
* @details This is the base class to handle exceptions for the measurement controller library
* @author Ben Frazier
* @date 12/17/2018*/

#ifndef MEASUREMENT_EXCEPTIONS_H
#define MEASUREMENT_EXCEPTIONS_H
#include <iostream>
#include <exception>

class measurementException : public std::exception
{
public:
    measurementException(const std::string& msg) : m_msg(msg)
    {

    }

   ~measurementException()
   {

   }

   virtual const char* what() const throw ()
   {
        return m_msg.c_str();
   }

   const std::string m_msg;
};

#endif // MEASUREMENT_EXCEPTIONS_H
