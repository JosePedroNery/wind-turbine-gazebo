# CMake generated Testfile for 
# Source directory: /home/jose/TCC/src/geographic_info/geographic_msgs/test
# Build directory: /home/jose/TCC/build/geographic_msgs/test
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(validation_test "/usr/bin/python3" "-u" "/home/jose/ros2_humble/install/ament_cmake_test/share/ament_cmake_test/cmake/run_test.py" "/home/jose/TCC/build/geographic_msgs/test_results/geographic_msgs/validation_test.gtest.xml" "--package-name" "geographic_msgs" "--output-file" "/home/jose/TCC/build/geographic_msgs/ament_cmake_gtest/validation_test.txt" "--command" "/home/jose/TCC/build/geographic_msgs/test/validation_test" "--gtest_output=xml:/home/jose/TCC/build/geographic_msgs/test_results/geographic_msgs/validation_test.gtest.xml")
set_tests_properties(validation_test PROPERTIES  LABELS "gtest" REQUIRED_FILES "/home/jose/TCC/build/geographic_msgs/test/validation_test" TIMEOUT "60" WORKING_DIRECTORY "/home/jose/TCC/build/geographic_msgs/test" _BACKTRACE_TRIPLES "/home/jose/ros2_humble/install/ament_cmake_test/share/ament_cmake_test/cmake/ament_add_test.cmake;125;add_test;/home/jose/ros2_humble/install/ament_cmake_gtest/share/ament_cmake_gtest/cmake/ament_add_gtest_test.cmake;86;ament_add_test;/home/jose/ros2_humble/install/ament_cmake_gtest/share/ament_cmake_gtest/cmake/ament_add_gtest.cmake;93;ament_add_gtest_test;/home/jose/TCC/src/geographic_info/geographic_msgs/test/CMakeLists.txt;3;ament_add_gtest;/home/jose/TCC/src/geographic_info/geographic_msgs/test/CMakeLists.txt;0;")
subdirs("../gtest")
