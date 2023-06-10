cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "pnet")
project(${PROJECT_NAME} LANGUAGES C)

set(SOURCE_PATH "../../modules/pnet/src")

add_library(${PROJECT_NAME} SHARED
  "${SOURCE_PATH}/pnet.c"
  "${SOURCE_PATH}/pnet_matrix.c"
  "${SOURCE_PATH}/pnet_error.c"
  "${SOURCE_PATH}/pnet_file.c"
  "${SOURCE_PATH}/str.c"
  "${SOURCE_PATH}/queue.c"
  "${SOURCE_PATH}/crc32.c"
  "${SOURCE_PATH}/il_weg_tpw04.c"
  "${SOURCE_PATH}/../../pnet_dart_interop/pnet_dart_interop.c"
  "/opt/dart-sdk/include/dart_api_dl.c"
)

target_link_libraries(${PROJECT_NAME} pthread)

target_compile_options(${PROJECT_NAME} PRIVATE
  -O2 -Wall -Wextra -Wpedantic -Wshadow)
  
target_include_directories(${PROJECT_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_PATH}"
  "/opt/dart-sdk/include/"
)