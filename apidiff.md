C and Lua API differences
=========================

Macros
------
Some Allegro functionality is facilitated by preprocessor macros. _Lallegro_
implements them as functions, always using lower case. Macros implemented:

- `al_init`
- `al_malloc`
- `al_free`
- `al_realloc`
- `al_calloc`
- `ALLEGRO_USECS_TO_SECS` as `usecs_to_secs`
- `ALLEGRO_MSECS_TO_SECS` as `msecs_to_secs`
- `ALLEGRO_BPS_TO_SECS` as `bps_to_secs`
- `ALLEGRO_BPM_TO_SECS` as `bpm_to_secs`


Argument Output
---------------
For functions that have arguments passed by reference for getting output,
_lallegro_ uses Lua's multiple results to return them:

    x, y = al.get_window_position (display)

Some important exceptions are the event getters `al_get_next_event`,
`al_peek_next_event`, `al_wait_for_event*`, that makes you explicitly pass an
`ALLEGRO_EVENT` to avoid desnecessary memory allocation:

```lua
local queue = al.create_event_queue ()
local ev = al.ALLEGRO_EVENT ()
while not get_out do
    al.wait_for_event (queue, ev)
    -- do your stuff
end
```

Another one is the display mode getter `al_get_display_mode`, that lets you
choose between creating a new `ALLEGRO_DISPLAY_MODE` or reusing your own:

```lua
-- create the ALLEGRO_DISPLAY_MODE once only
local disp_mode = al.ALLEGRO_DISPLAY_MODE ()
-- now change the display mode, without having to create another one
for i = 0, al.get_num_display_modes () - 1 do
    al.get_display_mode (i, disp_mode)
    print (string.format ("%d - %dx%d", i, disp_mode.width, disp_mode.height))
end

-- or maybe you just want the first one, so no need to explicitly create it
local a_new_disp_mode = al.get_display_mode (0)

```


Var args
--------
SWIG doesn't handle var args functions very well, thus the functions
`al_fprintf`, `al_vfprintf`, `al_ustr_vappendf` are not binded. One can always
format a string directly in Lua using `string.format`, so this ain't no trouble.


Threads
-------
Threads in Lua aren't that easy to handle, so Allegro thread API isn't bound.
Use coroutines or some other threading Lua library for this.
