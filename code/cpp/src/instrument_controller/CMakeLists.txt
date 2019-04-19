message(“Configuring instrument controller components”)

add_subdirectory(vxi11)

set (instInterfaces_SRCS
     instrumentControllerInterface.cpp
     instrumentControllerMock.cpp
     instrumentWrapper.cpp
     instrumentControllerBase.cpp
     instrumentController.cpp
     )

set(instInterfaces_HDRS
        instrumentController.h
        instrumentControllerMock.h
        instrumentControllerInterface.h
        instrumentExceptions.h
        instrumentWrapper.h
        instrumentControllerBase.h
	)

add_library(instrumentInterfaceLibrary ${instInterfaces_HDRS} ${instInterfaces_SRCS})
target_link_libraries(instrumentInterfaceLibrary vxi11Wrapper ${GPERFTOOLS_LIBRARIES} gmock_main )

add_subdirectory(tests)
