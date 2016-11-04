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
// INOUT trouble, let's bind it on our own
%native (al_get_next_config_section) int my_get_next_config_section (lua_State *L);
%native (al_get_next_config_entry) int my_get_next_config_entry (lua_State *L);
%{
int my_get_next_config_section (lua_State* L) {
    int SWIG_arg = 0;
    ALLEGRO_CONFIG_SECTION *arg1 ;
    char *result = 0 ;

    SWIG_check_num_args("get_next_config_section",1,1)
    if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("get_next_config_section",1,"ALLEGRO_CONFIG_SECTION **");

    if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_ALLEGRO_CONFIG_SECTION,0))){
        SWIG_fail_ptr("get_next_config_section",1,SWIGTYPE_p_ALLEGRO_CONFIG_SECTION);
    }

    result = (char *)al_get_next_config_section(&arg1);
    lua_pushstring(L,(const char *)result); SWIG_arg++;
    {
        SWIG_NewPointerObj (L, arg1, SWIGTYPE_p_ALLEGRO_CONFIG_SECTION, 0);
        SWIG_arg++;
    }
    return SWIG_arg;

    if(0) SWIG_fail;

fail:
    lua_error(L);
    return SWIG_arg;
}


int my_get_next_config_entry(lua_State* L) {
    int SWIG_arg = 0;
    ALLEGRO_CONFIG_ENTRY *arg1 ;
    char *result = 0 ;

    SWIG_check_num_args("get_next_config_entry",1,1)
    if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("get_next_config_entry",1,"ALLEGRO_CONFIG_ENTRY **");

    if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_ALLEGRO_CONFIG_ENTRY,0))){
        SWIG_fail_ptr("get_next_config_entry",1,SWIGTYPE_p_ALLEGRO_CONFIG_ENTRY);
    }

    result = (char *)al_get_next_config_entry(&arg1);
    lua_pushstring(L,(const char *)result); SWIG_arg++;
    {
        SWIG_NewPointerObj (L, arg1, SWIGTYPE_p_ALLEGRO_CONFIG_ENTRY, 0);
        SWIG_arg++;
    }
    return SWIG_arg;

    if(0) SWIG_fail;

fail:
    lua_error(L);
    return SWIG_arg;
}
%}
char const *al_get_first_config_section (ALLEGRO_CONFIG const *config, ALLEGRO_CONFIG_SECTION **OUTPUT);
char const *al_get_first_config_entry (ALLEGRO_CONFIG const *config, char const *section, ALLEGRO_CONFIG_ENTRY **OUTPUT);
%ignore al_get_first_config_section;
%ignore al_get_next_config_section;
%ignore al_get_first_config_entry;
%ignore al_get_next_config_entry;
%include "allegro5/config.h"

