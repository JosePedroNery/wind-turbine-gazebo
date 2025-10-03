# Based on recommendation on how to integrate googletest into a CMake project:
#   https://github.com/google/googletest/tree/master/googletest#incorporating-into-an-existing-cmake-project

cmake_minimum_required(VERSION 2.8.12)

project(googletest-download NONE)

# Avoid DOWNLOAD_EXTRACT_TIMESTAMP warning for CMake >= 3.24
if (POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

include(ExternalProject)
ExternalProject_Add(googletest
  URL               "/home/jose/TCC/install/osrf_testing_tools_cpp/share/osrf_testing_tools_cpp/cmake/../../../share/osrf_testing_tools_cpp/vendor/google/googletest/release-1.10.0.2.tar.gz"
  URL_MD5           "39e19e5f8eae63f56f6bef65dce923d4"
  SOURCE_DIR        "${CMAKE_BINARY_DIR}/googletest-1.10.0.2-src"
  BINARY_DIR        "${CMAKE_BINARY_DIR}/googletest-1.10.0.2-build"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND   ""
  TEST_COMMAND      ""
  LOG_DOWNLOAD      OFF
  LOG_UPDATE        OFF
  LOG_CONFIGURE     OFF
  LOG_BUILD         OFF
  LOG_TEST          OFF
  LOG_INSTALL       OFF
)
