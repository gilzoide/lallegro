package = 'lallegro'
version = 'scm-1'
source = {
	url = 'git://github.com/gilzoide/lallegro',
}
description = {
	summary = 'Lua bindings for the Allegro 5 game programming library',
	detailed = [[
		Lua bindings for the Allegro 5 game programming library
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
	type = 'cmake',
	variables = {
		CMAKE_INSTALL_PREFIX = '/usr',
		ALLEGRO_UNSTABLE = 1,
	},
}
