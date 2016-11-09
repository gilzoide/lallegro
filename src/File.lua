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

--- @classmod lallegro.File
-- ALLEGRO_FILE wrapper metatable, a GC enabled object, with nice methods. Users
-- will probably prefer using Lua's native file handling API, but this might be
-- useful for some.
local al = require 'lallegro.core'

local File = {}
-- Let File objects call the methods
File.__index = File

--------------------------------------------------------------------------------
--  Interface functions
--  @section wrapper
--------------------------------------------------------------------------------

--- Garbage collector should destroy the wrapped ALLEGRO_FILE.
--
-- If you plan to destroy the ALLEGRO_FILE manually, first `extract` it, as
-- `al_fclose` would double free the pointer.
function File:__gc ()
    al.fclose (self.data)
end

--- Wraps a ALLEGRO_FILE on a File object
--
-- @param al_file ALLEGRO_FILE to be wrapped
--
-- @return File object
function File.wrap (al_file)
	return al_file and setmetatable ({ data = al_file }, File)
end

--- Extracts the wrapped ALLEGRO_FILE, so that it will not be GCed.
--
-- This sets the inner ALLEGRO_FILE pointer as `NULL`, so it is not safe to
-- call any other methods after that.
function File:extract ()
	local al_file = self.data
	self.data = nil
	return al_file
end

--------------------------------------------------------------------------------
--  File opening and closing
--  @section openclose
--------------------------------------------------------------------------------

--- Open a file given the path and mode.
--
-- This is a wrapper for `al_fopen`
-- 
-- @string path File path to open
-- @string mode File access mode, like in `stdio`
function File.open (path, mode)
    return File.wrap (al.fopen (path, mode))
end

--- Open a file from an open file descriptor.
--
-- This is a wrapper for `al_fopen_fd`
--
-- @int fd File descriptor
-- @string mode File access mode, like in `stdio`
function File.open_fd (fd, mode)
	return File.wrap (al.fopen_fd (fd, mode))
end

--- Open a slice of an already open File.
--
-- This is a wrapper for `al_fopen_slice`. Every note in [`al_fopen_slice`
-- docs](http://liballeg.org/a5docs/trunk/file.html#al_fopen_slice) apply here.
function File:slice (initial_size, mode)
	return File.wrap (al.fopen_slice (self.data, initial_size, mode))
end

--- Close a File, writing any buffered output.
--
-- This is a wrapper for `al_fclose`
--
-- @treturn[0] bool true on success
-- @treturn[1] bool false on failure
-- @treturn[1] string Error message
function File:close ()
	local ret, err = al.fclose (self.data), self:errmsg ()
	self.data = nil
	return ret, err
end

--- Make a temporary randomly named file given a filename 'template'.
--
-- This is a wrapper for `al_make_temp_file`
function File.make_temp (template)
	return al.make_temp_file (template)
end

--------------------------------------------------------------------------------
--  File manipulation
--  @section manip
--------------------------------------------------------------------------------

--- Flush pending writes to the File.
--
-- This is a wrapper for `al_fflush`
--
-- @treturn bool true on success, false otherwise
function File:flush ()
	return al.fflush (self.data)
end

--- Get the current position in the given file.
--
-- This is a wrapper for `al_ftell`
--
-- @treturn[0] int Current position
-- @treturn[1] nil on errors
-- @treturn[1] string Error message
function File:tell ()
	local ret = al.ftell (self.data)
	if ret ~= -1 then return ret
	else return nil, self:errmsg () end
end

--- Set the current position of File to 'whence' + 'offset'.
--
-- This is a wrapper for `al_fseek`
--
-- Note that this wrapper follows Lua parameter order, so that Lua programmers
-- more familiarized with the API.
--
-- @tparam[opt='cur'] string whence Can be:
-- 'set': base is position 0;
-- 'cur': base is current position;
-- 'end': base is end of file;
-- @tparam[optchain=0] int offset Number of bytes in offset
--
-- @treturn bool true on success, false otherwise
function File:seek (whence, offset)
	if whence == 'set' then whence = al.ALLEGRO_SEEK_SET
	elseif whence == 'end' then whence = al.ALLEGRO_SEEK_END
	else whence = al.ALLEGRO_SEEK_CUR end

	offset = offset or 0
	return al.fseek (self.data, offset, whence)
end

--- Returns true if EOF indicator has been set for File.
--
-- This is a wrapper for `al_feof`
--
-- @treturn bool
function File:eof ()
	return al.feof (self.data)
end

--- Returns the size of File.
--
-- This is a wrapper for `al_fsize`
--
-- @treturn[0] int File size in bytes
-- @treturn[1] nil if size cannot be determined
function File:size ()
	local ret = al.fsize (self.data)
	if ret ~= -1 then return ret
	else return nil end
end

--------------------------------------------------------------------------------
--  Error handling
--  @section error
--------------------------------------------------------------------------------

--- Returns non-zero if error indicator is set for File.
--
-- This is a wrapper for `al_ferror`
function File:error ()
	return al.ferror (self.data)
end

--- Returns a message with details from the last error on File handle.
--
-- This is a wrapper for `al_ferrmsg`
--
-- @treturn string Empty string if there was no error, error message otherwise
function File:errmsg ()
	return al.ferrmsg (self.data)
end

--- Clear the error indicator for File.
--
-- This is a wrapper for `al_fclearerr`
function File:clearerr ()
	al.fclearerr (self.data)
end

--------------------------------------------------------------------------------
--  Read/Write
--  @section rw
--------------------------------------------------------------------------------

--- Read the next byte in File.
--
-- This is a wrapper for `al_fgetc`
--
-- @treturn[0] int Byte read
-- @treturn[1] nil on end of file, or on error
-- @treturn[1] string Error message
function File:getc ()
	local ret = al.fgetc (self.data)
	if ret ~= al.EOF then return ret
	else return nil, self:errmsg () end
end

--- Write a byte on File.
--
-- This is a wrapper for `al_fputc`
--
-- @treturn[0] int The written byte 'c' on success
-- @treturn[1] nil on end of file, or on error
-- @treturn[1] string Error message
function File:putc (c)
	local ret = al.fputc (self.data, c)
	if ret ~= al.EOF then return ret
	else return nil, self:errmsg () end
end

--- Write a formated string to File.
--
-- This is a wrapper for `al_fprintf`
--
-- Note that this functions uses Lua's `string.format`, so the format string
-- must be compliant to it
--
-- @treturn[0] bool true on success
-- @treturn[1] nil on error
-- @treturn[1] string Error message
function File:printf (format, ...)
	local ret = al.puts (self.data, string.format (format, ...))
	if ret ~= al.EOF then return true
	else return nil, self:errmsg () end
end

--- Reads at most `max` bytes from File.
--
-- This is a wrapper for `al_fgets`
--
-- @int max Maximum buffer size for reading
function File:gets (max)
	return al.fgets (self.data, max)
end

--- Write a string to File.
--
-- This is a wrapper for `al_fputs`
--
-- @string p String to be written
--
-- @treturn[0] bool true on success
-- @treturn[1] nil on error
-- @treturn[1] string Error message
function File:puts (p)
	local ret = al.fputs (self.data, p)
	if ret ~= al.EOF then return true
	else return nil, self:errmsg () end
end


return File
