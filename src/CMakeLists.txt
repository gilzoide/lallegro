# SWIG stuff
find_path (ALLEGRO_INCLUDE_PATH allegro5/allegro.h)
set (CMAKE_SWIG_FLAGS -I${ALLEGRO_INCLUDE_PATH})
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_PROJECT_NAME})

# Include Allegro Unstable API?
if (${ALLEGRO_UNSTABLE})
	set (CMAKE_SWIG_FLAGS ${CMAKE_SWIG_FLAGS} -DALLEGRO_UNSTABLE)
	set (CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -DALLEGRO_UNSTABLE)
endif (${ALLEGRO_UNSTABLE})

swig_add_module (core lua core.i)
swig_link_libraries (core allegro)

# Wraps an addon, as they all follow the same name convention =]
function (swig_please_wrap_it addon)
	swig_add_module (${addon} lua ${addon}.i)
	swig_link_libraries (${addon} allegro allegro_${addon})
endfunction ()

swig_please_wrap_it (audio)
swig_please_wrap_it (acodec)
swig_please_wrap_it (color)
swig_please_wrap_it (font)
swig_please_wrap_it (ttf)
swig_please_wrap_it (image)
swig_please_wrap_it (memfile)
swig_please_wrap_it (dialog)
swig_please_wrap_it (physfs)
swig_please_wrap_it (video)

# Copy Lua files
file (GLOB luaSrc *.lua)
file (COPY ${luaSrc} DESTINATION ${CMAKE_PROJECT_NAME})

##  Install  ##
set (LUA_VER "${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}")
install (TARGETS core audio acodec color font ttf image memfile dialog physfs video
	LIBRARY DESTINATION lib/lua/${LUA_VER}/${CMAKE_PROJECT_NAME})
install (FILES ${luaSrc}
	DESTINATION share/lua/${LUA_VER}/${CMAKE_PROJECT_NAME})
