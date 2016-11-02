package = 'Lallegro'
version = 'scm-1'
source = {
	url = 'git://github.com/gilzoide/lallegro',
}
description = {
	summary = 'Lua bindings for the Allegro5 game programming library',
	detailed = [[
		Lua bindings for the Allegro5 game programming library
	]],
	license = 'LGPLv3',
	maintainer = 'gilzoide <gilzoide@gmail.com>'
}
dependencies = {
	'lua >= 5.2'
}
external_dependencies = {
	LIBALLEGRO5 = {
		header = 'allegro5/allegro.h'
	}
}
build = {
	type = 'make',
	makefile = 'makefile',
	build_variables = {
		CFLAGS = '$(CFLAGS)',
		LIBFLAG = '$(LIBFLAG)',
		LUA_LIBDIR = '$(LUA_LIBDIR)',
		LUA_BINDIR = '$(LUA_BINDIR)',
		LUA_INCDIR = '$(LUA_INCDIR)',
		LUA = '$(LUA)',
	},
	install_variables = {
		PREFIX = '$(PREFIX)',
		BINDIR = '$(BINDIR)',
		LIBDIR = '$(LIBDIR)',
		LUADIR = '$(LUADIR)',
		CONFDIR = '$(CONFDIR)',
	},
}

