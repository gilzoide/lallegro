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
-- along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
--]]

--- Módulo
local al = require 'lallegro.allegro'

--- Wrapper for al_get_display_mode with default 2nd parameter
--
-- @param idx Display mode index
-- @param[opt=ALLEGRO_DISPLAY_MODE()] disp_mode Display mode to be filled, optional
--
-- @return Display mode at index
function al.get_display_mode (idx, disp_mode)
    return al._get_display_mode (idx, disp_mode or al.ALLEGRO_DISPLAY_MODE ())
end

return al
