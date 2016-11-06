lallegro
========
Lua bindings for the [Allegro 5.2](http://liballeg.org/) game programming library
using [SWIG](http://swig.org/). 


Dependencies
------------
- [lua](http://www.lua.org/) >= 5.2
- [Allegro](http://liballeg.org/) >= 5.2
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
1 to 1 function binding is provided to almost all the Allegro API, including
addons. Functions are renamed so the prefix `al_` is removed, so the calls to
functions use the Lua module as the Allegro namespace.

A more Lua-style API is to be created as well, with auto destroyed objects,
metatables/metamethods, functional stuff, etc... And it'll all be documented!

Differences between the Allegro C API and this one is detailed in the
[API diff document](apidiff.md).


Building
--------
With [cmake](https://cmake.org/):

    $ mkdir build
	$ cd build
	$ cmake ..
	$ make

Call cmake with `-DALLEGRO_UNSTABLE=1` for including the [Allegro Unstable
API](http://liballeg.org/a5docs/trunk/getting_started.html#unstable-api)


Installing
----------
Using [LuaRocks](https://luarocks.org/)
[remote](https://luarocks.org/modules/gilzoide/lallegro):

    # luarocks install --server=http://luarocks.org/dev lallegro

Using [make](https://www.gnu.org/software/make/) directly (after building with
cmake):

    # make install


Documentation
-------------
The [Allegro Documentation](http://liballeg.org/a5docs/trunk/index.html) should
be widly used, as _lallegro_ provides 1 to 1 bindings.

[LDoc](https://github.com/stevedonovan/LDoc) used for documenting the Lua
specific stuff. Generate with `ldoc .`
