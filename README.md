lallegro
========
Lua bindings for the [Allegro](http://liballeg.org/) game programming library
using [SWIG](http://swig.org/). 


Dependencies
------------
- [lua](http://www.lua.org/) >= 5.2
- [Allegro](http://liballeg.org/) >= 5.0
- [SWIG](http://swig.org/) (for building)


Using
-----
Require, use, have fun!

```lua
local al = require 'lallegro'
assert (al.init (), 'Failed to initialize Allegro =/')

local disp = al.create_display (800, 600)
al.clear_to_color (al.map_rgb (0, 0, 0))
al.flip_display ()
al.rest (5)
al.destroy_display (disp)
```


Bindings
--------
1 to 1 function binding is provided. Functions are renamed so the prefix `al_`
is removed, so the calls to functions use the Lua module as the Allegro
namespace.

For functions that have arguments passed by reference for getting output,
_lallegro_ uses Lua's multiple results to return them:

    x, y = al.get_window_position (display)

If argument is input
and output, you pass the value, and receive the output as function return:

    sec, it = al.get_next_config_section (it)

Addons are not dealt with for now, `allegro.h` only.


Wrappers
--------
Wrappers will be added someday to provide a more Lua style of programming, with
auto destroyed objects, metatables/metamethods, functional stuff, etc...
Focus is on the bindings for now.


Building
--------
With [make](https://www.gnu.org/software/make/):

    $ make


Installing
----------
Using [LuaRocks](https://luarocks.org/) remote:

    # luarocks install --server=http://luarocks.org/dev lallegro

Using [make](https://www.gnu.org/software/make/) directly:

    # make install


Documentation
-------------
The [Allegro Documentation](http://liballeg.org/a5docs/trunk/index.html) should
be widly used, as _lallegro_ provides 1 to 1 bindings.

[LDoc](https://github.com/stevedonovan/LDoc) will be used for documenting the
Lua specific stuff.
