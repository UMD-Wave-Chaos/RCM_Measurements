#Primary CMakeLists.txt file for RCM Measurement GUI
#Currently Tested for Unix Makefiles
cmake_minimum_required(VERSION 3.2.2)
project(VXI11 C)
enable_testing()

set(EXE_NAME VXI11_example)

set(VXI11_SRCS
	clnt_find_services.cc
	vxi11_clnt.c
        vxi11_xdr.c
	vxi11_svc.c
	vxi11_user.cc
	vxi11_cmd.cc
   )

set(VXI11_HDRS
	clnt_find_services.h
	vxi11_user.h
	vxi11.h
    )

set(VXI11_Wrapper_HDRS
        vxi11_wrapper.h)

set(VXI11_Wrapper_SRC
         vxi11_wrapper.cc)

add_library(vxi11Library ${VXI11_HDRS} ${VXI11_SRCS} )

#add_library(vxi11Wrapper ${VXI11_Wrapper_HDRS} ${VXI11_Wrapper_SRC} )
#target_link_libraries(vxi11Wrapper vxi11Library ${GRPC_LIBRARIES})

add_executable(${EXE_NAME} example.cc)

target_link_libraries(${EXE_NAME} vxi11Library ${GRPC_LIBRARIES})
