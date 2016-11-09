local al = require 'lallegro'
al.init ()

local cfg = assert (al.Config.load ('configTest.cfg'))
for sec in cfg:sections () do
	print (sec)
	for k, v in cfg:entries (sec) do
		print ('', k, v)
	end
end

cfg:remove_section ('secao')
print ('------------')

for sec, k, v in cfg:iterate () do
	print (sec, k, v)
end

print ('------------')

local other = al.Config.new ()
other:set ('other', 'Adicao', '++')

cfg:merge_into (other)

for sec, k, v in cfg:iterate () do
	print (sec, k, v)
end

al.uninstall_system ()
