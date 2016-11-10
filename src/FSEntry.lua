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

--- @classmod lallegro.FSEntry
-- ALLEGRO_FS_ENTRY wrapper metatable, a GC enabled object, with nice methods.
local al = require 'lallegro.core'

local FSEntry = {}
-- Let File objects call the methods
FSEntry.__index = FSEntry

--------------------------------------------------------------------------------
--  Interface functions
--  @section wrapper
--------------------------------------------------------------------------------

--- Garbage collector should destroy the wrapped ALLEGRO_FS_ENTRY.
--
-- If you plan to destroy the ALLEGRO_FS_ENTRY manually, first `extract` it, as
-- `al_destroy_fs_entry` would double free the pointer.
function FSEntry:__gc ()
    al.destroy_fs_entry (self.data)
end

--- Wraps a ALLEGRO_FS_ENTRY on a FSEntry object
--
-- @param al_fs_entry ALLEGRO_FS_ENTRY to be wrapped
--
-- @return File object
function FSEntry.wrap (al_fs_entry)
	return al_fs_entry and setmetatable ({ data = al_fs_entry }, FSEntry)
end

--- Extracts the wrapped ALLEGRO_FS_ENTRY, so that it will not be GCed.
--
-- This sets the inner ALLEGRO_FS_ENTRY pointer as `NULL`, so it is not safe to
-- call any other methods after that.
function FSEntry:extract ()
	local al_fs_entry = self.data
	self.data = nil
	return al_fs_entry
end

--------------------------------------------------------------------------------
--  Creation/Deletion
--  @section create
--------------------------------------------------------------------------------

--- Creates a FSEntry object, if path exists on filesystem.
--
-- This is a wrapper for `al_create_fs_entry`
--
-- @string path File path to open FSEntry
function FSEntry.create (path)
	return al.filename_exists (path)
			and FSEntry.wrap (al.create_fs_entry (path))
			or nil
end

--- Delete file from filesystem.
--
-- This is a wrapper for `al_remove_fs_entry`
function FSEntry:remove ()
	return al.remove_fs_entry (self.data)
end

--------------------------------------------------------------------------------
--  Info getters
--  @section getter
--------------------------------------------------------------------------------

--- Updates file status for a FSEntry.
--
-- This is a wrapper for `al_update_fs_entry`
function FSEntry:update ()
	return al.update_fs_entry (self.data)
end

--- Check if FSEntry exists in filesystem.
--
-- As we don't allow creation of FSEntry when file doesn't exist, this will only
-- be true when FSEntry is removed
function FSEntry:exists ()
	return al.fs_entry_exists (self.data)
end

--- Returns entry's filename path
function FSEntry:name ()
	return al.get_fs_entry_name (self.data)
end

--- Returns the entry's mode flags in a Lua table.
--
-- This function returns a table with the modes as keys, in lowercase. Thus if
-- FSEntry is read mode, the result will have a `read` key as true.
--
-- This is a wrapper for `al_get_fs_entry_mode`
--
-- @treturn table Mode table
function FSEntry:mode ()
	local mode = al.get_fs_entry_mode (self.data)
	local ret = {}
	-- Lua 5.2 bit operations
	if _VERSION == 'Lua 5.2' then
		if bit32.band (mode, al.ALLEGRO_FILEMODE_READ) ~= 0 then ret.read = true end
		if bit32.band (mode, al.ALLEGRO_FILEMODE_WRITE) ~= 0 then ret.write = true end
		if bit32.band (mode, al.ALLEGRO_FILEMODE_EXECUTE) ~= 0 then ret.execute = true end
		if bit32.band (mode, al.ALLEGRO_FILEMODE_HIDDEN) ~= 0 then ret.hidden = true end
		if bit32.band (mode, al.ALLEGRO_FILEMODE_ISFILE) ~= 0 then ret.isfile = true end
		if bit32.band (mode, al.ALLEGRO_FILEMODE_ISDIR) ~= 0 then ret.isdir = true end
	else -- Lua 5.3 bit operations
		if mode & al.ALLEGRO_FILEMODE_READ ~= 0 then ret.read = true end
		if mode & al.ALLEGRO_FILEMODE_WRITE ~= 0 then ret.write = true end
		if mode & al.ALLEGRO_FILEMODE_EXECUTE ~= 0 then ret.execute = true end
		if mode & al.ALLEGRO_FILEMODE_HIDDEN ~= 0 then ret.hidden = true end
		if mode & al.ALLEGRO_FILEMODE_ISFILE ~= 0 then ret.isfile = true end
		if mode & al.ALLEGRO_FILEMODE_ISDIR ~= 0 then ret.isdir = true end
	end
	return ret
end

--- Returns the time in seconds since the epoch since the entry was last accessed.
--
-- This is a wrapper for `al_get_fs_entry_atime`
function FSEntry:atime ()
	return al.get_fs_entry_atime (self.data)
end

--- Returns the time in seconds since the epoch since the entry was created.
--
-- This is a wrapper for `al_get_fs_entry_ctime`
function FSEntry:ctime ()
	return al.get_fs_entry_ctime (self.data)
end

--- Returns the time in seconds since the epoch since the entry was last modified.
--
-- This is a wrapper for `al_get_fs_entry_mtime`
function FSEntry:mtime ()
	return al.get_fs_entry_mtime (self.data)
end

--- Returns the size, in bytes, of given entry
function FSEntry:size ()
	return al.get_fs_entry_size (self.data)
end

--------------------------------------------------------------------------------
--  Directory
--  @section dir
--------------------------------------------------------------------------------

local function dir_iterator (entry)
	al.open_directory (entry.data)
	local e = FSEntry.wrap (al.read_directory (entry.data))
	while e do
		coroutine.yield (e:name (), e)
 		e = FSEntry.wrap (al.read_directory (entry.data))
	end
	al.close_directory (entry.data)
end

--- Directory iterator, to be used with Lua's `pairs`
--
-- @usage for name, entry in pairs (dir_fs_entry) do
--     -- loop body
-- end
function FSEntry:__pairs ()
	return coroutine.wrap (dir_iterator), self
end

return FSEntry
