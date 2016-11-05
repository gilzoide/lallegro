project = 'lallegro'
title = 'lallegro'
description = 'Lua bindings for the Allegro 5 game programming library'
full_description = [[
Lua bindings for the Allegro 5 game programming library, using SWIG
]]

not_luadoc = true
merge = true

file = { 'src/init.lua' }
format = 'markdown'
readme =  { 'README.md', 'apidiff.md' }

--//  add custom types for parameters  //--
-- builtin Lua types
tparam_alias ('string', 'string')
tparam_alias ('number', 'number')
tparam_alias ('int', 'int')
tparam_alias ('bool', 'bool')
tparam_alias ('table', 'table')
