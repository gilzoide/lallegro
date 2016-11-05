## Lallegro Makefile ##

submods = allegro audio acodec font ttf image color memfile dialog physfs

# Allegro stuff
allegroIncludes = $(shell pkg-config --cflags-only-I allegro-5)
# enable Allegro Unstable API
ifdef UNSTABLE
DEFINES = -DALLEGRO_UNSTABLE
endif
allegroFlags = $(shell pkg-config --cflags allegro-5) $(DEFINES)
allegroLinks = $(shell pkg-config --libs allegro-5 allegro_{audio,acodec,image,font,ttf,color,memfile,dialog,physfs}-5)

CC = gcc
CFLAGS = -Wall -O2 -fPIC $(allegroFlags)
LINKS = $(allegroLinks)

# Lua stuff
luaSrc = $(wildcard *.lua)

# Build #
all : swig lua

swig : $(submods:=.so) 

# each submodule depends on it's C wrapper for Lua...
%.so : $(buildDir)/wrap_%.o
	$(CC) -o $(libDir)/$@ $< -shared $(CFLAGS) $(LINKS)

# ...that is generated using SWIG
.PRECIOUS : $(buildDir)/wrap_%.c
.PRECIOUS : $(buildDir)/wrap_%.o
$(buildDir)/wrap_%.c : %.i
	swig -I/usr/include $(DEFINES) -o $@ -lua $<
	sed -i 's/"al_/"/' $@

# and copy the ".lua" file(s)
lua : $(luaSrc)
	cp $^ $(libDir)


.PHONY : clean
clean :
	$(RM) *~ *.o
