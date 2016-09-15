cmake_minimum_required(VERSION 3.6)
project(dwm)

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c99 -pedantic -Wall -Wno-deprecated-declarations -O3")
include_directories("/usr/include/freetype2/")

set(SOURCE_FILES
    config.def.h
    config.h
    drw.c
    drw.h
    dwm.c
    transient.c
    util.c
    util.h)

add_executable(dwm ${SOURCE_FILES})

