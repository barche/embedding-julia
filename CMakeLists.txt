project(EmbeddingJulia)

cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
find_package(Julia REQUIRED)

add_executable(embedding embedding.cpp)
target_include_directories(embedding PUBLIC
  "$<BUILD_INTERFACE:${Julia_INCLUDE_DIRS}>"
)
add_definitions(-DJULIA_ENABLE_THREADING)
target_link_libraries(embedding $<BUILD_INTERFACE:${Julia_LIBRARY}>)

enable_testing()
add_test(NAME test-embedding COMMAND embedding)
set_property(TEST test-embedding PROPERTY
  ENVIRONMENT
    "PATH=${Sys.BINDIR}"
    "Sys.BINDIR=${Sys.BINDIR}"
)
