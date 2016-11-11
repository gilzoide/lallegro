local al = require 'lallegro'
al.Config = require 'lallegro.Config'

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

print ('------------')

local t = cfg:to_table ()
for k, v in pairs (t) do
	if type (v) ~= 'table' then
		print (k, '=', v)
	else
		for kk, vv in pairs (v) do
			print (k, '.', kk, '=', vv)
		end
	end
end

print ('------------')

local new_config = al.Config.from_table {
	primeiro = 'primeiramente',
	segundo = 'segundamente',
	secao = {
		key = 'value',
		key2 = 'value2',
	},
	outra_secao = {
		olar = 'posso ajudar?'
	},
}

for sec, k, v in new_config:iterate () do
	print (sec, k, v)
end

print ('------------  LuaConfig test ------------')

local lcfg = require 'lallegro.LuaConfig'
local t = lcfg.loadfile ('config.lua')
for k, v in pairs (t) do
	if type (v) ~= 'table' then
		print (k, '=', v)
	else
		for kk, vv in pairs (v) do
			print (k, '.', kk, '=', vv)
		end
	end
end

al.uninstall_system ()
