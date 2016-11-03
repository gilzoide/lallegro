#!/usr/bin/env lua

local function printf (fmt, ...)
	print (fmt:format (...))
end

al = require 'lallegro'
assert (al.init ())
printf ('Funcionando com Allegro %d, num sistema com %d cpus; %d RAM'
		, al.get_allegro_version () >> 24, al.get_cpu_count (), al.get_ram_size ())
al.set_app_name 'lallegro teste'

local disp_data = al.get_display_mode (1, al.ALLEGRO_DISPLAY_MODE ())


-- al.set_new_display_flags (al.ALLEGRO_FULLSCREEN_WINDOW)
-- printf ('Criando janela %dx%d', disp_data.width, disp_data.height)
-- local display = assert (al.create_display (disp_data.width, disp_data.height))
-- print (al.get_window_constraints (nil))
-- al.clear_to_color (al.map_rgb (100, 0, 0))
-- al.flip_display ()
-- al.rest (2)
-- al.destroy_display (display)


--- Teste do arquivo de config
cfg = al.load_config_file '../configTest.cfg'
sec, it = al.get_first_config_section (cfg)
repeat
	print (sec)
	entry, it2 = al.get_first_config_entry (cfg, sec)
	repeat
		print ('', entry, '=', al.get_config_value (cfg, sec, entry))
		entry, it2 = al.get_next_config_entry (it2)
	until not it2
	sec, it = al.get_next_config_section (it)
until not it

al.destroy_config (cfg)
