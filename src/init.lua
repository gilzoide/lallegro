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

--- @module lallegro
-- Lallegro module, with (almost) all Allegro functions bound to it. Check the
-- [Allegro Reference](http://liballeg.org/a5docs/trunk/index.html) for info
-- on the functions.

-- Start off with the Core
local al = require 'lallegro.core'

--- Initializes Allegro and whatever addon you want
--
-- Valid addons are, for now: 'audio', 'acodec', 'font', 'ttf', 'image',
--  'native_dialog', 'video'
function al.init (...)
    if not al._init () then return nil, "[lallegro.init] Couldn't initialize Allegro" end
    for _, addon in ipairs { ... } do
        local mod = al['init_' .. addon .. '_addon']
        if not mod then return nil, "[lallegro.init] Addon \"" .. addon .. "\" not supported" end
        if not mod () then return nil, "[lallegro.init] Couldn't initialize " .. addon .. " addon" end
    end
    return true
end

--- Shutdowns whatever addon you want
--
-- Valid addons are, for now: 'audio', 'acodec', 'font', 'ttf', 'image',
--  'native_dialog', 'video'
function al.shutdown (...)
    for _, addon in ipairs { ... } do
        local mod = al['shutdown_' .. addon .. '_addon']
        if not mod then return nil, "[lallegro.shutdown] Addon \"" .. addon .. "\" not supported" end
        if not mod () then return nil, "[lallegro.shutdown] Couldn't shutdown " .. addon .. " addon" end
    end
    return true
end

--- Installs the specified drivers
--
-- Valid drivers are: 'haptic', 'joystick', 'keyboard', 'mouse', 'touch_input',
-- and 'audio' if the 'audio' addon was initialized
function al.install (...)
    for _, driver in ipairs { ... } do
        local installer = al['install_' .. driver]
        if not installer then return nil, "[lallegro.install] Driver \"" .. driver .. "\" not supported" end
        if not installer () then return nil, "[lallegro.install] Couldn't install " .. driver .. " driver" end
    end
    return true
end

--- Unnstalls the specified drivers
--
-- Valid drivers are: 'haptic', 'joystick', 'keyboard', 'mouse', 'touch_input',
-- and 'audio' if the 'audio' addon was initialized
function al.uninstall (...)
    for _, driver in ipairs { ... } do
        local uninstaller = al['uninstall_' .. driver]
        if not uninstaller then return nil, "[lallegro.uninstall] Driver \"" .. driver .. "\" not supported" end
        uninstaller ()
    end
    return true
end

--- Wrapper for `al_get_display_mode` with default 2nd parameter
function al.get_display_mode (index, mode)
    return al._get_display_mode (index, mode or al.ALLEGRO_DISPLAY_MODE ())
end

-- Unstable API with default output parameters
if al.UNSTABLE then
    --- Wrapper for `al_upload_haptic_effect` with default 3rd parameter
    function al.upload_haptic_effect (hap, effect, id)
        id = id or al.ALLEGRO_HAPTIC_EFFECT_ID ()
        return al._upload_haptic_effect (hap, effect, id), id
    end
    --- Wrapper for `al_upload_and_play_haptic_effect` with default 3rd parameter
    function al.upload_and_play_haptic_effect (hap, effect, id, loop)
        id = id or al.ALLEGRO_HAPTIC_EFFECT_ID ()
        return al._upload_and_play_haptic_effect (hap, effect, id, loop), id
    end
    --- Wrapper for `al_rumble_haptic` with default 4th parameter
    function al.rumble_haptic (hap, intensity, duration, id)
        id = id or al.ALLEGRO_HAPTIC_EFFECT_ID ()
        return al._rumble_haptic (hap, intensity, duration, id), id
    end
end

--- Wrapper for `al_get_joystick_state` with default 2nd parameter
function al.get_joystick_state (joy, ret_state)
    ret_state = ret_state or al.ALLEGRO_JOYSTICK_STATE ()
    al._get_joystick_state (joy, ret_state)
    return ret_state
end

--- Wrapper for `al_get_keyboard_state` with default 1st parameter
function al.get_keyboard_state (ret_state)
    ret_state = ret_state or al.ALLEGRO_KEYBOARD_STATE ()
    al._get_keyboard_state (ret_state)
    return ret_state
end

--[[  Memory MACROS  ]]--
--- Get the context info for the memory macros, Lua style.
-- @local
local function get_context_info ()
    local dbg = debug.getinfo (3, "Sln")
    return dbg.currentline, dbg.short_src, dbg.name
end
--- Wrapper for `al_malloc_with_context`, with the context curried
function al.malloc (n)
    return lallegro_allegro.malloc_with_context (n, get_context_info ())
end

--- Wrapper for `al_free_with_context`, with the context curried
function al.free (ptr)
    return lallegro_allegro.free_with_context (ptr, get_context_info ())
end

--- Wrapper for `al_realloc_with_context`, with the context curried
function al.realloc (ptr, n)
    return lallegro_allegro.realloc_with_context (ptr, n, get_context_info ())
end

--- Wrapper for `al_calloc_with_context`, with the context curried
function al.calloc (count, n)
    return lallegro_allegro.free_with_context (count, n, get_context_info ())
end
--[[  END Memory MACROS  ]]--

--- Wrapper for `al_get_monitor_info` with default 2nd parameter
function al.get_monitor_info (adapter, info)
    info = info or al.ALLEGRO_MONITOR_INFO ()
    return al._get_monitor_info (adapter, info), info
end

--- Wrapper for `al_get_mouse_state` with default 1st parameter
function al.get_mouse_state (ret_state)
    ret_state = ret_state or al.ALLEGRO_MOUSE_STATE ()
    al._get_mouse_state (ret_state)
    return ret_state
end

--- Wrapper for `al_path_cstr` with default 2nd parameter
function al.path_cstr (path, delim)
    return al._path_cstr (path, delim or al.ALLEGRO_NATIVE_PATH_SEP)
end

--- Wrapper for `al_store_state` with default 1st parameter
function al.store_state (state, flags)
    if type (state) == 'number' then
        flags = state
        state = al.ALLEGRO_STATE ()
    end
    al._store_state (state, flags)
    return state
end

--- Wrapper for `al_store_state` with default 1st parameter
function al.init_timeout (timeout, seconds)
    if type (timeout) == 'number' then
        seconds = timeout
        timeout = al.ALLEGRO_TIMEOUT ()
    end
    al._init_timeout (timeout, seconds)
    return timeout
end

--- `ALLEGRO_USECS_TO_SECS` macro as function
function al.usecs_to_secs (us)
    return us / 1000000.0
end

--- `ALLEGRO_MSECS_TO_SECS` macro as function
function al.msecs_to_secs (ms)
    return ms / 1000.0
end

--- `ALLEGRO_BPS_TO_SECS` macro as function
function al.bps_to_secs (bps)
    return 1 / bps
end

--- `ALLEGRO_BPM_TO_SECS` macro as function
function al.bpm_to_secs (bpm)
    return 60 / bpm
end

--- Wrapper for `al_get_touch_input_state` with default 1st parameter
function al.get_touch_input_state (ret_state)
    ret_state = ret_state or al.ALLEGRO_TOUCH_INPUT_STATE ()
    al._get_touch_input_state (ret_state)
    return ret_state
end

--- Wrapper for `al_copy_transform` with default 1st parameter
function al.copy_transform (dest, src)
    if src == nil then
        src = dest
        dest = al.ALLEGRO_TRANSFORM ()
    end
    al._copy_transform (dest, src)
    return dest
end

--- Wrapper for `al_identity_transform` with default 1st parameter
function al.identity_transform (trans)
    trans = trans or al.ALLEGRO_TRANSFORM ()
    al._identity_transform (trans)
    return trans
end

--- Wrapper for `al_build_transform` with default 1st parameter
function al.build_transform (trans, x, y, sx, sy, theta)
    if type (trans) == 'number' then
        x, y, sx, sy, theta = trans, x, y, sx, sy
        trans = al.ALLEGRO_TRANSFORM ()
    end
    al._build_transform (trans, x, y, sx, sy, theta)
    return trans
end

--- Wrapper for `al_build_camera_transform` with default 1st parameter
function al.build_camera_transform (trans
        , position_x, position_y, position_z
        , look_x, look_y, look_z
        , up_x, up_y, up_z)
    if type (trans) == 'number' then
        position_x, position_y, position_z
                , look_x, look_y, look_z
                , up_x, up_y, up_z
                = trans, position_x, position_y
                , position_z, look_x, look_y
                , look_z, up_x, up_y
        trans = al.ALLEGRO_TRANSFORM ()
    end
    al._build_camera_transform (trans
            , position_x, position_y, position_z
            , look_x, look_y, look_z
            , up_x, up_y, up_z)
    return trans
end

--------------------------------------------------------------------------------
--  ADDONS
--------------------------------------------------------------------------------

--- Import every symbol in submodule to lallegro module.
-- @local
local function import_all (submod)
    for k, v in pairs (submod) do
        al[k] = v
    end
end

import_all (require 'lallegro.audio')
import_all (require 'lallegro.acodec')
import_all (require 'lallegro.color')
import_all (require 'lallegro.font')

--- Wrapper for `al_get_display_mode` 'C array -> table' conversion
function al.get_font_ranges (f, ranges_count)
    local arr_size = 2 * ranges_count
    local arr = al.new_int (arr_size)
    local ret = al._get_font_ranges (f, ranges_count, arr)
    local ranges = {}
    for i = 0, arr_size - 1 do
        table.insert (ranges, al.int_getitem (arr, i))
    end
    al.delete_int (arr)
    return ret, ranges
end

--- Wrapper for `al_grab_font_from_bitmap` with 'table -> C array' conversion
function al.grab_font_from_bitmap (bmp, ranges)
    local arr = al.new_int (#ranges)
    for i, r in ipairs (ranges) do
        al.int_setitem (arr, i - 1, r)
    end
    local ret = al._grab_font_from_bitmap (bmp, #ranges, arr)
    al.delete_int (arr)
    return ret
end

import_all (require 'lallegro.ttf')

if al.UNSTABLE then
    --- Wrapper for `al_get_glyph` with default 4th parameter
    function al.get_glyph (f, prev_codepoint, codepoint, glyph)
        glyph = glyph or al.ALLEGRO_GLYPH ()
        return al._get_glyph (f, prev_codepoint, codepoint, glyph)
    end
end

import_all (require 'lallegro.image')
import_all (require 'lallegro.memfile')
import_all (require 'lallegro.dialog')

--- Wrapper for `al_append_native_text_log`, with '%s' as format.
--
-- Calls `al_append_native_text_log (textlog, "%s", text)`.
-- Format `text` in Lua, and you're good to go
function al.append_native_text_log (textlog, text)
    al._append_native_text_log (textlog, '%s', text)
end

import_all (require 'lallegro.physfs')
import_all (require 'lallegro.video')

return al
