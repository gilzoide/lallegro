local al = require 'lallegro'
al.EventQueue = require 'lallegro.EventQueue'

assert (al.init ())
assert (al.install ('keyboard'))

local disp = assert (al.create_display (800, 600))

local Q = assert (al.EventQueue.new ())
Q:register (assert (al.get_keyboard_event_source ()))

al.rest (2)

print 'Eventos em 2s:'
for ev in Q:available_events () do
	print (al.keycode_to_name (ev.keyboard.keycode))
end

print 'Clique Q pra sair'
while true do
	local ev = Q:wait ()
	local c = al.keycode_to_name (ev.keyboard.keycode)
	if ev.type == al.ALLEGRO_EVENT_KEY_DOWN then
		print (c)
		if c == 'q' then break end
	end
end

al.destroy_display (disp)
