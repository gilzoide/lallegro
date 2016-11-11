--[[ Copyright 2016 Gil Barbosa Reis <gilzoide@gmail.com>
-- This file is part of Lallegro.
--
-- Lallegro is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Lallegro is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with Lallegro.  If not, see <http://www.gnu.org/licenses/>.
--]]

--- @module lallegro.LuaConfig
-- Extra module for reading sandboxed Lua files as configuration. This is an
-- alternative to INI-like files as configuration, using Lua files to get a
-- table directly.

local LuaConfig = {}

--- Loads a Lua chunk as configuration, in a sandboxed Lua environment.
--
-- This uses Lua's `load` function with a sandboxed environment.
-- The environment 'env' is the return table, so that only 'local' variables are
-- not extracted. Binary and text chunks are allowed ("bt" mode).
--
-- @string chunk Chunk to be loaded as configuration
-- @table[opt={}] env Environment to be passed to loaded chunk
--
-- @treturn table 'env' after running loaded chunk
function LuaConfig.load (chunk, env)
	env = env or {}
	assert (load (chunk, nil, 'bt', env)) ()
	return env
end

--- Loads a Lua file as configuration, in a sandboxed Lua environment.
--
-- This uses Lua's `loadfile` function with a sandboxed environment.
-- The environment 'env' is the return table, so that only 'local'
-- variables are not extracted.
--
-- @string[opt] filename File name to be loaded
-- @table[optchain={}] env Environment to be passed to loaded file
--
-- @treturn table 'env' after running loaded file
function LuaConfig.loadfile (filename, env)
	env = env or {}
	assert (loadfile (filename, 'bt', env)) ()
	return env
end

return LuaConfig
