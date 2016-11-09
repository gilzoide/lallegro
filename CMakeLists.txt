## Lallegro CMake ##
cmake_minimum_required (VERSION 2.6)

project (lallegro)

find_package (SWIG REQUIRED)
include (${SWIG_USE_FILE})
find_package (Lua REQUIRED)

option (ALLEGRO_UNSTABLE "Include Allegro Unstable API" OFF)
option (ALLEGRO_WIN32_OPENGL "Include OpenGL specific API on Windows" OFF)

add_subdirectory (src)
