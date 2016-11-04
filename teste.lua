#!/usr/bin/env lua

local function printf (fmt, ...)
	print (fmt:format (...))
end


al = require 'lallegro'
assert (al.init ('image'))
assert (al.install ('mouse'))
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
al.set_new_display_flags (al.ALLEGRO_PROGRAMMABLE_PIPELINE)
local display = assert (al.create_display (disp_data.width, disp_data.height))
printf ('Criando janela %dx%d na posição %dx%d', disp_data.width, disp_data.height
        , al.get_window_position (display))
local preto = al.map_rgb (0, 0, 0)
printf ('Limpando tela de preto, que é (%d, %d, %d, %d)', al.unmap_rgba (preto))

-- Teste do mouse
printf ('Mouse na posição (%d, %d)', select (2, al.get_mouse_cursor_position ()))


-- Teste dos shaders
local sh = al.create_shader (al.ALLEGRO_SHADER_AUTO)
if not al.attach_shader_source (sh, al.ALLEGRO_PIXEL_SHADER, [[
#version 130

uniform sampler2D al_tex;
varying vec4 varying_color;
varying vec2 varying_texcoord;

void main () {
    gl_FragColor = vec4 (texture (al_tex, varying_texcoord).xyz, 0.41);
}
]]) or not al.attach_shader_source (sh, al.ALLEGRO_VERTEX_SHADER, al.get_default_shader_source (al.ALLEGRO_SHADER_GLSL, al.ALLEGRO_VERTEX_SHADER)) then
    print (al.get_shader_log (sh))
    return
end
-- print ('\n', al.get_default_shader_source (al.ALLEGRO_SHADER_GLSL, al.ALLEGRO_VERTEX_SHADER), '\n')
-- print ('\n', al.get_default_shader_source (al.ALLEGRO_SHADER_GLSL, al.ALLEGRO_PIXEL_SHADER), '\n')
assert (al.build_shader (sh), 'Deu bosta no build_shader =/')
al.set_blender (al.ALLEGRO_ADD, al.ALLEGRO_ALPHA, al.ALLEGRO_INVERSE_ALPHA)
al.set_shader_float_vector ('teste', 1, { 1, 1, 0, 1 })
al.set_shader_int_vector ('testei', 1, { 2, 4, 0 })
al.use_shader (sh)

local bmp = al.load_bitmap ('../flango.png')
al.set_target_backbuffer (display)
al.clear_to_color (preto)
al.draw_bitmap (bmp, 0, 0, 0)
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


--- Teste de transforms
local id = al.identity_transform ()
local outra_id = al.copy_transform (id)
print (id, outra_id)
