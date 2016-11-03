## Lallegro Makefile ##

export pkgName := lallegro

# LuaRocks stuff
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib/lua/5.3/$(pkgName)
LUADIR = $(PREFIX)/share/lua/5.3/$(pkgName)
CONFDIR = $(PREFIX)/etc


# My stuff
export buildDir := $(CURDIR)/build
export libDir := $(buildDir)/$(pkgName)

srcdir = src
permissions = 644


# now build!
all : buildDir lallegro

buildDir :
	@mkdir -p $(libDir)

lallegro :
	$(MAKE) -C $(srcdir) all


install :
	install -m $(permissions) $(libDir)/*.so $(LIBDIR)
	install -m $(permissions) $(libDir)/*.lua $(LUADIR)

.PHONY : clean run
clean :
	$(MAKE) -C $(srcdir) clean
	$(RM) -r $(buildDir)/*

run :
	@cd $(buildDir) && ../teste.lua
