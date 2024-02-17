# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.23)

project(KsCMakeHelpers LANGUAGES NONE)

include(CMakePackageConfigHelpers)

configure_package_config_file(
  "KsCMakeHelpersConfig.cmake.in"
  "${PROJECT_BINARY_DIR}/KsCMakeHelpersConfig.cmake"
  INSTALL_DESTINATION
    "share/KsCMakeHelpers"
)

install(
  FILES
    "${PROJECT_BINARY_DIR}/KsCMakeHelpersConfig.cmake"
    "${PROJECT_SOURCE_DIR}/KsUtilities.cmake"
    "${PROJECT_SOURCE_DIR}/FormatterDriver.cmake"
    "${PROJECT_SOURCE_DIR}/ProjectConfig.cmake.in"
  DESTINATION
    "share/KsCMakeHelpers"
)
