# SPDX-License-Identifier: MIT

find_program(clang_format NAMES clang-format)
if(NOT clang_format)
    message(FATAL_ERROR "clang-format is missing from PATH")
endif()

file(
  GLOB_RECURSE
  sources_files
  "include/*.[ch]pp"
  "src/*.[ch]pp"
  "tests/*.[ch]pp"
  "benchmarks/*.[ch]pp"
)

execute_process(
  COMMAND
    ${clang_format} --style=file -i ${sources_files}
  RESULT_VARIABLE
    failure 
)

if(failure)
  message(FATAL_ERROR "Failed to format sources")
endif()
