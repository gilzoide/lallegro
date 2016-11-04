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
