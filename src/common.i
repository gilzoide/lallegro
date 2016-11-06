/* Copyright 2016 Gil Barbosa Reis <gilzoide@gmail.com>
 * This file is part of Lallegro.
 *
 * Lallegro is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Lallegro is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Lallegro.  If not, see <http://www.gnu.org/licenses/>.
 */
/// Common stuff for Allegro module, and addons

%{
#include <allegro5/allegro.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
%}

%include <typemaps.i>

// Needed for SWIG to understand the AL_FUNC macro
%include <allegro5/platform/alplatf.h>
%include <allegro5/internal/alconfig.h>

// Integer type alias correction
%apply int { int32_t, int16_t };
%apply unsigned int { uint32_t };
%apply long int { int64_t };

// C arrays (no pointers)
%typemap (in) float[ANY] (float temp[$1_dim0]) {
    int i, size;
    // assert length
    lua_len (L, $input);
    size = lua_tointeger (L, -1);
    if (size != $1_dim0) {
        luaL_error (L, "expected %d floats in table, not %d", $1_dim0, size);
    }
    for (i = 0; i < $1_dim0; i++) {
        lua_geti (L, $input, i + 1);
        temp[i] = luaL_checknumber (L, -1);
    }
    lua_pop (L, $1_dim0 + 1);
    $1 = temp;
}
%typemap (in) int[ANY] (int temp[$1_dim0]) {
    int i, size;
    // assert length
    lua_len (L, $input);
    size = lua_tointeger (L, -1);
    if (size != $1_dim0) {
        luaL_error (L, "expected %d ints in table, not %d", $1_dim0, size);
    }
    for (i = 0; i < $1_dim0; i++) {
        lua_geti (L, $input, i + 1);
        temp[i] = luaL_checkinteger (L, -1);
    }
    lua_pop (L, $1_dim0 + 1);
    $1 = temp;
}

// Strip the prepending "al_" from functions, so we use Lua's module as namespace
%rename ("%(strip:[al_])s") "";
