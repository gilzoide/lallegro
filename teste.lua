#!/usr/bin/env lua

local function printf (fmt, ...)
	print (fmt:format (...))
end

al = require 'lallegro'
assert (al.install_system (al.ALLEGRO_VERSION_INT, nil))

local disp_data = al.get_display_mode (0, al.ALLEGRO_DISPLAY_MODE ())

-- al.set_new_display_flags (al.ALLEGRO_FULLSCREEN)
printf ('Criando janela %dx%d', disp_data.width, disp_data.height)
local display = assert (al.create_display (disp_data.width, disp_data.height))
al.clear_to_color (al.map_rgb (100, 0, 0))
al.flip_display ()
al.rest (5)
al.destroy_display (display)

al.uninstall_system()
