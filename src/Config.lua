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

--- @classmod lallegro.Config
-- ALLEGRO_CONFIG wrapper metatable, a GC enabled object, with nice methods and
-- iterators. One can use sandboxed Lua files as config (LuaConfig module), but
-- this might be useful for some.
--
-- Config objects can be represented as Lua tables, and there's
-- `Config:get_table` and `Config.from_table` for that.
--
-- The 'Table / Config' rules are:
--
-- + Values on the global section should be placed directly in the table
-- + Extra sections are nested tables, and each key/value pair inside it
--   compose the entry

local al = require 'lallegro.core'

local Config = {}
-- Let Config objects call the methods
Config.__index = Config

--------------------------------------------------------------------------------
--  Interface functions
--  @section wrapper
--------------------------------------------------------------------------------

--- Garbage collector should destroy the wrapped ALLEGRO_CONFIG.
--
-- If you plan to destroy the ALLEGRO_CONFIG manually, first `extract` it, as
-- `al_destroy_config` would double free the pointer.
function Config:__gc ()
	al.destroy_config (self.data)
end

--- Wraps a ALLEGRO_CONFIG on a Config object
--
-- @param al_cfg ALLEGRO_CONFIG to be wrapped
--
-- @return Config object
function Config.wrap (al_cfg)
	return al_cfg and setmetatable ({ data = al_cfg }, Config)
end

--- Extracts the wrapped ALLEGRO_CONFIG, so that it will not be GCed.
--
-- This sets the inner ALLEGRO_CONFIG pointer as `NULL`, so it is not safe to
-- call any other methods after that.
function Config:extract ()
	local al_cfg = self.data
	self.data = nil
	return al_cfg
end

--------------------------------------------------------------------------------
--  Construction
--  @section ctor
--------------------------------------------------------------------------------

--- Creates a new Config.
function Config.new ()
	return Config.wrap (al.create_config ())
end

--- Constructs a new Config object with the entries in passed table.
--
-- This follows the 'Table / Config' rules.
function Config.from_table (t)
	local config = Config.new ()
	for k, v in pairs (t) do
		-- entry in the global section
		if type (v) ~= 'table' then
			config:set (nil, k, v)
		-- new section
		else
			for key, value in pairs (v) do
				config:set (k, key, value)
			end
		end
	end

	return config
end

--------------------------------------------------------------------------------
--  Getters
--  @section getters
--------------------------------------------------------------------------------

--- Get a configuration value.
--
-- This is a wrapper for al_get_config_value.
--
-- @string section The section to lookup. Pass `""` or `nil` for global section
-- @string key The key to lookup.
--
-- @treturn[0] string Value found
-- @treturn[1] nil if section or key do not exist
function Config:get (section, key)
	return al.get_config_value (self.data, section, key)
end

--- Get the configuration as a Lua table.
--
-- This follows the 'Table / Config' rules.
--
-- @treturn table Configuration in a Lua table
function Config:get_table ()
	local ret = {}
	for sec in self:sections () do
		local section
		if sec == '' then
			section = ret
		else
			section = {}
			ret[sec] = section
		end
		for k, v in self:entries (sec) do
			section[k] = v
		end
	end

	return ret
end

--------------------------------------------------------------------------------
--  Editing
--  @section edit
--------------------------------------------------------------------------------

--- Set a configuration value.
--
-- This is a wrapper for al_set_config_value.
--
-- @string section The section to lookup. Pass `""` or `nil` for global section
-- @string key The key to lookup.
-- @string value The new value for config
function Config:set (section, key, value)
	al.set_config_value (self.data, section, key, value)
end

--- Remove a key and it's value from configuration.
--
-- This is a wrapper for `al_remove_config_key`
--
-- @string section The section. Pass `""` or `nil` for global section
-- @string key Key to be removed
function Config:remove (section, key)
	return al.remove_config_key (self.data, section, key)
end

--- Add a section to configuration.
--
-- This is a wrapper for `al_add_config_section`
--
-- @string section The new section
function Config:add_section (section)
	al.add_config_section (self.data, section)
end

--- Remove section from configuration.
--
-- This is a wrapper for `al_remove_config_section`
--
-- @string section Section to be removed
function Config:remove_section (section)
	return al.remove_config_section (self.data, section)
end

--- Add a comment in a section on configuration.
--
-- This is a wrapper for `al_add_config_comment`
--
-- @string section The section. Pass `""` or `nil` for global section
-- @string comment The new comment, that may or may not begin with a '#'.
function Config:add_comment (section, comment)
	al.add_config_comment (self.data, section, comment)
end

--- Merge two configurations, and return as a new Config.
--
-- This is a wrapper for `al_merge_config`
--
-- @tparam Config other Configuration to merge
--
-- @treturn Config Merged configurations
function Config:merge (other)
	return Config.wrap (al.merge_config (self.data, other.data))
end

--- Merge `add` configuration into this one.
--
-- This is a wrapper for `al_merge_config_into`
--
-- @usage master:merge_into (add)
--
-- @tparam Config add Configuration to merge into
function Config:merge_into (add)
	al.merge_config_into (self.data, add.data)
end

--- Alias for `merge`, so you can merge Configs with Lua's `..`  operator
--
-- @usage new_config = cfg1 .. cfg2
Config.__concat = Config.merge

--------------------------------------------------------------------------------
--  Iterators
--  @section iterators
--------------------------------------------------------------------------------

local function section_name_iterator (config)
	local sec, it = al.get_first_config_section (config.data)
	repeat
		coroutine.yield (sec)
		sec, it = al.get_next_config_section (it)
	until not it
end

local function entry_iterator (config, section)
	local entry, it = al.get_first_config_entry (config.data, section)
	repeat
		coroutine.yield (entry, config:get (section, entry))
		entry, it = al.get_next_config_entry (it)
	until not it
end

local function the_iterator (config)
	for sec in config:sections () do
		for k, v in config:entries (sec) do
			coroutine.yield (sec, k, v)
		end
	end
end

--- Iterator over Config sections, returning only { section }.
--
-- @usage for sec in config:sections () do
--     -- loop body
-- end
function Config:sections ()
	return coroutine.wrap (section_name_iterator), self
end

--- Iterator over Config entries, returning the pair { key, value }.
--
-- @usage for key, value in config:entries (section) do
--     -- loop body
-- end
--
-- @string section The section for iteration
function Config:entries (section)
	return coroutine.wrap (entry_iterator), self, section
end

--- Iterator over a Config file, returning the triple { section, key, value }.
--
-- @usage for section, key, value in config:iterate () do
--     -- loop body
-- end
function Config:iterate ()
	return coroutine.wrap (the_iterator), self
end

--------------------------------------------------------------------------------
--  Load/Save
--  @section loadsave
--------------------------------------------------------------------------------

--- Read a configuration file from disk.
--
-- @string file_name Input file name
--
-- @treturn[0] Config New Config object
-- @treturn[1] nil on read errors
function Config.load (file_name)
	return Config.wrap (al.load_config_file (file_name))
end

--- Save a configuration to a file on disk.
--
-- @string file_name The file name
--
-- @return true on success, false otherwise
function Config:save (file_name)
	return al.save_config_file (file_name, self.data)
end

--- Read a configuration file from an already open ALLEGRO_FILE
--
-- @tparam ALLEGRO_FILE file Input file
--
-- @treturn[0] Config New Config object
-- @treturn[1] nil on read errors
function Config.load_f (file)
	return Config.wrap (al.load_config_file_f (file))
end

--- Save a configuration to an already open ALLEGRO_FILE
--
-- @tparam ALLEGRO_FILE file Output file
--
-- @return true on success, false otherwise
function Config:save_f (file)
	return al.save_config_file_f (file, self.data)
end

return Config
