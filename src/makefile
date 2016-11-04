## Lallegro Makefile ##

submods = allegro image

# Allegro stuff
allegroIncludes = $(shell pkg-config --cflags-only-I allegro-5)
# enable Allegro Unstable API
ifdef UNSTABLE
DEFINES = -DALLEGRO_UNSTABLE
endif
allegroFlags = $(shell pkg-config --cflags allegro-5) $(DEFINES)
allegroLinks = $(shell pkg-config --libs allegro-5 allegro_image-5)

CC = gcc
CFLAGS = -Wall -O2 $(allegroFlags)
LINKS = $(allegroLinks)

# Lua stuff
luaSrc = $(wildcard *.lua)

# Build #
all : $(submods:=.so) lua


# each submodule depends on it's C wrapper for Lua...
%.so : $(buildDir)/wrap_%.c
	$(CC) -o $(libDir)/$@ $< -fPIC -shared $(CFLAGS) $(LINKS)

# ...that is generated using SWIG
$(buildDir)/wrap_%.c : %.i
	swig -I/usr/include $(DEFINES) -o $@ -lua $<
	sed -i 's/"al_/"/' $@

shared : $(wrapSrc)


# and copy the ".lua" file(s)
lua : $(luaSrc)
	cp $^ $(libDir)


.PHONY : clean
clean :
	$(RM) *~ *.o
