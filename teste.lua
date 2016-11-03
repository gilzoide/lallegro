#!/usr/bin/env lua

local function printf (fmt, ...)
	print (fmt:format (...))
end

al = require 'lallegro'
assert (al.init ())
printf ('Funcionando com Allegro %d, num sistema com %d cpus; %d RAM; Pasta: %s'
		, al.get_allegro_version () >> 24, al.get_cpu_count (), al.get_ram_size ()
        , al.get_current_directory ())
al.set_app_name 'lallegro teste'

local disp_data = al.get_display_mode (1, al.ALLEGRO_DISPLAY_MODE ())


-- al.set_new_display_flags (al.ALLEGRO_FULLSCREEN_WINDOW)
printf ('Criando janela %dx%d', disp_data.width, disp_data.height)
local display = assert (al.create_display (disp_data.width, disp_data.height))
al.clear_to_color (al.map_rgb (100, 0, 0))
al.flip_display ()

-- Teste dos eventos
local queue = al.create_event_queue ()
al.register_event_source (queue, al.get_display_event_source (display))
print ('Táca-le X (botão de fechar mesmo) pra fechar a janela')
local ev = al.ALLEGRO_EVENT ()
while true do
    al.wait_for_event (queue, ev)
    if ev.type == al.ALLEGRO_EVENT_DISPLAY_CLOSE then break end
end
al.destroy_display (display)
al.destroy_event_queue (queue)


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


--- Teste de arquivo
local f, path = al.make_temp_file ('OieXXXX.txt')
print (al.path_cstr (path, '/'))
al.fputs (f, string.format ('Olar, como ir? Sou %s', 'gilzoide'))
al.fclose (f)

