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

--- @module lallegro.Fullscreen
-- Fullscreen modes iterator

local al = require 'lallegro.core'

local Fullscreen = {}

local function display_mode_iterator ()
	local mode = al.ALLEGRO_DISPLAY_MODE ()
	for i = 0, al.get_num_display_modes () - 1 do
		al.get_display_mode (i, mode)
		coroutine.yield (i, mode.width, mode.height, mode.format, mode.refresh_rate)
	end
end

--- Iterator over fullscreen modes, returning { mode\_number, width, height, format, refresh_rate }
--
-- @usage for i, width, height, format, refresh_rate in al.Fullscreen.modes () do
--     -- loop body
-- end
function Fullscreen.modes ()
	return coroutine.wrap (display_mode_iterator)
end

return Fullscreen
