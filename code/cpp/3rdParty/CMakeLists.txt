message("Generating build files for googletest")
add_subdirectory(googletest)
set(GMOCK_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/googletest/googlemock/include
    CACHE PATH "Path to GMOCK Header Files")
set(GTEST_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/googletest/googletest/include
    CACHE PATH "Path to GTEST Header Files")
add_subdirectory("rapidxml-1.13")
