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

/** Allegro Core module **/
%module lallegro_core

%include "common.i"

// Ignores va_args functions, as SWIG doesn't handle them well
// Instead of `al_fprintf`, format the string on Lua and call `al_puts` instead
%ignore al_fprintf;
%ignore al_vfprintf;
%ignore al_ustr_vappendf;
//

%include <allegro5/base.h>

// Time: OUTPUT
%rename al_init_timeout _init_timeout;
%include <allegro5/altime.h>
// Bitmap: OUTPUT
%apply int *OUTPUT { int *x, int *y, int *w, int *h };
%include <allegro5/bitmap.h>
//
%include <allegro5/bitmap_draw.h>
%include <allegro5/bitmap_io.h>
%include <allegro5/bitmap_lock.h>
%include <allegro5/blender.h>
%include <allegro5/clipboard.h>
// Color: OUTPUT
%apply unsigned char *OUTPUT {
    unsigned char *r, unsigned char *g, unsigned char *b, unsigned char *a
};
%apply float *OUTPUT {
    float *r, float *g, float *b, float *a
};
%include <allegro5/color.h>
// Config: INOUT trouble
%include "config.i"
//
%include <allegro5/cpu.h>
%include <allegro5/debug.h>
// Display: OUTPUT
%apply int *OUTPUT { int *importance };
%apply int *OUTPUT { int *x, int *y }; // the %apply in Bitmap already covers this one, but let's be verbose
%apply int *OUTPUT { int *min_w, int *min_h, int *max_w, int *max_h };
%include <allegro5/display.h>
//
%include <allegro5/drawing.h>
%include <allegro5/error.h>
// Events: OUTPUT on Lua
%rename al_get_next_event _get_next_event;
%rename al_peek_next_event _peek_next_event;
%include <allegro5/events.h>
// File: buffer initialization, make_temp_file multi return
%include "file.i"
//
%include <allegro5/fixed.h>
// FMaths: ignore the lookup tables
%ignore _al_fix_cos_tbl;
%ignore _al_fix_tan_tbl;
%ignore _al_fix_acos_tbl;
%include <allegro5/fmaths.h>
// FSHook: Buffer alloc
%newobject al_get_current_directory;
%include <allegro5/fshook.h>
// Fullscreen modes: OUTPUT on Lua
%rename al_get_display_mode _get_display_mode;
%include <allegro5/fullscreen_mode.h>
// Haptic: OUTPUT on Lua
%rename al_upload_haptic_effect _upload_haptic_effect;
%rename al_upload_and_play_haptic_effect _upload_and_play_haptic_effect;
%rename al_rumble_haptic _rumble_haptic;
%include <allegro5/haptic.h>
// Joystick: OUTPUT on Lua
%rename al_get_joystick_state _get_joystick_state;
%include <allegro5/joystick.h>
// Keyboard: OUTPUT on Lua
%rename al_get_keyboard_state _get_keyboard_state;
%include <allegro5/keyboard.h>
%include <allegro5/keycodes.h>
/* Memory: macros
 * I don't think Lua devs will be `malloc`ing stuff, but who knows
 * Devs are quite interesting beings
 */
%ignore al_malloc;
%ignore al_free;
%ignore al_realloc;
%ignore al_calloc;
%include <allegro5/memory.h>
// Monitor: OUTPUT on Lua
%rename al_get_monitor_info _get_monitor_info;
%include <allegro5/monitor.h>
// Mouse: OUTPUT on Lua, OUTPUT
%rename al_get_mouse_state _get_mouse_state;
%apply int *OUTPUT { int *ret_x, int *ret_y };
%include <allegro5/mouse.h>
//
%include <allegro5/mouse_cursor.h>
// Path: default argument
%rename al_path_cstr _path_cstr;
%include <allegro5/path.h>
//
%include <allegro5/render_state.h>
// Shader: array -> tables
%apply (int *INPUT, int) { (const int *i, int num_elems) };
%apply (float *INPUT, int) { (const float *f, int num_elems) };
%include <allegro5/shader.h>
//
%include <allegro5/system.h>
/* Threads: threads in Lua aren't that easy to handle. Use coroutines or some
 * other threading Lua library.
 * %include <allegro5/threads.h>
 */
// Timer: macros
%include <allegro5/timer.h>
// TLS: OUTPUT, store_state OUTPUT on Lua
%apply int *OUTPUT {
    int *op, int *src, int *dst, int *alpha_op, int *alpha_src, int *alpha_dst
}
%rename al_store_state _store_state;
%include <allegro5/tls.h>
// Touch Input: OUTPUT on Lua
%rename al_get_touch_input_state _get_touch_input_state;
%include <allegro5/touch_input.h>
// Transformations: OUTPUT on Lua, INOUT
%rename al_copy_transform _copy_transform;
%rename al_identity_transform _identity_transform;
%rename al_build_transform _build_transform;
%rename al_build_camera_transform _build_camera_transform;
%apply float *INOUT { float *x, float *y, float *z };
%include <allegro5/transformations.h>
/* UTF-8: Lua 5.3 gives us basic UTF-8 encoding, and Allegro API doesn't really
 * add much to it, aside from memory concerns (which don't apply to Lua)
 * %include <allegro5/utf8.h>
 */

// Extra function: al_init
%native (_init) int my_init (lua_State *L);
%{
int my_init (lua_State *L) {
    lua_pushboolean (L, al_init ());
    return 1;
}
%}

#ifdef ALLEGRO_UNSTABLE
#undef ALLEGRO_UNSTABLE
%constant bool ALLEGRO_UNSTABLE = true;
#endif


// Platform we're running
#ifdef ALLEGRO_WINDOWS
#undef ALLEGRO_WINDOWS
%constant bool ALLEGRO_WINDOWS = true;
#endif

#ifdef ALLEGRO_UNIX
#undef ALLEGRO_UNIX
%constant bool ALLEGRO_UNIX = true;
#endif

#ifdef ALLEGRO_MACOSX
#undef ALLEGRO_MACOSX
%constant bool ALLEGRO_MACOSX = true;
#endif
