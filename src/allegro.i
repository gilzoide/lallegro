%module lallegro_allegro

%{
#include "allegro5/allegro.h"
%}

%include <typemaps.i>

// Necessário pro SWIG entender a macro AL_FUNC
%include "allegro5/platform/alplatf.h"
%include "allegro5/internal/alconfig.h"

// Correção de aliasing de inteiros
%apply int { int32_t, int16_t };
%apply unsigned int { uint32_t };

// Ignores de funções com va_args, que buga no SWIG
// Use a formatação pelo Lua, e escreva com `al_puts`
%ignore al_fprintf;
%ignore al_vfprintf;
%ignore al_ustr_vappendf;
//

%include "allegro5/base.h"

%include "allegro5/altime.h"
%include "allegro5/bitmap.h"
%include "allegro5/bitmap_draw.h"
%include "allegro5/bitmap_io.h"
%include "allegro5/bitmap_lock.h"
%include "allegro5/blender.h"
%include "allegro5/clipboard.h"
%include "allegro5/color.h"
// Config: com tretas de INOUT
%include "config.i"
//
%include "allegro5/cpu.h"
%include "allegro5/debug.h"
// Display: OUTPUT
%apply int *OUTPUT { int *importance };
%apply int *OUTPUT { int *x, int *y };
%apply int *OUTPUT { int *min_w, int *min_h, int *max_w, int *max_h };
%include "allegro5/display.h"
//
%include "allegro5/drawing.h"
%include "allegro5/error.h"
%include "allegro5/events.h"
// File: buffer initialization, make_temp_file multi return
%include "file.i"
//
%include "allegro5/fixed.h"
%include "allegro5/fmaths.h"
// FSHook: Buffer alloc
%newobject al_get_current_directory;
%include "allegro5/fshook.h"
//
%include "allegro5/fullscreen_mode.h"
%include "allegro5/haptic.h"
%include "allegro5/joystick.h"
%include "allegro5/keyboard.h"
%include "allegro5/memory.h"
%include "allegro5/monitor.h"
%include "allegro5/mouse.h"
%include "allegro5/mouse_cursor.h"
%include "allegro5/path.h"
%include "allegro5/render_state.h"
%include "allegro5/shader.h"
%include "allegro5/system.h"
%include "allegro5/threads.h"
%include "allegro5/timer.h"
%include "allegro5/tls.h"
%include "allegro5/touch_input.h"
%include "allegro5/transformations.h"
%include "allegro5/utf8.h"

// Função extra: al_init
%native (init) int my_init (lua_State *L);
%{
int my_init (lua_State *L) {
    lua_pushboolean (L, al_init ());
    return 1;
}
%}
