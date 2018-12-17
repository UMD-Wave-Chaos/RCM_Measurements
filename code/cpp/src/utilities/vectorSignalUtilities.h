/**
* @file vectorSignalUtilities.h
* @brief Header File for the vector signal utilities functions
* @details This collection of functions provides vector signal utilities
* @author Ben Frazier
* @date 12/15/2018*/
#ifndef VECTOR_SIGNAL_UTILITIES_H
#define VECTOR_SIGNAL_UTILITIES_H

#include <vector>


std::vector<double> decimate(int M, const std::vector<double>& arr);

#endif //VECTOR_SIGNAL_UTILITIES_H
