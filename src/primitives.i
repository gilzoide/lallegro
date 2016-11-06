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

/** Allegro Primitives addon **/
%module lallegro_primitives

%include "common.i"

%{
#include <allegro5/allegro_primitives.h>
%}

// For functions that use C arrays and typemaps are difficult to use
%include <carrays.i>
%array_functions (float, float)

/* Manually included functions, as SWIG is only preprocessing
 * ALLEGRO_PRIM_FUNC to AL_FUNC, and complaining that AL_FUNC isn't valid
 * C
 */
////////////////////////////////////////////////////////////////////////////////
// Types
typedef struct ALLEGRO_VERTEX ALLEGRO_VERTEX;

typedef struct ALLEGRO_VERTEX_DECL ALLEGRO_VERTEX_DECL;

typedef struct ALLEGRO_VERTEX_ELEMENT ALLEGRO_VERTEX_ELEMENT;

typedef struct ALLEGRO_VERTEX_BUFFER ALLEGRO_VERTEX_BUFFER;

typedef struct ALLEGRO_INDEX_BUFFER ALLEGRO_INDEX_BUFFER;

////////////////////////////////////////////////////////////////////////////////
// General
uint32_t al_get_allegro_primitives_version(void);

bool al_init_primitives_addon(void);

void al_shutdown_primitives_addon(void);

////////////////////////////////////////////////////////////////////////////////
// High level drawing routines
void al_draw_line(float x1, float y1, float x2, float y2
        , ALLEGRO_COLOR color, float thickness);

void al_draw_triangle(float x1, float y1, float x2, float y2
        , float x3, float y3, ALLEGRO_COLOR color, float thickness);

void al_draw_filled_triangle(float x1, float y1, float x2, float y2
        , float x3, float y3, ALLEGRO_COLOR color);

void al_draw_rectangle(float x1, float y1, float x2, float y2
        , ALLEGRO_COLOR color, float thickness);

void al_draw_filled_rectangle(float x1, float y1, float x2, float y2
        , ALLEGRO_COLOR color);

void al_draw_rounded_rectangle(float x1, float y1, float x2, float y2
        , float rx, float ry, ALLEGRO_COLOR color, float thickness);

void al_draw_filled_rounded_rectangle(float x1, float y1, float x2, float y2
        , float rx, float ry, ALLEGRO_COLOR color);

/// Float size, for calculating strides
%constant int float_size = sizeof (float);

%rename al_calculate_arc _calculate_arc;
void al_calculate_arc(float* dest, int stride, float cx, float cy
        , float rx, float ry, float start_theta, float delta_theta
        , float thickness, int num_points);

void al_draw_pieslice(float cx, float cy, float r, float start_theta
        , float delta_theta, ALLEGRO_COLOR color, float thickness);

void al_draw_filled_pieslice(float cx, float cy, float r, float start_theta
        , float delta_theta, ALLEGRO_COLOR color);

void al_draw_ellipse(float cx, float cy, float rx, float ry
        , ALLEGRO_COLOR color, float thickness);

void al_draw_filled_ellipse(float cx, float cy, float rx, float ry
        , ALLEGRO_COLOR color);

void al_draw_circle(float cx, float cy, float r, ALLEGRO_COLOR color
        , float thickness);

void al_draw_filled_circle(float cx, float cy, float r, ALLEGRO_COLOR color);

void al_draw_arc(float cx, float cy, float r, float start_theta
        , float delta_theta, ALLEGRO_COLOR color, float thickness);

void al_draw_elliptical_arc(float cx, float cy, float rx, float ry
        , float start_theta, float delta_theta, ALLEGRO_COLOR color
        , float thickness);

%rename al_calculate_spline _calculate_spline;
void al_calculate_spline(float* dest, int stride, float points[8]
        , float thickness, int num_segments);

void al_draw_spline(float points[8], ALLEGRO_COLOR color, float thickness);

%rename al_calculate_ribbon _calculate_ribbon;
void al_calculate_ribbon(float* dest, int dest_stride, const float *points
        , int points_stride, float thickness, int num_segments);

%rename al_draw_ribbon _draw_ribbon;
void al_draw_ribbon(const float *points, int points_stride, ALLEGRO_COLOR color
        , float thickness, int num_segments);

////////////////////////////////////////////////////////////////////////////////
// Low level drawing routines
int al_draw_prim(const void* vtxs, const ALLEGRO_VERTEX_DECL* decl
        , ALLEGRO_BITMAP* texture, int start, int end, int type);

%apply (int *INPUT, int) { (const int *indices, int num_vtx) };
int al_draw_indexed_prim(const void* vtxs, const ALLEGRO_VERTEX_DECL* decl
        , ALLEGRO_BITMAP* texture, const int* indices, int num_vtx, int type);

int al_draw_vertex_buffer(ALLEGRO_VERTEX_BUFFER* vertex_buffer
        , ALLEGRO_BITMAP* texture, int start, int end, int type);

int al_draw_indexed_buffer(ALLEGRO_VERTEX_BUFFER* vertex_buffer
		, ALLEGRO_BITMAP* texture, ALLEGRO_INDEX_BUFFER* index_buffer
		, int start, int end, int type);

////////////////////////////////////////////////////////////////////////////////
// Custom vertex declaration routines
ALLEGRO_VERTEX_DECL* al_create_vertex_decl(const ALLEGRO_VERTEX_ELEMENT* elements
		, int stride);

void al_destroy_vertex_decl(ALLEGRO_VERTEX_DECL* decl);

////////////////////////////////////////////////////////////////////////////////
// Vertex buffer routines
ALLEGRO_VERTEX_BUFFER* al_create_vertex_buffer(ALLEGRO_VERTEX_DECL* decl
		, const void* initial_data, int num_vertices, int flags);

void al_destroy_vertex_buffer(ALLEGRO_VERTEX_BUFFER* buffer);

void* al_lock_vertex_buffer(ALLEGRO_VERTEX_BUFFER* buffer, int offset
		, int length, int flags);

void al_unlock_vertex_buffer(ALLEGRO_VERTEX_BUFFER* buffer);

int al_get_vertex_buffer_size(ALLEGRO_VERTEX_BUFFER* buffer);

////////////////////////////////////////////////////////////////////////////////
// Index buffer routines
ALLEGRO_INDEX_BUFFER* al_create_index_buffer(int index_size
		, const void* initial_data, int num_indices, int flags);

void al_destroy_index_buffer(ALLEGRO_INDEX_BUFFER* buffer);

void* al_lock_index_buffer(ALLEGRO_INDEX_BUFFER* buffer, int offset
		, int length, int flags);

void al_unlock_index_buffer(ALLEGRO_INDEX_BUFFER* buffer);

int al_get_index_buffer_size(ALLEGRO_INDEX_BUFFER* buffer);

////////////////////////////////////////////////////////////////////////////////
// Polygon routines
%rename al_draw_polyline _draw_polyline;
void al_draw_polyline(const float* vertices, int vertex_stride
		, int vertex_count, int join_style, int cap_style, ALLEGRO_COLOR color
		, float thickness, float miter_limit);

%rename al_draw_polygon _draw_polygon;
void al_draw_polygon(const float *vertices, int vertex_count, int join_style
		, ALLEGRO_COLOR color, float thickness, float miter_limit);

%rename al_draw_filled_polygon _draw_filled_polygon;
void al_draw_filled_polygon(const float *vertices, int vertex_count
		, ALLEGRO_COLOR color);

%rename al_draw_filled_polygon_with_holes _draw_filled_polygon_with_holes;
void al_draw_filled_polygon_with_holes(const float *vertices
		, const int *vertex_counts, ALLEGRO_COLOR color);

///////////////////////////////////////////////////////////////////////////////
// Macros and Enums, again by hand
typedef enum ALLEGRO_PRIM_TYPE
{
  ALLEGRO_PRIM_LINE_LIST,
  ALLEGRO_PRIM_LINE_STRIP,
  ALLEGRO_PRIM_LINE_LOOP,
  ALLEGRO_PRIM_TRIANGLE_LIST,
  ALLEGRO_PRIM_TRIANGLE_STRIP,
  ALLEGRO_PRIM_TRIANGLE_FAN,
  ALLEGRO_PRIM_POINT_LIST,
  ALLEGRO_PRIM_NUM_TYPES
} ALLEGRO_PRIM_TYPE;

enum
{
   ALLEGRO_PRIM_MAX_USER_ATTR = _ALLEGRO_PRIM_MAX_USER_ATTR
};

/* Enum: ALLEGRO_PRIM_ATTR
 */
typedef enum ALLEGRO_PRIM_ATTR
{
   ALLEGRO_PRIM_POSITION = 1,
   ALLEGRO_PRIM_COLOR_ATTR,
   ALLEGRO_PRIM_TEX_COORD,
   ALLEGRO_PRIM_TEX_COORD_PIXEL,
   ALLEGRO_PRIM_USER_ATTR,
   ALLEGRO_PRIM_ATTR_NUM = ALLEGRO_PRIM_USER_ATTR + ALLEGRO_PRIM_MAX_USER_ATTR
} ALLEGRO_PRIM_ATTR;

/* Enum: ALLEGRO_PRIM_STORAGE
 */
typedef enum ALLEGRO_PRIM_STORAGE
{
   ALLEGRO_PRIM_FLOAT_2,
   ALLEGRO_PRIM_FLOAT_3,
   ALLEGRO_PRIM_SHORT_2,
   ALLEGRO_PRIM_FLOAT_1,
   ALLEGRO_PRIM_FLOAT_4,
   ALLEGRO_PRIM_UBYTE_4,
   ALLEGRO_PRIM_SHORT_4,
   ALLEGRO_PRIM_NORMALIZED_UBYTE_4,
   ALLEGRO_PRIM_NORMALIZED_SHORT_2,
   ALLEGRO_PRIM_NORMALIZED_SHORT_4,
   ALLEGRO_PRIM_NORMALIZED_USHORT_2,
   ALLEGRO_PRIM_NORMALIZED_USHORT_4,
   ALLEGRO_PRIM_HALF_FLOAT_2,
   ALLEGRO_PRIM_HALF_FLOAT_4
} ALLEGRO_PRIM_STORAGE;

/* Enum: ALLEGRO_LINE_JOIN
 */
typedef enum ALLEGRO_LINE_JOIN
{
   ALLEGRO_LINE_JOIN_NONE,
   ALLEGRO_LINE_JOIN_BEVEL,
   ALLEGRO_LINE_JOIN_ROUND,
   ALLEGRO_LINE_JOIN_MITER,
   ALLEGRO_LINE_JOIN_MITRE = ALLEGRO_LINE_JOIN_MITER
} ALLEGRO_LINE_JOIN;

/* Enum: ALLEGRO_LINE_CAP
 */
typedef enum ALLEGRO_LINE_CAP
{
   ALLEGRO_LINE_CAP_NONE,
   ALLEGRO_LINE_CAP_SQUARE,
   ALLEGRO_LINE_CAP_ROUND,
   ALLEGRO_LINE_CAP_TRIANGLE,
   ALLEGRO_LINE_CAP_CLOSED
} ALLEGRO_LINE_CAP;

/* Enum: ALLEGRO_PRIM_BUFFER_FLAGS
 */
typedef enum ALLEGRO_PRIM_BUFFER_FLAGS
{
   ALLEGRO_PRIM_BUFFER_STREAM       = 0x01,
   ALLEGRO_PRIM_BUFFER_STATIC       = 0x02,
   ALLEGRO_PRIM_BUFFER_DYNAMIC      = 0x04,
   ALLEGRO_PRIM_BUFFER_READWRITE    = 0x08
} ALLEGRO_PRIM_BUFFER_FLAGS;

/* Enum: ALLEGRO_VERTEX_CACHE_SIZE
 */
#define ALLEGRO_VERTEX_CACHE_SIZE 256

/* Enum: ALLEGRO_PRIM_QUALITY
 */
#define ALLEGRO_PRIM_QUALITY 10
