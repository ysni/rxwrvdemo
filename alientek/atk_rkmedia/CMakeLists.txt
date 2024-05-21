#@author        Deng Zhimao
#@email         dengzhimao@alientek.com
#http://www.openedv.com/forum.php
cmake_minimum_required(VERSION 3.8)
message(STATUS "cmake version ${CMAKE_VERSION}")

set(CMAKE_CXX_STANDARD 11)
add_definitions(-g -O0 -ggdb -gdwarf -funwind-tables -rdynamic)
add_definitions(-Wno-write-strings -Wno-return-type)
project(alientek-demo)
include_directories(${RKMEDIA_HEADS_DIR})
include_directories(${SAMPLE_COMMON_ISP_HEADS_DIR})
include_directories(${RGA_HEADS_DIR})
include_directories(${RKNN_HEADS_DIR})
include_directories(${CAMERA_ENGINE_RKAIQ_ALGOS})
include_directories(${CAMERA_ENGINE_RKAIQ_COMMON})
include_directories(${CAMERA_ENGINE_RKAIQ_IQ_PARSER})
include_directories(${CAMERA_ENGINE_RKAIQ_UAPI})
include_directories(${CAMERA_ENGINE_RKAIQ_XCORE})
include_directories(${ROCKX_HEADS_DIR})
include_directories(.)

add_definitions(-DRKAIQ)

option(ATK_RKMEDIA_LIBRARY "compile: alientek rkmedia library" ON)

if(ATK_RKMEDIA_LIBRARY)
add_subdirectory(library)
endif()

