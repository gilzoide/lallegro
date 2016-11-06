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
--  'native_dialog', 'primitives', 'video'
function al.init (...)
    if not al.install_system (al.ALLEGRO_VERSION_INT, nil) then
		return nil, "[lallegro.init] Couldn't initialize Allegro"
	end
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
--  'native_dialog', 'primitives', 'video'
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

--- Wrapper for `al_get_next_event` with default 2nd parameter
function al.get_next_event (queue, ret_event)
	ret_event = ret_event or al.ALLEGRO_EVENT ()
	return al._get_next_event (queue, ret_event), ret_event
end

--- Wrapper for `al_peek_next_event` with default 2nd parameter
function al.peek_next_event (queue, ret_event)
	ret_event = ret_event or al.ALLEGRO_EVENT ()
	return al._peek_next_event (queue, ret_event), ret_event
end

-- Unstable API with default output parameters
if al.ALLEGRO_UNSTABLE then
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

if al.ALLEGRO_UNSTABLE then
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
    assert (type (text) == 'string', "[lallegro.append_native_text_log] Only strings are supported")
    al._append_native_text_log (textlog, '%s', text)
end

import_all (require 'lallegro.physfs')
import_all (require 'lallegro.primitives')

--- Default stride: 2 floats
al.default_stride = 2 * al.float_size

--- Wrapper for `al_calculate_arc` with 'C array -> table' conversion
function al.calculate_arc (stride, cx, cy, rx, ry, start_theta, delta_theta,
        thickness, num_points)
    local arr_size = 2 * num_points
    local arr = al.new_float (arr_size)
    al._calculate_arc (arr, stride, cx, cy, rx, ry, start_theta, delta_theta,
            thickness, num_points)
    local ret = {}
    for i = 0, arr_size - 1 do
        table.insert (ret, al.float_getitem (arr, i))
    end
    al.delete_float (arr)
    return ret
end

--- Wrapper for `al_calculate_spline` with 'C array -> table' conversion
function al.calculate_spline (stride, points, thickness, num_points)
    local arr_size = thickness <= 0 and num_points or 2 * num_points
    local arr = al.new_float (arr_size)
    al._calculate_spline (arr, stride, points, thickness, num_points)
    local ret = {}
    for i = 0, arr_size - 1 do
        table.insert (ret, al.float_getitem (arr, i))
    end
    al.delete_float (arr)
    return ret
end

--- Wrapper for `al_calculate_ribbon` with 'C array -> table' conversion
function al.calculate_ribbon (dest_stride, points, points_stride, thickness)
    local num_segments = #points
    local arr_size = thickness <= 0 and num_segments or 2 * num_segments
    local arr = al.new_float (arr_size)
    local arr_points = al.new_float (num_segments)
    for i = 0, num_segments - 1 do
        al.float_setitem (arr_points, i, points[i + 1])
    end
    al._calculate_ribbon (arr, dest_stride, arr_points, points_stride
            , thickness, num_segments)
    al.delete_float (arr_points)
    local ret = {}
    for i = 0, arr_size - 1 do
        table.insert (ret, al.float_getitem (arr, i))
    end
    al.delete_float (arr)
    return ret
end

--- Wrapper for `al_draw_ribbon` with 'C array -> table' conversion
function al.draw_ribbon (points, points_stride, color, thickness)
    local arr = al.new_float (#points)
    for i, x in ipairs (points) do
        al.float_setitem (arr, i - 1, x)
    end
    al._draw_ribbon (arr, points_stride, color, thickness, #points / 2)
    al.delete_float (arr)
end

--- Wrapper for `al_draw_polyline` with 'C array -> table' conversion
function al.draw_polyline (vertices, vertex_stride, join_style, cap_style, color
		, thickness, miter_limit)
	local arr_size = #vertices
	local arr = al.new_float (arr_size)
	for i, x in ipairs (vertices) do
		al.float_setitem (arr, i - 1, x)
	end
	al._draw_polyline (arr, vertex_stride, arr_size, join_style, cap_style
			, color, thickness, miter_limit)
	al.delete_float (arr)
end

--- Wrapper for `al_draw_polygon` with 'C array -> table' conversion
function al.draw_polygon (vertices, join_style, color
		, thickness, miter_limit)
	local arr = al.new_float (#vertices)
	for i, x in ipairs (vertices) do
		al.float_setitem (arr, i - 1, x)
	end
	al._draw_polygon (arr, #vertices / 2, join_style, color, thickness
			, miter_limit)
	al.delete_float (arr)
end

--- Wrapper for `al_draw_filled_polygon` with 'C array -> table' conversion
function al.draw_filled_polygon (vertices, color)
	local arr = al.new_float (#vertices)
	for i, x in ipairs (vertices) do
		al.float_setitem (arr, i - 1, x)
	end
	al._draw_filled_polygon (arr, #vertices / 2, color)
	al.delete_float (arr)
end

--- Wrapper for `al_draw_filled_polygon_with_holes` with 'C array -> table' conversion
function al.draw_filled_polygon_with_holes (vertices, vertex_counts, color)
	local arr = al.new_float (#vertices)
	for i, x in ipairs (vertices) do
		al.float_setitem (arr, i - 1, x)
	end
	local arr_counts = al.new_int (#vertex_counts)
	for i, x in ipairs (vertex_counts) do
		al.int_setitem (arr_counts, i - 1, x)
	end
	al._draw_filled_polygon_with_holes (arr, arr_counts, color)
	al.delete_float (arr)
	al.delete_int (arr_counts)
end

import_all (require 'lallegro.video')

--------------------------------------------------------------------------------
--  Lua specific API
--------------------------------------------------------------------------------
al.Config = require 'lallegro.Config'

return al
