message(“Configuring pna controller components”)

set (pnaController_SRCS
     pnaWrapper.cpp

     )

set(pnaController_HDRS
        pnaExceptions.h
        pnaWrapper.h
	)

add_library(pnaControllerLibrary ${pnaController_HDRS} ${pnaController_SRCS})
target_link_libraries(pnaControllerLibrary instrumentInterfaceLibrary ${GPERFTOOLS_LIBRARIES} gmock_main )

add_subdirectory(tests)
