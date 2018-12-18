/**
* @file pnaExceptions.h
* @brief Header File for the pnaException class
* @details This is the base class to handle exceptions for the PNA controller library
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef PNA_EXCEPTIONS_H
#define PNA_EXCEPTIONS_H
#include <iostream>
#include <exception>

class pnaException : public std::exception
{
public:
    pnaException(const std::string& msg) : m_msg(msg)
    {

    }

   ~pnaException()
   {

   }

   virtual const char* what() const throw ()
   {
        return m_msg.c_str();
   }

   const std::string m_msg;
};

#endif // PNA_EXCEPTIONS_H
