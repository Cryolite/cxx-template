cmake_minimum_required(VERSION 3.16.2)
project(cxx-template)

enable_testing()

message(STATUS
  "CMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
message(STATUS
  "CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")

set(CMAKE_CXX_STANDARD 20)
message(STATUS
  "CMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}")

if((CMAKE_CXX_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU"))
  add_compile_options(-Werror -Wall)
else()
  message(FATAL_ERROR
    "An unsupported C++ compiler: CMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}.")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "")
  set(CMAKE_BUILD_TYPE Debug)
endif()

message(STATUS
  "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")

message(STATUS
  "CXX_TEMPLATE_CXX_STDLIB=${CXX_TEMPLATE_CXX_STDLIB}")

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  if(CXX_TEMPLATE_CXX_STDLIB STREQUAL "libstdc++")
    add_compile_options(-stdlib=libstdc++)
    add_link_options(-stdlib=libstdc++)
  elseif(CXX_TEMPLATE_CXX_STDLIB STREQUAL "libc++")
    add_compile_options(-stdlib=libc++)
    add_link_options(-stdlib=libc++)
  else()
    message(FATAL_ERROR
      "An unsupported C++ standard library: CXX_TEMPLATE_CXX_STDLIB=${CXX_TEMPLATE_CXX_STDLIB}.")
  endif()
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    if(CXX_TEMPLATE_CXX_STDLIB STREQUAL "libstdc++")
      add_definitions(
        -D_GLIBCXX_DEBUG
        -D_GLIBCXX_DEBUG_PEDANTIC)
    endif()
  endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(
      -D_GLIBCXX_DEBUG
      -D_GLIBCXX_DEBUG_PEDANTIC)
  endif()
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  add_definitions(-DCXX_TEMPLATE_ENABLE_ASSERT)

  add_compile_options(-fsanitize=address)
  add_link_options(-fsanitize=address)
  add_compile_options(-fsanitize=pointer-compare)
  add_link_options(-fsanitize=pointer-compare)
  add_compile_options(-fsanitize=pointer-subtract)
  add_link_options(-fsanitize=pointer-subtract)
  add_compile_options(-fsanitize=undefined)
  add_link_options(-fsanitize=undefined)
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
else()
  message(FATAL_ERROR
    "An unsupported build type: CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}.")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  if((CMAKE_CXX_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU"))
    add_compile_options(-pthread)
    add_link_options(-pthread)
  else()
    message(FATAL_ERROR
      "An unsupported C++ compiler: CMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}.")
  endif()
else()
  message(FATAL_ERROR
    "An unsupported system: CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}.")
endif()

message(STATUS
  "CMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
message(STATUS
  "CMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}")
message(STATUS
  "CMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}")

message(STATUS
  "BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}")

add_subdirectory(ext/libbacktrace)
add_subdirectory(ext/icu4c)
add_subdirectory(ext/boost)
add_subdirectory(ext/googletest)
