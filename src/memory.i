// I don't think Lua devs will be `malloc`ing stuff, but who knows
// Devs are quite interesting beings

%luacode {
    function lallegro_allegro.malloc (n)
        local dbg = debug.getinfo (2, "Sln")
        return lallegro_allegro.malloc_with_context (n, dbg.currentline
                , dbg.short_src, dbg.name)
    end

    function lallegro_allegro.free (ptr)
        local dbg = debug.getinfo (2, "Sln")
        return lallegro_allegro.free_with_context (ptr, dbg.currentline
                , dbg.short_src, dbg.name)
    end

    function lallegro_allegro.realloc (ptr, n)
        local dbg = debug.getinfo (2, "Sln")
        return lallegro_allegro.realloc_with_context (ptr, n, dbg.currentline
                , dbg.short_src, dbg.name)
    end

    function lallegro_allegro.calloc (count, n)
        local dbg = debug.getinfo (2, "Sln")
        return lallegro_allegro.free_with_context (count, n, dbg.currentline
                , dbg.short_src, dbg.name)
    end
}

%ignore al_malloc;
%ignore al_free;
%ignore al_realloc;
%ignore al_calloc;
%include "allegro5/memory.h"
