# generated from
# ament_cmake_core/cmake/symlink_install/ament_cmake_symlink_install.cmake.in

# create empty symlink install manifest before starting install step
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/symlink_install_manifest.txt")

#
# Reimplement CMake install(DIRECTORY) command to use symlinks instead of
# copying resources.
#
# :param cmake_current_source_dir: The CMAKE_CURRENT_SOURCE_DIR when install
#   was invoked
# :type cmake_current_source_dir: string
# :param ARGN: the same arguments as the CMake install command.
# :type ARGN: various
#
function(ament_cmake_symlink_install_directory cmake_current_source_dir)
  cmake_parse_arguments(ARG "OPTIONAL" "DESTINATION" "DIRECTORY;PATTERN;PATTERN_EXCLUDE" ${ARGN})
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "ament_cmake_symlink_install_directory() called with "
      "unused/unsupported arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  # make destination absolute path and ensure that it exists
  if(NOT IS_ABSOLUTE "${ARG_DESTINATION}")
    set(ARG_DESTINATION "/home/jose/TCC/install/mavros_msgs/${ARG_DESTINATION}")
  endif()
  if(NOT EXISTS "${ARG_DESTINATION}")
    file(MAKE_DIRECTORY "${ARG_DESTINATION}")
  endif()

  # default pattern to include
  if(NOT ARG_PATTERN)
    set(ARG_PATTERN "*")
  endif()

  # iterate over directories
  foreach(dir ${ARG_DIRECTORY})
    # make dir an absolute path
    if(NOT IS_ABSOLUTE "${dir}")
      set(dir "${cmake_current_source_dir}/${dir}")
    endif()

    if(EXISTS "${dir}")
      # if directory has no trailing slash
      # append folder name to destination
      set(destination "${ARG_DESTINATION}")
      string(LENGTH "${dir}" length)
      math(EXPR offset "${length} - 1")
      string(SUBSTRING "${dir}" ${offset} 1 dir_last_char)
      if(NOT dir_last_char STREQUAL "/")
        get_filename_component(destination_name "${dir}" NAME)
        set(destination "${destination}/${destination_name}")
      else()
        # remove trailing slash
        string(SUBSTRING "${dir}" 0 ${offset} dir)
      endif()

      # glob recursive files
      set(relative_files "")
      foreach(pattern ${ARG_PATTERN})
        file(
          GLOB_RECURSE
          include_files
          RELATIVE "${dir}"
          "${dir}/${pattern}"
        )
        if(NOT include_files STREQUAL "")
          list(APPEND relative_files ${include_files})
        endif()
      endforeach()
      foreach(pattern ${ARG_PATTERN_EXCLUDE})
        file(
          GLOB_RECURSE
          exclude_files
          RELATIVE "${dir}"
          "${dir}/${pattern}"
        )
        if(NOT exclude_files STREQUAL "")
          list(REMOVE_ITEM relative_files ${exclude_files})
        endif()
      endforeach()
      list(SORT relative_files)

      foreach(relative_file ${relative_files})
        set(absolute_file "${dir}/${relative_file}")
        # determine link name for file including destination path
        set(symlink "${destination}/${relative_file}")

        # ensure that destination exists
        get_filename_component(symlink_dir "${symlink}" PATH)
        if(NOT EXISTS "${symlink_dir}")
          file(MAKE_DIRECTORY "${symlink_dir}")
        endif()

        _ament_cmake_symlink_install_create_symlink("${absolute_file}" "${symlink}")
      endforeach()
    else()
      if(NOT ARG_OPTIONAL)
        message(FATAL_ERROR
          "ament_cmake_symlink_install_directory() can't find '${dir}'")
      endif()
    endif()
  endforeach()
endfunction()

#
# Reimplement CMake install(FILES) command to use symlinks instead of copying
# resources.
#
# :param cmake_current_source_dir: The CMAKE_CURRENT_SOURCE_DIR when install
#   was invoked
# :type cmake_current_source_dir: string
# :param ARGN: the same arguments as the CMake install command.
# :type ARGN: various
#
function(ament_cmake_symlink_install_files cmake_current_source_dir)
  cmake_parse_arguments(ARG "OPTIONAL" "DESTINATION;RENAME" "FILES" ${ARGN})
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "ament_cmake_symlink_install_files() called with "
      "unused/unsupported arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  # make destination an absolute path and ensure that it exists
  if(NOT IS_ABSOLUTE "${ARG_DESTINATION}")
    set(ARG_DESTINATION "/home/jose/TCC/install/mavros_msgs/${ARG_DESTINATION}")
  endif()
  if(NOT EXISTS "${ARG_DESTINATION}")
    file(MAKE_DIRECTORY "${ARG_DESTINATION}")
  endif()

  if(ARG_RENAME)
    list(LENGTH ARG_FILES file_count)
    if(NOT file_count EQUAL 1)
    message(FATAL_ERROR "ament_cmake_symlink_install_files() called with "
      "RENAME argument but not with a single file")
    endif()
  endif()

  # iterate over files
  foreach(file ${ARG_FILES})
    # make file an absolute path
    if(NOT IS_ABSOLUTE "${file}")
      set(file "${cmake_current_source_dir}/${file}")
    endif()

    if(EXISTS "${file}")
      # determine link name for file including destination path
      get_filename_component(filename "${file}" NAME)
      if(NOT ARG_RENAME)
        set(symlink "${ARG_DESTINATION}/${filename}")
      else()
        set(symlink "${ARG_DESTINATION}/${ARG_RENAME}")
      endif()
      _ament_cmake_symlink_install_create_symlink("${file}" "${symlink}")
    else()
      if(NOT ARG_OPTIONAL)
        message(FATAL_ERROR
          "ament_cmake_symlink_install_files() can't find '${file}'")
      endif()
    endif()
  endforeach()
endfunction()

#
# Reimplement CMake install(PROGRAMS) command to use symlinks instead of copying
# resources.
#
# :param cmake_current_source_dir: The CMAKE_CURRENT_SOURCE_DIR when install
#   was invoked
# :type cmake_current_source_dir: string
# :param ARGN: the same arguments as the CMake install command.
# :type ARGN: various
#
function(ament_cmake_symlink_install_programs cmake_current_source_dir)
  cmake_parse_arguments(ARG "OPTIONAL" "DESTINATION" "PROGRAMS" ${ARGN})
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "ament_cmake_symlink_install_programs() called with "
      "unused/unsupported arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  # make destination an absolute path and ensure that it exists
  if(NOT IS_ABSOLUTE "${ARG_DESTINATION}")
    set(ARG_DESTINATION "/home/jose/TCC/install/mavros_msgs/${ARG_DESTINATION}")
  endif()
  if(NOT EXISTS "${ARG_DESTINATION}")
    file(MAKE_DIRECTORY "${ARG_DESTINATION}")
  endif()

  # iterate over programs
  foreach(file ${ARG_PROGRAMS})
    # make file an absolute path
    if(NOT IS_ABSOLUTE "${file}")
      set(file "${cmake_current_source_dir}/${file}")
    endif()

    if(EXISTS "${file}")
      # determine link name for file including destination path
      get_filename_component(filename "${file}" NAME)
      set(symlink "${ARG_DESTINATION}/${filename}")
      _ament_cmake_symlink_install_create_symlink("${file}" "${symlink}")
    else()
      if(NOT ARG_OPTIONAL)
        message(FATAL_ERROR
          "ament_cmake_symlink_install_programs() can't find '${file}'")
      endif()
    endif()
  endforeach()
endfunction()

#
# Reimplement CMake install(TARGETS) command to use symlinks instead of copying
# resources.
#
# :param TARGET_FILES: the absolute files, replacing the name of targets passed
#   in as TARGETS
# :type TARGET_FILES: list of files
# :param ARGN: the same arguments as the CMake install command except that
#   keywords identifying the kind of type and the DESTINATION keyword must be
#   joined with an underscore, e.g. ARCHIVE_DESTINATION.
# :type ARGN: various
#
function(ament_cmake_symlink_install_targets)
  cmake_parse_arguments(ARG "OPTIONAL" "ARCHIVE_DESTINATION;DESTINATION;LIBRARY_DESTINATION;RUNTIME_DESTINATION"
    "TARGETS;TARGET_FILES" ${ARGN})
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "ament_cmake_symlink_install_targets() called with "
      "unused/unsupported arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  # iterate over target files
  foreach(file ${ARG_TARGET_FILES})
    if(NOT IS_ABSOLUTE "${file}")
      message(FATAL_ERROR "ament_cmake_symlink_install_targets() target file "
        "'${file}' must be an absolute path")
    endif()

    # determine destination of file based on extension
    set(destination "")
    get_filename_component(fileext "${file}" EXT)
    if(fileext STREQUAL ".a" OR fileext STREQUAL ".lib")
      set(destination "${ARG_ARCHIVE_DESTINATION}")
    elseif(fileext STREQUAL ".dylib" OR fileext MATCHES "\\.so(\\.[0-9]+)?(\\.[0-9]+)?(\\.[0-9]+)?$")
      set(destination "${ARG_LIBRARY_DESTINATION}")
    elseif(fileext STREQUAL "" OR fileext STREQUAL ".dll" OR fileext STREQUAL ".exe")
      set(destination "${ARG_RUNTIME_DESTINATION}")
    endif()
    if(destination STREQUAL "")
      set(destination "${ARG_DESTINATION}")
    endif()

    # make destination an absolute path and ensure that it exists
    if(NOT IS_ABSOLUTE "${destination}")
      set(destination "/home/jose/TCC/install/mavros_msgs/${destination}")
    endif()
    if(NOT EXISTS "${destination}")
      file(MAKE_DIRECTORY "${destination}")
    endif()

    if(EXISTS "${file}")
      # determine link name for file including destination path
      get_filename_component(filename "${file}" NAME)
      set(symlink "${destination}/${filename}")
      _ament_cmake_symlink_install_create_symlink("${file}" "${symlink}")
    else()
      if(NOT ARG_OPTIONAL)
        message(FATAL_ERROR
          "ament_cmake_symlink_install_targets() can't find '${file}'")
      endif()
    endif()
  endforeach()
endfunction()

function(_ament_cmake_symlink_install_create_symlink absolute_file symlink)
  # register symlink for being removed during install step
  file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/symlink_install_manifest.txt"
    "${symlink}\n")

  # avoid any work if correct symlink is already in place
  if(EXISTS "${symlink}" AND IS_SYMLINK "${symlink}")
    get_filename_component(destination "${symlink}" REALPATH)
    get_filename_component(real_absolute_file "${absolute_file}" REALPATH)
    if(destination STREQUAL real_absolute_file)
      message(STATUS "Up-to-date symlink: ${symlink}")
      return()
    endif()
  endif()

  message(STATUS "Symlinking: ${symlink}")
  if(EXISTS "${symlink}" OR IS_SYMLINK "${symlink}")
    file(REMOVE "${symlink}")
  endif()

  execute_process(
    COMMAND "/usr/bin/cmake" "-E" "create_symlink"
      "${absolute_file}"
      "${symlink}"
  )
  # the CMake command does not provide a return code so check manually
  if(NOT EXISTS "${symlink}" OR NOT IS_SYMLINK "${symlink}")
    get_filename_component(destination "${symlink}" REALPATH)
    message(FATAL_ERROR
      "Could not create symlink '${symlink}' pointing to '${absolute_file}'")
  endif()
endfunction()

# end of template

message(STATUS "Execute custom install script")

# begin of custom install code

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/rosidl_interfaces/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/rosidl_interfaces")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/rosidl_interfaces/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/rosidl_interfaces")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_generator_c/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.h")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_generator_c/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.h")

# install(FILES "/home/jose/ros2_humble/build/ament_package/ament_package/template/environment_hook/library_path.sh" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/ros2_humble/build/ament_package/ament_package/template/environment_hook/library_path.sh" "DESTINATION" "share/mavros_msgs/environment")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/library_path.dsv" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/library_path.dsv" "DESTINATION" "share/mavros_msgs/environment")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_introspection_c/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.h")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_introspection_c/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.h")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_fastrtps_c/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN_EXCLUDE" "*.cpp")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_fastrtps_c/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN_EXCLUDE" "*.cpp")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_generator_cpp/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.hpp")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_generator_cpp/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.hpp")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_introspection_cpp/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.hpp")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_introspection_cpp/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN" "*.hpp")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_fastrtps_cpp/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN_EXCLUDE" "*.cpp")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_typesupport_fastrtps_cpp/mavros_msgs/" "DESTINATION" "include/mavros_msgs/mavros_msgs" "PATTERN_EXCLUDE" "*.cpp")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/pythonpath.sh" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/pythonpath.sh" "DESTINATION" "share/mavros_msgs/environment")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/pythonpath.dsv" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/pythonpath.dsv" "DESTINATION" "share/mavros_msgs/environment")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/ament_cmake_python/mavros_msgs/mavros_msgs.egg-info/" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs-2.10.1-py3.10.egg-info")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/ament_cmake_python/mavros_msgs/mavros_msgs.egg-info/" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs-2.10.1-py3.10.egg-info")

# install(DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_generator_py/mavros_msgs/" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs" "PATTERN_EXCLUDE" "*.pyc" "PATTERN_EXCLUDE" "__pycache__")
ament_cmake_symlink_install_directory("/home/jose/TCC/src/mavros/mavros_msgs" DIRECTORY "/home/jose/TCC/build/mavros_msgs/rosidl_generator_py/mavros_msgs/" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs" "PATTERN_EXCLUDE" "*.pyc" "PATTERN_EXCLUDE" "__pycache__")

# install("TARGETS" "mavros_msgs__rosidl_typesupport_introspection_c__pyext" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs")
include("/home/jose/TCC/build/mavros_msgs/ament_cmake_symlink_install_targets_0_${CMAKE_INSTALL_CONFIG_NAME}.cmake")

# install("TARGETS" "mavros_msgs__rosidl_typesupport_fastrtps_c__pyext" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs")
include("/home/jose/TCC/build/mavros_msgs/ament_cmake_symlink_install_targets_1_${CMAKE_INSTALL_CONFIG_NAME}.cmake")

# install("TARGETS" "mavros_msgs__rosidl_typesupport_c__pyext" "DESTINATION" "local/lib/python3.10/dist-packages/mavros_msgs")
include("/home/jose/TCC/build/mavros_msgs/ament_cmake_symlink_install_targets_2_${CMAKE_INSTALL_CONFIG_NAME}.cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ADSBVehicle.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ADSBVehicle.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ActuatorControl.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ActuatorControl.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Altitude.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Altitude.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/AttitudeTarget.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/AttitudeTarget.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CamIMUStamp.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CamIMUStamp.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CameraImageCaptured.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CameraImageCaptured.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CellularStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CellularStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CommandCode.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CommandCode.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CompanionProcessStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/CompanionProcessStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/DebugValue.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/DebugValue.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCInfo.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCInfo.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCInfoItem.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCInfoItem.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCStatusItem.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCStatusItem.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCTelemetry.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCTelemetry.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCTelemetryItem.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ESCTelemetryItem.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/EstimatorStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/EstimatorStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ExtendedState.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ExtendedState.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/FileEntry.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/FileEntry.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GPSINPUT.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GPSINPUT.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GPSRAW.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GPSRAW.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GPSRTK.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GPSRTK.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalDeviceAttitudeStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalDeviceAttitudeStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalDeviceInformation.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalDeviceInformation.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalDeviceSetAttitude.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalDeviceSetAttitude.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerInformation.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerInformation.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerSetAttitude.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerSetAttitude.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerSetPitchyaw.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerSetPitchyaw.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GimbalManagerStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GlobalPositionTarget.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/GlobalPositionTarget.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilActuatorControls.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilActuatorControls.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilControls.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilControls.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilGPS.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilGPS.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilSensor.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilSensor.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilStateQuaternion.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HilStateQuaternion.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HomePosition.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/HomePosition.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/LandingTarget.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/LandingTarget.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/LogData.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/LogData.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/LogEntry.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/LogEntry.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/MagnetometerReporter.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/MagnetometerReporter.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ManualControl.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ManualControl.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Mavlink.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Mavlink.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/MountControl.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/MountControl.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/NavControllerOutput.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/NavControllerOutput.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OnboardComputerStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OnboardComputerStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDBasicID.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDBasicID.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDOperatorID.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDOperatorID.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDSelfID.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDSelfID.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDSystem.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDSystem.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDSystemUpdate.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpenDroneIDSystemUpdate.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpticalFlow.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpticalFlow.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpticalFlowRad.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OpticalFlowRad.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OverrideRCIn.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/OverrideRCIn.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Param.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Param.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ParamEvent.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ParamEvent.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ParamValue.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/ParamValue.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/PlayTuneV2.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/PlayTuneV2.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/PositionTarget.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/PositionTarget.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RCIn.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RCIn.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RCOut.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RCOut.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RTCM.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RTCM.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RTKBaseline.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RTKBaseline.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RadioStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/RadioStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/State.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/State.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/StatusEvent.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/StatusEvent.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/StatusText.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/StatusText.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/SysStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/SysStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/TerrainReport.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/TerrainReport.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Thrust.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Thrust.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/TimesyncStatus.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/TimesyncStatus.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Trajectory.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Trajectory.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Tunnel.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Tunnel.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/VehicleInfo.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/VehicleInfo.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/VfrHud.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/VfrHud.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Vibration.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Vibration.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Waypoint.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/Waypoint.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/WaypointList.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/WaypointList.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/WaypointReached.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/WaypointReached.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/WheelOdomStamped.idl" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/msg/WheelOdomStamped.idl" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandAck.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandAck.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandBool.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandBool.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandHome.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandHome.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandInt.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandInt.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandLong.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandLong.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTOL.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTOL.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTOLLocal.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTOLLocal.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTriggerControl.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTriggerControl.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTriggerInterval.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandTriggerInterval.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandVtolTransition.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/CommandVtolTransition.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/EndpointAdd.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/EndpointAdd.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/EndpointDel.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/EndpointDel.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileChecksum.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileChecksum.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileClose.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileClose.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileList.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileList.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileMakeDir.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileMakeDir.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileOpen.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileOpen.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRead.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRead.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRemove.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRemove.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRemoveDir.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRemoveDir.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRename.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileRename.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileTruncate.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileTruncate.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileWrite.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/FileWrite.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalGetInformation.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalGetInformation.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerCameraTrack.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerCameraTrack.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerConfigure.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerConfigure.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerPitchyaw.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerPitchyaw.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerSetRoi.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/GimbalManagerSetRoi.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/LogRequestData.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/LogRequestData.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/LogRequestEnd.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/LogRequestEnd.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/LogRequestList.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/LogRequestList.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/MessageInterval.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/MessageInterval.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/MountConfigure.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/MountConfigure.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamGet.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamGet.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamPull.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamPull.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamPush.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamPush.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamSet.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamSet.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamSetV2.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/ParamSetV2.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/SetMavFrame.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/SetMavFrame.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/SetMode.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/SetMode.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/StreamRate.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/StreamRate.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/VehicleInfoGet.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/VehicleInfoGet.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointClear.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointClear.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointPull.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointPull.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointPush.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointPush.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointSetCurrent.idl" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_adapter/mavros_msgs/srv/WaypointSetCurrent.idl" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ADSBVehicle.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ADSBVehicle.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ActuatorControl.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ActuatorControl.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Altitude.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Altitude.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/AttitudeTarget.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/AttitudeTarget.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CamIMUStamp.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CamIMUStamp.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CameraImageCaptured.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CameraImageCaptured.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CellularStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CellularStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CommandCode.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CommandCode.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CompanionProcessStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/CompanionProcessStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/DebugValue.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/DebugValue.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCInfo.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCInfo.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCInfoItem.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCInfoItem.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCStatusItem.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCStatusItem.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCTelemetry.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCTelemetry.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCTelemetryItem.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ESCTelemetryItem.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/EstimatorStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/EstimatorStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ExtendedState.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ExtendedState.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/FileEntry.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/FileEntry.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GPSINPUT.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GPSINPUT.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GPSRAW.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GPSRAW.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GPSRTK.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GPSRTK.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalDeviceAttitudeStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalDeviceAttitudeStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalDeviceInformation.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalDeviceInformation.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalDeviceSetAttitude.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalDeviceSetAttitude.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerInformation.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerInformation.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerSetAttitude.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerSetAttitude.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerSetPitchyaw.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerSetPitchyaw.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GimbalManagerStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GlobalPositionTarget.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/GlobalPositionTarget.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilActuatorControls.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilActuatorControls.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilControls.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilControls.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilGPS.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilGPS.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilSensor.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilSensor.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilStateQuaternion.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HilStateQuaternion.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HomePosition.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/HomePosition.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/LandingTarget.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/LandingTarget.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/LogData.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/LogData.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/LogEntry.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/LogEntry.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/MagnetometerReporter.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/MagnetometerReporter.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ManualControl.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ManualControl.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Mavlink.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Mavlink.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/MountControl.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/MountControl.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/NavControllerOutput.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/NavControllerOutput.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OnboardComputerStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OnboardComputerStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDBasicID.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDBasicID.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDOperatorID.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDOperatorID.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDSelfID.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDSelfID.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDSystem.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDSystem.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDSystemUpdate.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpenDroneIDSystemUpdate.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpticalFlow.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpticalFlow.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpticalFlowRad.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OpticalFlowRad.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OverrideRCIn.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/OverrideRCIn.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Param.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Param.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ParamEvent.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ParamEvent.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ParamValue.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/ParamValue.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/PlayTuneV2.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/PlayTuneV2.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/PositionTarget.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/PositionTarget.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RCIn.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RCIn.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RCOut.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RCOut.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RTCM.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RTCM.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RTKBaseline.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RTKBaseline.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RadioStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/RadioStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/State.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/State.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/StatusEvent.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/StatusEvent.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/StatusText.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/StatusText.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/SysStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/SysStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/TerrainReport.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/TerrainReport.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Thrust.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Thrust.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/TimesyncStatus.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/TimesyncStatus.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Trajectory.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Trajectory.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Tunnel.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Tunnel.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/VehicleInfo.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/VehicleInfo.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/VfrHud.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/VfrHud.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Vibration.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Vibration.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Waypoint.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/Waypoint.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/WaypointList.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/WaypointList.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/WaypointReached.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/WaypointReached.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/WheelOdomStamped.msg" "DESTINATION" "share/mavros_msgs/msg")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/msg/WheelOdomStamped.msg" "DESTINATION" "share/mavros_msgs/msg")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandAck.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandAck.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandAck_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandAck_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandAck_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandAck_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandBool.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandBool.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandBool_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandBool_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandBool_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandBool_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandHome.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandHome.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandHome_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandHome_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandHome_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandHome_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandInt.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandInt.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandInt_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandInt_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandInt_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandInt_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandLong.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandLong.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandLong_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandLong_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandLong_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandLong_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTOL.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTOL.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOL_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOL_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOL_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOL_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTOLLocal.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTOLLocal.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOLLocal_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOLLocal_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOLLocal_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTOLLocal_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTriggerControl.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTriggerControl.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerControl_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerControl_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerControl_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerControl_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTriggerInterval.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandTriggerInterval.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerInterval_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerInterval_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerInterval_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandTriggerInterval_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandVtolTransition.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/CommandVtolTransition.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandVtolTransition_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandVtolTransition_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandVtolTransition_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/CommandVtolTransition_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/EndpointAdd.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/EndpointAdd.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointAdd_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointAdd_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointAdd_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointAdd_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/EndpointDel.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/EndpointDel.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointDel_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointDel_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointDel_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/EndpointDel_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileChecksum.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileChecksum.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileChecksum_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileChecksum_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileChecksum_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileChecksum_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileClose.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileClose.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileClose_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileClose_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileClose_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileClose_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileList.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileList.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileList_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileList_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileList_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileList_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileMakeDir.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileMakeDir.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileMakeDir_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileMakeDir_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileMakeDir_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileMakeDir_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileOpen.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileOpen.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileOpen_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileOpen_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileOpen_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileOpen_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRead.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRead.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRead_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRead_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRead_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRead_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRemove.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRemove.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemove_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemove_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemove_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemove_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRemoveDir.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRemoveDir.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemoveDir_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemoveDir_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemoveDir_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRemoveDir_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRename.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileRename.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRename_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRename_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRename_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileRename_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileTruncate.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileTruncate.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileTruncate_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileTruncate_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileTruncate_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileTruncate_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileWrite.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/FileWrite.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileWrite_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileWrite_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileWrite_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/FileWrite_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalGetInformation.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalGetInformation.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalGetInformation_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalGetInformation_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalGetInformation_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalGetInformation_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerCameraTrack.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerCameraTrack.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerCameraTrack_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerCameraTrack_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerCameraTrack_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerCameraTrack_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerConfigure.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerConfigure.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerConfigure_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerConfigure_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerConfigure_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerConfigure_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerPitchyaw.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerPitchyaw.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerPitchyaw_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerPitchyaw_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerPitchyaw_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerPitchyaw_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerSetRoi.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/GimbalManagerSetRoi.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerSetRoi_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerSetRoi_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerSetRoi_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/GimbalManagerSetRoi_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/LogRequestData.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/LogRequestData.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestData_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestData_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestData_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestData_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/LogRequestEnd.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/LogRequestEnd.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestEnd_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestEnd_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestEnd_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestEnd_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/LogRequestList.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/LogRequestList.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestList_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestList_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestList_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/LogRequestList_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/MessageInterval.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/MessageInterval.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MessageInterval_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MessageInterval_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MessageInterval_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MessageInterval_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/MountConfigure.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/MountConfigure.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MountConfigure_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MountConfigure_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MountConfigure_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/MountConfigure_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamGet.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamGet.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamGet_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamGet_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamGet_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamGet_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamPull.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamPull.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPull_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPull_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPull_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPull_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamPush.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamPush.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPush_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPush_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPush_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamPush_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamSet.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamSet.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSet_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSet_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSet_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSet_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamSetV2.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/ParamSetV2.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSetV2_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSetV2_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSetV2_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/ParamSetV2_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/SetMavFrame.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/SetMavFrame.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMavFrame_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMavFrame_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMavFrame_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMavFrame_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/SetMode.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/SetMode.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMode_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMode_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMode_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/SetMode_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/StreamRate.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/StreamRate.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/StreamRate_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/StreamRate_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/StreamRate_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/StreamRate_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/VehicleInfoGet.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/VehicleInfoGet.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/VehicleInfoGet_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/VehicleInfoGet_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/VehicleInfoGet_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/VehicleInfoGet_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointClear.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointClear.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointClear_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointClear_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointClear_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointClear_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointPull.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointPull.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPull_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPull_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPull_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPull_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointPush.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointPush.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPush_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPush_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPush_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointPush_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointSetCurrent.srv" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/srv/WaypointSetCurrent.srv" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointSetCurrent_Request.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointSetCurrent_Request.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointSetCurrent_Response.msg" "DESTINATION" "share/mavros_msgs/srv")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/srv/WaypointSetCurrent_Response.msg" "DESTINATION" "share/mavros_msgs/srv")

# install(FILES "mavros_msgs_mapping_rule.yaml" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "mavros_msgs_mapping_rule.yaml" "DESTINATION" "share/mavros_msgs")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/package_run_dependencies/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/package_run_dependencies")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/package_run_dependencies/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/package_run_dependencies")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/parent_prefix_path/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/parent_prefix_path")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/parent_prefix_path/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/parent_prefix_path")

# install(FILES "/home/jose/ros2_humble/install/ament_cmake_core/share/ament_cmake_core/cmake/environment_hooks/environment/ament_prefix_path.sh" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/ros2_humble/install/ament_cmake_core/share/ament_cmake_core/cmake/environment_hooks/environment/ament_prefix_path.sh" "DESTINATION" "share/mavros_msgs/environment")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/ament_prefix_path.dsv" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/ament_prefix_path.dsv" "DESTINATION" "share/mavros_msgs/environment")

# install(FILES "/home/jose/ros2_humble/install/ament_cmake_core/share/ament_cmake_core/cmake/environment_hooks/environment/path.sh" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/ros2_humble/install/ament_cmake_core/share/ament_cmake_core/cmake/environment_hooks/environment/path.sh" "DESTINATION" "share/mavros_msgs/environment")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/path.dsv" "DESTINATION" "share/mavros_msgs/environment")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/path.dsv" "DESTINATION" "share/mavros_msgs/environment")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.bash" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.bash" "DESTINATION" "share/mavros_msgs")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.sh" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.sh" "DESTINATION" "share/mavros_msgs")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.zsh" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.zsh" "DESTINATION" "share/mavros_msgs")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.dsv" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/local_setup.dsv" "DESTINATION" "share/mavros_msgs")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/package.dsv" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_environment_hooks/package.dsv" "DESTINATION" "share/mavros_msgs")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/packages/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/packages")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_index/share/ament_index/resource_index/packages/mavros_msgs" "DESTINATION" "share/ament_index/resource_index/packages")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/rosidl_cmake-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/rosidl_cmake-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_dependencies/ament_cmake_export_dependencies-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_dependencies/ament_cmake_export_dependencies-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_include_directories/ament_cmake_export_include_directories-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_include_directories/ament_cmake_export_include_directories-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_libraries/ament_cmake_export_libraries-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_libraries/ament_cmake_export_libraries-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_targets/ament_cmake_export_targets-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_export_targets/ament_cmake_export_targets-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/rosidl_cmake_export_typesupport_targets-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/rosidl_cmake_export_typesupport_targets-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/rosidl_cmake_export_typesupport_libraries-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/rosidl_cmake/rosidl_cmake_export_typesupport_libraries-extras.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_core/mavros_msgsConfig.cmake" "/home/jose/TCC/build/mavros_msgs/ament_cmake_core/mavros_msgsConfig-version.cmake" "DESTINATION" "share/mavros_msgs/cmake")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/build/mavros_msgs/ament_cmake_core/mavros_msgsConfig.cmake" "/home/jose/TCC/build/mavros_msgs/ament_cmake_core/mavros_msgsConfig-version.cmake" "DESTINATION" "share/mavros_msgs/cmake")

# install(FILES "/home/jose/TCC/src/mavros/mavros_msgs/package.xml" "DESTINATION" "share/mavros_msgs")
ament_cmake_symlink_install_files("/home/jose/TCC/src/mavros/mavros_msgs" FILES "/home/jose/TCC/src/mavros/mavros_msgs/package.xml" "DESTINATION" "share/mavros_msgs")
