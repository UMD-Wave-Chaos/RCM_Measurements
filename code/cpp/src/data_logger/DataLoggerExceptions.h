/**
* @file DataLoggerExceptions.h
* @brief Header File for the DataLoggerException class
* @details This is the base class to handle exceptions for the data logger library
* @author Ben Frazier
* @date 12/17/2018*/

#ifndef DATA_LOGGER_EXCEPTIONS_H
#define DATA_LOGGER_EXCEPTIONS_H
#include <iostream>
#include <exception>

class DataLoggerException : public std::exception
{
public:
    DataLoggerException(const std::string& msg) : m_msg(msg)
    {
        std::cout << "Data Logger Library Exception - Error Message: " << m_msg << std::endl;
    }

   ~DataLoggerException()
   {

   }

   virtual const char* what() const throw ()
   {
        return m_msg.c_str();
   }

   const std::string m_msg;
};

#endif // DATA_LOGGER_EXCEPTIONS_H
