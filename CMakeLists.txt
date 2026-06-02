cmake_minimum_required(VERSION 3.28)
project(cppspace)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 26)

find_package(SFML COMPONENTS window graphics system)

add_executable(
  cppspace
  src/main.cpp
  src/InputSubsystem.cpp
)

target_link_libraries(
  cppspace
  sfml-window
  sfml-graphics
  sfml-system)
