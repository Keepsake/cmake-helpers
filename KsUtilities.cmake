# SPDX-License-Identifier: MIT

include_guard(GLOBAL)
set(_KS_UTILITIES_DIR "${CMAKE_CURRENT_LIST_DIR}")

# This function setups the compilation environment to invoke clang-tidy
# linters on each source file.
function(ks_setup_linter)
  find_program(clangtidy NAMES clang-tidy)
  if(NOT clangtidy)
    message(FATAL_ERROR "clang-tidy is missing from $PATH")
  endif()

  # Export the compile commands for clang-tidy to be
  # able to lint code.
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON PARENT_SCOPE)

  set(
    CXX_CLANG_TIDY
      "${clangtidy}"
      "--quiet"
      "--header-filter=${PROJECT_SOURCE_DIR}"
      "--extra-arg=-Wno-unknown-warning-option"
      "--extra-arg=-Wno-ignored-optimization-argument"
      "--enable-check-profile"
      "--store-check-profile=linter"
      ${CLANG_TIDY_EXTRA_ARGS}
    PARENT_SCOPE
  )
endfunction()

# This function setups the fmt target.
function(ks_setup_formatter)
  add_custom_target(fmt
    COMMAND ${CMAKE_COMMAND} -P "${_KS_UTILITIES_DIR}/FormatterDriver.cmake"
    COMMENT "Formatting sources"
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    VERBATIM
  )
endfunction()

# This function setups the compilation environment to generate
# link time optimized binaries.
function(ks_setup_lto)
  include(CheckIPOSupported)
  check_ipo_supported()
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE PARENT_SCOPE)
endfunction()

# Configure the target argument to be checked by the linter tools.
# In order to work, the linter tools should have been discovered previously
# by the ks_setup_linter() function.
function(_ks_target_enable_linter target)
  set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY "${CXX_CLANG_TIDY}")
endfunction()

# This function wraps the standard `add_library()` in order to add
# lint directives to the target.
function(ks_add_library target_name)
  add_library(${target_name} ${ARGN})
  _ks_target_enable_linter(${target_name})
endfunction()

# This function wraps the standard `add_executable()` in order to add
# lint directives to the target.
function(ks_add_executable target_name)
  add_executable(${target_name} ${ARGN})
  _ks_target_enable_linter(${target_name})
endfunction()

# Define a unit test.
function(ks_add_unit_test test_name)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "LIBS;SOURCES")

  ks_add_executable(${test_name} ${ARG_SOURCES})
  target_link_libraries(${test_name} PRIVATE ${ARG_LIBS})
  add_test(NAME ${test_name} COMMAND ${test_name})
endfunction()

function(ks_install)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "TARGETS")

  install(
    TARGETS ${ARG_TARGETS}
    EXPORT "${CMAKE_PROJECT_NAME}Targets"
    FILE_SET headers
  )

  install(
    EXPORT "${CMAKE_PROJECT_NAME}Targets"
    NAMESPACE "${CMAKE_PROJECT_NAME}::"
    DESTINATION "share/${CMAKE_PROJECT_NAME}"
  )

  include(CMakePackageConfigHelpers)

  configure_package_config_file(
    "${_KS_UTILITIES_DIR}/ProjectConfig.cmake.in"
    "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION "share/${CMAKE_PROJECT_NAME}"
  )

  install(
    FILES "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
    DESTINATION "share/${CMAKE_PROJECT_NAME}"
  )
endfunction()

macro(ks_setup)
  option(WITH_LTO "Enable Link Time Optimization" OFF)
  option(WITH_LINTER "Enable linter" OFF)

  if(WITH_LTO)
    ks_setup_lto()
  endif()

  if(WITH_LINTER)
    ks_setup_linter()
  endif()

  ks_setup_formatter()

  # Ensure unit test will timeout and be verbose on failure.
  list(APPEND CMAKE_CTEST_ARGUMENTS "--output-on-failure" "--timeout" "60")

  include(CTest)
endmacro()
