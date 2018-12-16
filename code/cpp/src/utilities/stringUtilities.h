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
#include <sstream>

std::string trim(const std::string& str,
                 const std::string& whitespace = " \t");

std::string reduce(const std::string& str,
                   const std::string& fill = " ",
                   const std::string& whitespace = " \t");

std::string to_string_with_precision(const double inputValue, const int n = 6);
#endif //STRINGUTILITIES_H
