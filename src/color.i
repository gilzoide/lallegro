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

/** Allegro Color addon **/
%module lallegro_color

%include "common.i"

%{
#include <allegro5/allegro_color.h>
%}

/* Manually included functions, as SWIG is only preprocessing ALLEGRO_TTF_FUNC
 * to AL_FUNC, and complaining that AL_FUNC isn't valid C
 */
ALLEGRO_COLOR al_color_cmyk(float c, float m, float y, float k);

%apply float *OUTPUT { float *red, float *green, float *blue };
void al_color_cmyk_to_rgb(float cyan, float magenta, float yellow
        , float key, float *red, float *green, float *blue);

ALLEGRO_COLOR al_color_hsl(float h, float s, float l);

// output already applied
void al_color_hsl_to_rgb(float hue, float saturation, float lightness
        , float *red, float *green, float *blue);

ALLEGRO_COLOR al_color_hsv(float h, float s, float v);

void al_color_hsv_to_rgb(float hue, float saturation, float value
        , float *red, float *green, float *blue);

ALLEGRO_COLOR al_color_html(char const *string);

// output already applied
bool al_color_html_to_rgb(char const *string
        , float *red, float *green, float *blue);

%native (al_color_rgb_to_html) int my_color_rgb_to_html (lua_State *L);
%{
int my_color_rgb_to_html (lua_State *L) {
    float r = luaL_checknumber (L, 1);
    float g = luaL_checknumber (L, 1);
    float b = luaL_checknumber (L, 1);
    char ret[8];
    al_color_rgb_to_html (r, g, b, ret);
    lua_pushlstring (L, ret, 7);
    return 1;
}
%}

ALLEGRO_COLOR al_color_name(char const *name);

%apply float *OUTPUT { float *r, float *g, float *b };
bool al_color_name_to_rgb(char const *name, float *r, float *g, float *b);

%apply float *OUTPUT { float *cyan, float *magenta, float *yellow, float *key };
void al_color_rgb_to_cmyk(float red, float green, float blue
        , float *cyan, float *magenta, float *yellow, float *key);

%apply float *OUTPUT { float *hue, float *saturation, float *lightness };
void al_color_rgb_to_hsl(float red, float green, float blue
        , float *hue, float *saturation, float *lightness);

%apply float *OUTPUT { float *hue, float *saturation, float *value };
void al_color_rgb_to_hsv(float red, float green, float blue
        , float *hue, float *saturation, float *value);

char const *al_color_rgb_to_name(float r, float g, float b);

%apply float *OUTPUT { float *y, float *u, float *v };
void al_color_rgb_to_yuv(float red, float green, float blue
        , float *y, float *u, float *v);

ALLEGRO_COLOR al_color_yuv(float y, float u, float v);

// output already applied
void al_color_yuv_to_rgb(float y, float u, float v
        , float *red, float *green, float *blue);

uint32_t al_get_allegro_color_version(void);
