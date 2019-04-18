/**
* @file instrumentExceptions.h
* @brief Header File for the pnaException class
* @details This is the base class to handle exceptions for the PNA controller library
* @author Ben Frazier
* @date 04/17/2019*/

#ifndef INSTRUMENT_EXCEPTIONS_H
#define INSTRUMENT_EXCEPTIONS_H
#include <iostream>
#include <exception>

class instrumentException : public std::exception
{
public:
    instrumentException(const std::string& msg) : m_msg(msg)
    {

    }

   ~instrumentException()
   {

   }

   virtual const char* what() const throw ()
   {
        return m_msg.c_str();
   }

   const std::string m_msg;
};

#endif // INSTRUMENT_EXCEPTIONS_H
