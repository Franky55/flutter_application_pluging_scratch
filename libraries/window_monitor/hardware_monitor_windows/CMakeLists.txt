# only for cmake --version >= 3.5.1
cmake_minimum_required(VERSION 3.5.1)

# project name
project(hardware_monitor_windows)

# creates the variable EXEC and sets it to hello
set(EXEC hardware_monitor)

# set the C++14 standard
set(CMAKE_CXX_STANDARD 14)

# I../includes
include_directories(includes)

# puts all .cpp files inside src to the SOURCES variable
file(GLOB SOURCES *.cpp *.def)

#This line is the one that creates the .dll file you need to put the SHARED to have it
add_library(Lib SHARED ${SOURCES})

# compiles the files defined by SOURCES to generante the executable defined by EXEC
add_executable(${EXEC} ${SOURCES})


