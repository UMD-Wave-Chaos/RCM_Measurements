message(“Configuring pna controller components”)

set (pnaController_SRCS
     pnaController.cpp
     pnaControllerInterface.cpp
     pnaControllerMock.cpp
     pnaWrapper.cpp
     pnaControllerBase.cpp
     )

set(pnaController_HDRS
        pnaController.h
        pnaControllerMock.h
        pnaControllerInterface.h
        pnaExceptions.h
        pnaWrapper.h
        pnaControllerBase.h
	)

add_library(pnaControllerLibrary ${pnaController_HDRS} ${pnaController_SRCS})
target_link_libraries(pnaControllerLibrary vxi11Wrapper instrumentInterfaceLibrary ${GPERFTOOLS_LIBRARIES} gmock_main )

add_subdirectory(tests)
