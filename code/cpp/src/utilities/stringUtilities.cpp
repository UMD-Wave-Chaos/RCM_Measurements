/**
* @file stringUtilities.cpp
* @brief Implementation of  the string utilities functions
* @details This collection of functions provides string utilities to trim whitespace
* @author Ben Frazier
* @date 12/13/2018*/

#include "stringUtilities.h"
#include <algorithm>

std::string trim(const std::string& str,
                 const std::string& whitespace)
{
    const auto strBegin = str.find_first_not_of(whitespace);
    if (strBegin == std::string::npos)
        return ""; // no content

    const auto strEnd = str.find_last_not_of(whitespace);
    const auto strRange = strEnd - strBegin + 1;

    return str.substr(strBegin, strRange);
}

std::string reduce(const std::string& str,
                   const std::string& fill,
                   const std::string& whitespace)
{
    // trim first
    auto result = trim(str, whitespace);

    // replace sub ranges
    auto beginSpace = result.find_first_of(whitespace);
    while (beginSpace != std::string::npos)
    {
        const auto endSpace = result.find_first_not_of(whitespace, beginSpace);
        const auto range = endSpace - beginSpace;

        result.replace(beginSpace, range, fill);

        const auto newStart = beginSpace + fill.length();
        beginSpace = result.find_first_of(whitespace, newStart);
    }

    return result;
}

std::string newlineToHTML(std::string str)
{
    std::string::size_type pos = 0;

    while ( (pos = str.find("\n")) != std::string::npos)
    {
        str.erase(pos,1);
        str.insert(pos,"<br>");
    }

   return str;
}


std::string removeLineBreaks(std::string str)
{
    std::string::size_type pos = 0;

    while ( (pos = str.find("\n")) != std::string::npos)
    {
        str.erase(pos,1);
    }

   return str;
}


std::string to_string_with_precision(const double inputValue, const int n)
{
    std::ostringstream out;
    out.precision(n);
    out << std::fixed << inputValue;
    return out.str();
}

