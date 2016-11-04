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
function al.get_display_mode (index, mode)
    return al._get_display_mode (index, mode or al.ALLEGRO_DISPLAY_MODE ())
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

--[[  Memory MACROS  ]]--
local function get_context_info ()
    local dbg = debug.getinfo (3, "Sln")
    return dbg.currentline, dbg.short_src, dbg.name
end
--- Wrapper for al_malloc_with_context, with the context curried
function al.malloc (n)
    return lallegro_allegro.malloc_with_context (n, get_context_info ())
end

--- Wrapper for al_free_with_context, with the context curried
function al.free (ptr)
    return lallegro_allegro.free_with_context (ptr, get_context_info ())
end

--- Wrapper for al_realloc_with_context, with the context curried
function al.realloc (ptr, n)
    return lallegro_allegro.realloc_with_context (ptr, n, get_context_info ())
end

--- Wrapper for al_calloc_with_context, with the context curried
function al.calloc (count, n)
    return lallegro_allegro.free_with_context (count, n, get_context_info ())
end
--[[  END Memory MACROS  ]]--

--- Wrapper for al_get_monitor_info with default 2nd parameter
function al.get_monitor_info (adapter, info)
    info = info or al.ALLEGRO_MONITOR_INFO ()
    return al._get_monitor_info (adapter, info), info
end

--- Wrapper for al_get_mouse_state with default 1st parameter
function al.get_mouse_state (ret_state)
    ret_state = ret_state or al.ALLEGRO_MOUSE_STATE ()
    al._get_mouse_state (ret_state)
    return ret_state
end

--- Wrapper for al_path_cstr with default 2nd parameter
function al.path_cstr (path, delim)
    return al._path_cstr (path, delim or al.ALLEGRO_NATIVE_PATH_SEP)
end

--- Wrapper for al_store_state with default 1st parameter
function al.store_state (state, flags)
    if type (state) == 'number' then
        flags = state
        state = al.ALLEGRO_STATE ()
    end
    al._store_state (state, flags)
    return state
end

--- Wrapper for al_store_state with default 1st parameter
function al.init_timeout (timeout, seconds)
    if type (timeout) == 'number' then
        seconds = timeout
        timeout = al.ALLEGRO_TIMEOUT ()
    end
    al._init_timeout (timeout, seconds)
    return timeout
end

--- ALLEGRO_USECS_TO_SECS macro as function
function al.usecs_to_secs (us)
    return us / 1000000.0
end

--- ALLEGRO_MSECS_TO_SECS macro as function
function al.msecs_to_secs (ms)
    return ms / 1000.0
end

--- ALLEGRO_BPS_TO_SECS macro as function
function al.bps_to_secs (bps)
    return 1 / bps
end

--- ALLEGRO_BPM_TO_SECS macro as function
function al.bpm_to_secs (bpm)
    return 60 / bpm
end

return al
