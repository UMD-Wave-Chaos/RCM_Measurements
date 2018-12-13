add_executable(vxi_test vxi11_test.cc)
target_link_libraries(vxi_test vxi11Library ${GRPC_LIBRARIES})
