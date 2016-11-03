#!/usr/bin/env lua

local function printf (fmt, ...)
	print (fmt:format (...))
end


al = require 'lallegro'
assert (al.init ())
print (al.free ())
printf ('Funcionando com Allegro %d %s, num sistema com %d cpus; %d RAM; Pasta: %s'
		, al.get_allegro_version () >> 24, al.UNSTABLE and '(UNSTABLE)' or ''
        , al.get_cpu_count (), al.get_ram_size ()
        , al.get_current_directory ())
al.set_app_name 'lallegro teste'

-- Monitores
local vid_adap = al.ALLEGRO_MONITOR_INFO ()
print ('Monitores disponíveis:')
for i = 0, al.get_num_video_adapters () - 1 do
    al.get_monitor_info (i, vid_adap)
    printf ('  %d - (%d, %d) até (%d, %d)', i, vid_adap.x1, vid_adap.y1
            , vid_adap.x2, vid_adap.y2)
end
-- Modos de display
local disp_data = al.ALLEGRO_DISPLAY_MODE ()
print ('Modos de display disponíveis:')
for i = 0, al.get_num_display_modes () - 1 do
    al.get_display_mode (i, disp_data)
    printf ('  %d - %dx%d, formato: %d, refresh: %d', i, disp_data.width
            , disp_data.height, disp_data.format, disp_data.refresh_rate)
end


al.get_display_mode (0, disp_data)
-- al.set_new_display_flags (al.ALLEGRO_FULLSCREEN_WINDOW)
local display = assert (al.create_display (disp_data.width, disp_data.height))
printf ('Criando janela %dx%d na posição %dx%d', disp_data.width, disp_data.height
        , al.get_window_position (display))
local preto = al.map_rgb (0, 0, 0)
al.clear_to_color (preto)
al.flip_display ()
printf ('Limpando tela de preto, que é (%d, %d, %d, %d)', al.unmap_rgba (preto))

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


--- Teste do haptic
if al.UNSTABLE then
    assert (al.install_joystick (), 'Falha ao instalar joysticks =/')
    assert (al.install_haptic (), 'Falha ao instalar haptics =/')
    local num_joys = al.get_num_joysticks ()
    printf ('Joystick instalado, %d disponíveis', num_joys)
    if num_joys > 0 then
        local joy = assert (al.get_joystick (0))
        local hap = assert (al.get_haptic_from_joystick (joy))
        local effect = al.rumble_haptic (hap, 0.5, 1)
        al.rest (1)
        al.release_haptic (hap)
    else
        print "Conecte o controle pra vibrar xD"
    end
end
