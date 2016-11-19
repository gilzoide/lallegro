# First, find Allegro
include (FindAllegro5.cmake)

# make SWIG find the headers
set (CMAKE_SWIG_FLAGS -I${ALLEGRO5_INCLUDE_DIR})
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_PROJECT_NAME})
# make SWIG use the same type runtime for all modules
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSWIG_TYPE_TABLE=${CMAKE_PROJECT_NAME}")

# Include Allegro Unstable API?
if (ALLEGRO_UNSTABLE)
	set (CMAKE_SWIG_FLAGS ${CMAKE_SWIG_FLAGS} -DALLEGRO_UNSTABLE)
	set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DALLEGRO_UNSTABLE")
endif (ALLEGRO_UNSTABLE)

swig_add_module (core lua core.i)
swig_link_libraries (core allegro)

# General modules
set (addons audio acodec color font ttf image memfile dialog physfs primitives video)
foreach (mod ${addons})
	swig_add_module (${mod} lua ${mod}.i)
	swig_link_libraries (${mod} allegro allegro_${mod})
endforeach (mod)

# Platform specific modules: Direct3D or OpenGL?
if (WIN32)
	set (platform_specific direct3d)
	# Include opengl specific functions on Windows?
	if (ALLEGRO_WIN32_OPENGL)
		set (platform_specific "${platform_specific} opengl")
	endif(ALLEGRO_WIN32_OPENGL)
else ()
	set (platform_specific opengl)
endif(WIN32)
foreach (mod ${platform_specific})
	swig_add_module (${mod} lua ${mod}.i)
	swig_link_libraries (${mod} allegro)
endforeach (mod)

# Copy Lua files
file (GLOB luaSrc *.lua)
file (COPY ${luaSrc} DESTINATION ${CMAKE_PROJECT_NAME})

##  Install  ##
set (LUA_VER "${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}")
install (TARGETS core ${addons} ${platform_specific}
	LIBRARY DESTINATION lib/lua/${LUA_VER}/${CMAKE_PROJECT_NAME})
install (FILES ${luaSrc}
	DESTINATION share/lua/${LUA_VER}/${CMAKE_PROJECT_NAME})
