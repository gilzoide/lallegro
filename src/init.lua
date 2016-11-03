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

-- Unstable API with default output parameters
if al.UNSTABLE then
    --- Wrapper for al_upload_haptic_effect with default 3rd parameter
    function al.upload_haptic_effect (hap, effect, id)
        id = id or al.ALLEGRO_HAPTIC_EFFECT_ID ()
        return al._upload_haptic_effect (hap, effect, id), id
    end
    --- Wrapper for al_upload_and_play_haptic_effect with default 3rd parameter
    function al.upload_and_play_haptic_effect (hap, effect, id, loop)
        id = id or al.ALLEGRO_HAPTIC_EFFECT_ID ()
        return al._upload_and_play_haptic_effect (hap, effect, id, loop), id
    end
    --- Wrapper for al_rumble_haptic with default 4th parameter
    function al.rumble_haptic (hap, intensity, duration, id)
        id = id or al.ALLEGRO_HAPTIC_EFFECT_ID ()
        return al._rumble_haptic (hap, intensity, duration, id), id
    end
end

--- Wrapper for al_get_joystick_state with default 2nd parameter
function al.get_joystick_state (joy, ret_state)
    ret_state = ret_state or al.ALLEGRO_JOYSTICK_STATE ()
    al._get_joystick_state (joy, ret_state)
    return ret_state
end

--- Wrapper for al_get_keyboard_state with default 1st parameter
function al.get_keyboard_state (ret_state)
    ret_state = ret_state or al.ALLEGRO_KEYBOARD_STATE ()
    al._get_keyboard_state (ret_state)
    return ret_state
end

--- Wrapper for al_get_monitor_info with default 2nd parameter
function al.get_monitor_info (adapter, info)
    info = info or al.ALLEGRO_MONITOR_INFO ()
    return al._get_monitor_info (adapter, info), info
end

return al
