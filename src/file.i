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
%native (al_fgets) int my_fgets (lua_State *L);
%{
int my_fgets (lua_State *L) {
    int SWIG_arg = 0;
    ALLEGRO_FILE *arg1 = (ALLEGRO_FILE *) 0 ;
    char *arg2 ;
    size_t arg3 ;
    char *result = 0 ;

    SWIG_check_num_args("fgets",2,2)
    if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("fgets",1,"ALLEGRO_FILE *");
    if(!lua_isnumber(L,2)) SWIG_fail_arg("fgets",2,"size_t");

    if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_ALLEGRO_FILE,0))){
        SWIG_fail_ptr("fgets",1,SWIGTYPE_p_ALLEGRO_FILE);
    }

    SWIG_contract_assert((lua_tonumber(L,2)>=0),"number must not be negative")
    arg3 = (size_t)lua_tonumber(L, 2);
    // allocate the buffer to max
    arg2 = al_malloc (arg3);
    if (!arg2) {
        lua_pushliteral (L, "Couldn't allocate enough buffer for \"fgets\"");
        SWIG_fail;
    }

    result = (char *)al_fgets(arg1,arg2,arg3);
    lua_pushstring(L,(const char *)result); SWIG_arg++;
    // and free it, no memory leaks allowed ;]
    al_free (arg2);
    return SWIG_arg;

    if(0) SWIG_fail;

fail:
    lua_error(L);
    return SWIG_arg;
}
%}

ALLEGRO_FILE *al_make_temp_file (const char *template, ALLEGRO_PATH **OUTPUT);

%ignore al_fgets;
%ignore al_make_temp_file;
%include "allegro5/file.h"
