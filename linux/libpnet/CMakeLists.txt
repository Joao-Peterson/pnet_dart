cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "pnet")
project(${PROJECT_NAME} LANGUAGES C)

set(SOURCE_PATH "../../modules/pnet")

add_library(${PROJECT_NAME} SHARED
  "${SOURCE_PATH}/pnet.c"
  "${SOURCE_PATH}/pnet_matrix.c"
  "${SOURCE_PATH}/pnet_error.c"
)

target_compile_options(${PROJECT_NAME} PRIVATE
  -O2 -Wall -Wextra -pedantic -Wmissing-prototypes -Wshadow)
  
target_include_directories(${PROJECT_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_PATH}")