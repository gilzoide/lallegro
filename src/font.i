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

/** Allegro Font addon **/
%module lallegro_font

%include "common.i"

// For functions that use C arrays and typemaps are difficult to use
%include <carrays.i>
%array_functions (int, int)

%{
#include <allegro5/allegro_font.h>
%}

/* Manually included functions, as SWIG is only preprocessing ALLEGRO_FONT_FUNC
 * to AL_FUNC, and complaining that AL_FUNC isn't valid C
 */
////////////////////////////////////////////////////////////////////////////////
// Types
typedef struct ALLEGRO_FONT ALLEGRO_FONT;

#ifdef ALLEGRO_UNSTABLE
typedef struct ALLEGRO_GLYPH ALLEGRO_GLYPH;
#endif

////////////////////////////////////////////////////////////////////////////////
// General font routines
bool al_init_font_addon(void);

void al_shutdown_font_addon(void);

ALLEGRO_FONT *al_load_font(char const *filename, int size, int flags);

void al_destroy_font(ALLEGRO_FONT *f);

int al_get_font_line_height(const ALLEGRO_FONT *f);

int al_get_font_ascent(const ALLEGRO_FONT *f);

int al_get_font_descent(const ALLEGRO_FONT *f);

int al_get_text_width(const ALLEGRO_FONT *f, const char *str);

void al_draw_text(const ALLEGRO_FONT *font, ALLEGRO_COLOR color
        , float x, float y, int flags, char const *text);

void al_draw_justified_text(const ALLEGRO_FONT *font, ALLEGRO_COLOR color
        , float x1, float x2, float y, float diff, int flags, const char *text);

%apply int *OUTPUT { int *bbx, int *bby, int *bbw, int *bbh };
void al_get_text_dimensions(const ALLEGRO_FONT *f, char const *text,
        int *bbx, int *bby, int *bbw, int *bbh);

uint32_t al_get_allegro_font_version(void);

%rename al_get_font_ranges _get_font_ranges;
int al_get_font_ranges(ALLEGRO_FONT *f, int ranges_count, int *ranges);

void al_set_fallback_font(ALLEGRO_FONT *font, ALLEGRO_FONT *fallback);

ALLEGRO_FONT *al_get_fallback_font(ALLEGRO_FONT *font);

////////////////////////////////////////////////////////////////////////////////
// Per glyph text handling
void al_draw_glyph(const ALLEGRO_FONT *f, ALLEGRO_COLOR color, float x, float y
        , int codepoint);

int al_get_glyph_width(const ALLEGRO_FONT *f, int codepoint);

// output already applied
bool al_get_glyph_dimensions(const ALLEGRO_FONT *f, int codepoint
        , int *bbx, int *bby, int *bbw, int *bbh);

int al_get_glyph_advance(const ALLEGRO_FONT *f, int codepoint1, int codepoint2);

////////////////////////////////////////////////////////////////////////////////
// Multiline text drawing
void al_draw_multiline_text(const ALLEGRO_FONT *font, ALLEGRO_COLOR color
        , float x, float y, float max_width, float line_height
        , int flags, const char *text);

////////////////////////////////////////////////////////////////////////////////
// Bitmap fonts
%rename al_grab_font_from_bitmap _grab_font_from_bitmap;
ALLEGRO_FONT *al_grab_font_from_bitmap(ALLEGRO_BITMAP *bmp, int ranges_n
        , const int *ranges);

ALLEGRO_FONT *al_load_bitmap_font(const char *fname);

ALLEGRO_FONT *al_load_bitmap_font_flags(const char *fname, int flags);

ALLEGRO_FONT *al_create_builtin_font(void);


////////////////////////////////////////////////////////////////////////////////
// Macros and Enums, again by hand
enum {
   ALLEGRO_NO_KERNING       = -1,
   ALLEGRO_ALIGN_LEFT       = 0,
   ALLEGRO_ALIGN_CENTRE     = 1,
   ALLEGRO_ALIGN_CENTER     = 1,
   ALLEGRO_ALIGN_RIGHT      = 2,
   ALLEGRO_ALIGN_INTEGER    = 4,
};

