## Lallegro Makefile ##

# SWIG + C++ stuff
interfaceSrc = allegro.i
wrapSrc = $(buildDir)/wrap_allegro.c
sharedObj = $(libDir)/allegro.so
allegroIncludes = $(shell pkg-config --cflags-only-I allegro-5)
allegroFlags = $(shell pkg-config --cflags allegro-5)
allegroLinks = $(shell pkg-config --libs allegro-5)

CC = gcc
CFLAGS = -Wall -O2 $(allegroFlags)
LINKS = $(allegroLinks)

# Lua stuff
luaSrc = $(wildcard *.lua)

# Build #
all : interface shared lua


# and each submodule in it's module's dir
interface : $(interfaceSrc)
	swig -I/usr/include -o $(wrapSrc) -lua $<
	sed -i 's/"al_/"/' $(wrapSrc)

shared : $(wrapSrc)
	$(CC) -o $(sharedObj) $< -fPIC -shared $(CFLAGS) $(LINKS)


# and copy the ".lua" file(s)
lua : $(luaSrc)
	cp $^ $(libDir)


.PHONY : clean
clean :
	$(RM) *~ *.o
