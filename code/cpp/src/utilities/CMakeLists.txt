message(“Configuring utilities”)

set (utility_SRCS
     stringUtilities.cpp
     )

set(utility_HDRS
        stringUtilities.h
	)

add_library(utilityLibrary ${utility_HDRS} ${utility_SRCS})
target_link_libraries(utilityLibrary ${GPERFTOOLS_LIBRARIES} gmock_main )

add_subdirectory(tests)
