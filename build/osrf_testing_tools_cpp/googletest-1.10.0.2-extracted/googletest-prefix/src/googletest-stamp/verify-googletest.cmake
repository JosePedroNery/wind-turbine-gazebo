# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

if("/home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz" STREQUAL "")
  message(FATAL_ERROR "LOCAL can't be empty")
endif()

if(NOT EXISTS "/home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz")
  message(FATAL_ERROR "File not found: /home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz")
endif()

if("MD5" STREQUAL "")
  message(WARNING "File will not be verified since no URL_HASH specified")
  return()
endif()

if("39e19e5f8eae63f56f6bef65dce923d4" STREQUAL "")
  message(FATAL_ERROR "EXPECT_VALUE can't be empty")
endif()

message(STATUS "verifying file...
     file='/home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz'")

file("MD5" "/home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz" actual_value)

if(NOT "${actual_value}" STREQUAL "39e19e5f8eae63f56f6bef65dce923d4")
  message(FATAL_ERROR "error: MD5 hash of
  /home/jose/TCC/src/osrf_testing_tools_cpp/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz
does not match expected value
  expected: '39e19e5f8eae63f56f6bef65dce923d4'
    actual: '${actual_value}'
")
endif()

message(STATUS "verifying file... done")
