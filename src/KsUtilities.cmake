# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# This function setups the fmt target.
function(ks_setup_formatter)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "FILE_PATTERNS")

  configure_file("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/FormatterDriver.cmake.in"
            FormatterDriver.cmake
            @ONLY)

  add_custom_target(fmt
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/FormatterDriver.cmake"
    COMMENT "Formatting sources"
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    VERBATIM
  )
endfunction()

function(ks_generate_install_config)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "INSTALL" "TARGETS;DEPENDENCIES")

  install(
    TARGETS ${ARG_TARGETS}
    EXPORT "${PROJECT_NAME}Targets"
    FILE_SET headers
  )

  install(
    EXPORT "${PROJECT_NAME}Targets"
    NAMESPACE "${PROJECT_NAME}::"
    DESTINATION "share/${PROJECT_NAME}"
  )

  include(CMakePackageConfigHelpers)

  configure_package_config_file(
    "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/ProjectConfig.cmake.in"
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION "share/${PROJECT_NAME}"
  )

  install(
    FILES "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    DESTINATION "share/${PROJECT_NAME}"
  )
endfunction()
