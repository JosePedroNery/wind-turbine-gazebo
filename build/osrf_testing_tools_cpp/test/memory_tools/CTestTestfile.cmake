# CMake generated Testfile for 
# Source directory: /home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/test/memory_tools
# Build directory: /home/jose/TCC/build/osrf_testing_tools_cpp/test/memory_tools
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(test_memory_tools "/home/jose/TCC/build/osrf_testing_tools_cpp/src/test_runner/test_runner" "--env" "LD_PRELOAD=/home/jose/TCC/build/osrf_testing_tools_cpp/src/memory_tools/libmemory_tools_interpose.so" "--" "/home/jose/TCC/build/osrf_testing_tools_cpp/test/memory_tools/test_memory_tools")
set_tests_properties(test_memory_tools PROPERTIES  _BACKTRACE_TRIPLES "/home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/test/memory_tools/CMakeLists.txt;11;add_test;/home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/test/memory_tools/CMakeLists.txt;0;")
