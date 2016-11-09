#!/usr/bin/env lua


al = require 'lallegro'
assert (al.init ('image', 'font', 'ttf', 'native_dialog', 'primitives'))
assert (al.install ('mouse'))

local function printf (fmt, ...)
	print (fmt:format (...))
end
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
print ('Modos de display disponíveis:')
for i, width, height, format, refresh_rate in al.Fullscreen.modes () do
	printf ('  %d - %dx%d, formato: %d, refresh: %d', i, width
			, height, format, refresh_rate)
end


local disp_data = al.get_display_mode (0)
al.set_new_display_flags (al.ALLEGRO_PROGRAMMABLE_PIPELINE)
local display = assert (al.create_display (disp_data.width, disp_data.height))
printf ('Criando janela %dx%d na posição %dx%d', disp_data.width, disp_data.height
		, al.get_window_position (display))
local preto = al.map_rgb (0, 0, 0)
local branco = al.map_rgb (255, 255, 255)
printf ('Limpando tela de preto, que é (%d, %d, %d, %d)', al.unmap_rgba (preto))

-- Teste do mouse
printf ('Mouse na posição (%d, %d)', select (2, al.get_mouse_cursor_position ()))


-- Teste dos shaders
al.set_blender (al.ALLEGRO_ADD, al.ALLEGRO_ALPHA, al.ALLEGRO_INVERSE_ALPHA)

local bmp = al.load_bitmap ('flango.png')
al.set_target_backbuffer (display)
al.clear_to_color (preto)
-- Teste de trasnform
al.use_transform (al.build_transform (100, 100, 1, 1, -al.ALLEGRO_PI / 2))
al.draw_bitmap (bmp, 0, 0, 0)

al.draw_filled_polygon_with_holes ({ 0, 0, 0, 100, 100, 100, 100, 0, 10, 10, 90, 10, 90, 90 }, { 4, 3, 0 }, branco)
al.flip_display ()

-- Teste dos eventos
local queue = al.create_event_queue ()
al.register_event_source (queue, al.get_display_event_source (display))
al.register_event_source (queue, al.get_mouse_event_source ())
print ('Táca-le X (botão de fechar mesmo) pra fechar a janela')
local ev = al.ALLEGRO_EVENT ()
while true do
	if al.get_next_event (queue, ev) then
		if ev.type == al.ALLEGRO_EVENT_DISPLAY_CLOSE then
			break
		elseif ev.type == al.ALLEGRO_EVENT_MOUSE_BUTTON_DOWN then
			printf ('Mouse clicou na posição (%d, %d)', ev.mouse.x, ev.mouse.y)
		end
	end
end
al.destroy_display (display)
al.destroy_event_queue (queue)
al.destroy_bitmap (bmp)
al.destroy_shader (sh)


--- Teste do arquivo de config
local cfg = al.load_config_file 'configTest.cfg'
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
if al.ALLEGRO_UNSTABLE then
    al.install ('joystick', 'haptic')
    local num_joys = al.get_num_joysticks ()
    printf ('Joystick instalado, %d disponíveis', num_joys)
    if num_joys > 0 then
        local joy = assert (al.get_joystick (0))
        local hap = assert (al.get_haptic_from_joystick (joy))
        al.rumble_haptic (hap, 0.5, 1)
        al.rest (1)
        al.release_haptic (hap)
    else
        print "Conecte o controle pra vibrar xD"
    end
end


--- Teste de fontes
local font = assert (al.load_font ('/usr/share/fonts/TTF/DejaVuSansMono-Bold.ttf', 20, 0), 'eita')
print (al.get_glyph_dimensions (font, 95))
local _, ranges = al.get_font_ranges (font, 2)
for i, r in ipairs (ranges) do print (i, r) end
al.destroy_font (font)

print (al.color_rgb_to_html (1, 1, 1))
al.uninstall_system ()
