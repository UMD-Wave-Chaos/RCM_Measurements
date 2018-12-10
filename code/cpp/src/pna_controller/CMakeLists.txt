message(“Configuring pna controller components”)

set (pnaController_SRCS
        pnaController.cpp
	)

set(pnaController_HDRS
        pnaController.h
        pnaControllerMock.h
        pnaControllerInterface.h
	)

add_library(pnaControllerLibrary ${pnaController_HDRS} ${pnaController_SRCS})
target_link_libraries(pnaControllerLibrary ${GPERFTOOLS_LIBRARIES} gmock_main)
