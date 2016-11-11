High level Lua wrappers
=======================
Alongside with Allegro bindings, _lallegro_ comes with a more high level API
using Lua as it's meant to be used.

There are wrappers for objects, and for utilities. For objects, there are
metatables with garbage collection routines, iterators, Lua operators and
methods wrapping Allegro functionality. Utilities are usually iterators, or
functions to make some conversion between Lua tables and Allegro objects.


Name convention
---------------
Wrappers and their metatables are all `CamelCased`, to highlight the high level
from low level APIs. The submodule names are also `CamelCased`.

Method names generally follow Allegro's function names, and are `snake_cased`,
so you know exactly what to expect from methods and what they wrap. Extra
methods may be added for extra Lua functionality, like iterators, `tostring`,
and stuff.


Using
-----
These wrappers are not `require`d directly into _lallegro_, so you must do
it yourself. Don't copy the functions directly to the same table, as function
names would clash (there are common functions, like `wrap`, `extract`, `__gc`,
etc.).

```
local al = require 'lallegro'
al.Config = require 'lallegro.Config'

local cfg = al.Config.load ("myConfigurationFile.cfg")
local t = cfg:to_table ()
assert (t.window.width, "Please provide a width for your window!")
-- cfg GCed, game over
```
