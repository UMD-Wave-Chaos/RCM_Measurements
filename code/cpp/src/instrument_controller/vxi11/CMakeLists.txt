#setup the vxi11 library
#the core library is based on old-style C code, need to setup the project accordingly
project(VXI11 C)
enable_testing()

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

add_library(vxi11Library ${VXI11_HDRS} ${VXI11_SRCS} ${GRPC_LIBRARIES})
add_subdirectory(test)

#Create the vxi11 wrapper library
project(VXI11_Wrapper CXX)
SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11")
enable_testing()

set(VXI11_Wrapper_HDRS
        vxi11_wrapper.h)

set(VXI11_Wrapper_SRCS
         vxi11_wrapper.cc)

add_library(vxi11Wrapper ${VXI11_Wrapper_HDRS} ${VXI11_Wrapper_SRCS})
target_link_libraries(vxi11Wrapper vxi11Library)

