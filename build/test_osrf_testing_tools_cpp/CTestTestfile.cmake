# CMake generated Testfile for 
# Source directory: /home/jose/TCC/src/osrf_testing_tools_cpp/test_osrf_testing_tools_cpp
# Build directory: /home/jose/TCC/build/test_osrf_testing_tools_cpp
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(test_example_memory_tools "/home/jose/TCC/install/osrf_testing_tools_cpp/lib/osrf_testing_tools_cpp/test_runner" "--env" "LD_PRELOAD=/home/jose/TCC/install/osrf_testing_tools_cpp/lib/libmemory_tools_interpose.so" "--" "/home/jose/TCC/build/test_osrf_testing_tools_cpp/test_example_memory_tools_gtest")
set_tests_properties(test_example_memory_tools PROPERTIES  TIMEOUT "60" _BACKTRACE_TRIPLES "/home/jose/TCC/install/osrf_testing_tools_cpp/share/osrf_testing_tools_cpp/cmake/osrf_testing_tools_cpp_add_test.cmake;93;add_test;/home/jose/TCC/src/osrf_testing_tools_cpp/test_osrf_testing_tools_cpp/CMakeLists.txt;29;osrf_testing_tools_cpp_add_test;/home/jose/TCC/src/osrf_testing_tools_cpp/test_osrf_testing_tools_cpp/CMakeLists.txt;0;")
add_test(test_is_not_working_gtest "/home/jose/TCC/install/osrf_testing_tools_cpp/lib/osrf_testing_tools_cpp/test_runner" "--" "/home/jose/TCC/build/test_osrf_testing_tools_cpp/test_is_not_working_gtest")
set_tests_properties(test_is_not_working_gtest PROPERTIES  TIMEOUT "60" _BACKTRACE_TRIPLES "/home/jose/TCC/install/osrf_testing_tools_cpp/share/osrf_testing_tools_cpp/cmake/osrf_testing_tools_cpp_add_test.cmake;93;add_test;/home/jose/TCC/src/osrf_testing_tools_cpp/test_osrf_testing_tools_cpp/CMakeLists.txt;39;osrf_testing_tools_cpp_add_test;/home/jose/TCC/src/osrf_testing_tools_cpp/test_osrf_testing_tools_cpp/CMakeLists.txt;0;")
subdirs("googletest-1.10.0.2-extracted/googletest-1.10.0.2-build")
