/**
* @file vectorSignalUtilities.cpp
* @brief Implementation of the vector signal utilities functions
* @details This collection of functions provides vector signal utilities
* @author Ben Frazier
* @date 12/15/2018*/

#include "vectorSignalUtilities.h"
/**
 * \brief decimate
 *
 * This function decimates an input array by an integer value*/
std::vector<double> decimate(int M, const std::vector<double>& arr)

{

    std::vector<double> decimated;
   for (size_t i = 0; i < arr.size(); i = i + M)
       {
               decimated.push_back(arr[i]);
       }

   return decimated;

}
