/**
* @file stringUtilities.h
* @brief Header File for the string utilities functions
* @details This collection of functions provides string utilities to trim whitespace
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef STRINGUTILITIES_H
#define STRINGUTILITIES_H
#include <iostream>
#include <string>

std::string trim(const std::string& str,
                 const std::string& whitespace = " \t");

std::string reduce(const std::string& str,
                   const std::string& fill = " ",
                   const std::string& whitespace = " \t");
#endif //STRINGUTILITIES_H
