project(EmbeddingJulia LANGUAGES C)

cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

set(JULIA_ROOT "/usr" CACHE PATH "Julia root directory")
set(JULIA_COMMAND "${JULIA_ROOT}/bin/julia")
if(WIN32)
  set(JULIA_COMMAND "${JULIA_ROOT}/bin/julia.exe")
endif()

if(NOT EXISTS ${JULIA_COMMAND})
  message(FATAL_ERROR "JULIA_ROOT directory does not contain bin/julia(.exe), please set the CMake variable JULIA_ROOT to the Julia root directory.")
endif()

set(JULIA_LIBNAME "libjulia.so")

if(WIN32)
  set(JULIA_LIBNAME "libjulia.dll.a")
endif()

if(APPLE)
  set(JULIA_LIBNAME "libjulia.dylib")
endif()

set(JULIA_COMMAND "${JULIA_ROOT}/bin/julia")
set(JULIA_CONFIG "${JULIA_ROOT}/share/julia/julia-config.jl")

execute_process(COMMAND ${JULIA_COMMAND} ${JULIA_CONFIG} --cflags OUTPUT_VARIABLE JULIA_C_FLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${JULIA_COMMAND} ${JULIA_CONFIG} --ldflags OUTPUT_VARIABLE JULIA_LD_FLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)

separate_arguments(JULIA_C_FLAGS)

execute_process(COMMAND ${JULIA_COMMAND} ${CMAKE_SOURCE_DIR}/process_cflags.jl ${JULIA_C_FLAGS} OUTPUT_VARIABLE JULIA_C_FLAGS_PROCESSED OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${JULIA_COMMAND} ${CMAKE_SOURCE_DIR}/process_incdir.jl ${JULIA_C_FLAGS} OUTPUT_VARIABLE JULIA_INCLUDE_DIRECTORY OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${JULIA_COMMAND} ${CMAKE_SOURCE_DIR}/process_libdir.jl ${JULIA_LD_FLAGS} OUTPUT_VARIABLE JULIA_LIB_DIRECTORY OUTPUT_STRIP_TRAILING_WHITESPACE)

# link_directories(${JULIA_LIB_DIRECTORY})
set(CMAKE_INSTALL_RPATH "${JULIA_LIB_DIRECTORY}")

set(JULIA_LIBRARY ${JULIA_LIB_DIRECTORY}/${JULIA_LIBNAME})
if(WIN32)
  set(JULIA_LIBRARY ${JULIA_ROOT}/lib/${JULIA_LIBNAME})
endif()

list(APPEND JULIA_LIBRARIES ${JULIA_LIBRARY})
if(UNIX)
  list(APPEND JULIA_LIBRARIES "m")
endif()

add_executable(embedding embedding.c)
set_target_properties(embedding PROPERTIES COMPILE_FLAGS ${JULIA_C_FLAGS_PROCESSED})
target_include_directories(embedding PUBLIC ${JULIA_INCLUDE_DIRECTORY})
target_link_libraries(embedding ${JULIA_LIBRARIES})

enable_testing()

add_test(NAME test-embedding COMMAND embedding)

file(TO_NATIVE_PATH ${JULIA_ROOT}/bin JULIA_HOME_PATH)

set_property(TEST test-embedding PROPERTY
  ENVIRONMENT
    "PATH=${JULIA_HOME_PATH}"
    "JULIA_HOME=${JULIA_HOME_PATH}"
)
