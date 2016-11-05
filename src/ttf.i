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

/** Allegro TTF addon **/
%module lallegro_ttf

%include "common.i"

%{
#include <allegro5/allegro_ttf.h>
%}

/* Manually included functions, as SWIG is only preprocessing ALLEGRO_TTF_FUNC
 * to AL_FUNC, and complaining that AL_FUNC isn't valid C
 */
bool al_init_ttf_addon(void);

void al_shutdown_ttf_addon(void);

ALLEGRO_FONT *al_load_ttf_font(char const *filename, int size, int flags);

ALLEGRO_FONT *al_load_ttf_font_f(ALLEGRO_FILE *file, char const *filename
        , int size, int flags);

ALLEGRO_FONT *al_load_ttf_font_stretch(char const *filename, int w, int h
        , int flags);

ALLEGRO_FONT *al_load_ttf_font_stretch_f(ALLEGRO_FILE *file
        , char const *filename, int w, int h, int flags);

uint32_t al_get_allegro_ttf_version(void);

#ifdef ALLEGRO_UNSTABLE
%rename al_get_glyph al__get_glyph;
bool al_get_glyph(const ALLEGRO_FONT *f, int prev_codepoint, int codepoint
        , ALLEGRO_GLYPH *glyph);
#endif
