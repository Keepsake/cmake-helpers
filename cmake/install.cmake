# SPDX-License-Identifier: MIT

file(CONFIGURE OUTPUT ${PROJECT_NAME}Config.cmake CONTENT [[
include(@PROJECT_SOURCE_DIR@/src/KsUtilities.cmake)
]])

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion
)

export(PACKAGE ${PROJECT_NAME})

if(KS_CMAKE_HELPERS_INSTALL)
  configure_package_config_file(
    "${CMAKE_CURRENT_LIST_DIR}/${PROJECT_NAME}Config.cmake.in"
    "${PROJECT_BINARY_DIR}/config/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION
      share/${PROJECT_NAME}
  )

  install(
    FILES
      "${PROJECT_BINARY_DIR}/config/${PROJECT_NAME}Config.cmake"
      "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
      "${PROJECT_SOURCE_DIR}/src/KsUtilities.cmake"
      "${PROJECT_SOURCE_DIR}/src/FormatterDriver.cmake.in"
      "${PROJECT_SOURCE_DIR}/src/ProjectConfig.cmake.in"
    DESTINATION
      share/${PROJECT_NAME}
  )
endif()
