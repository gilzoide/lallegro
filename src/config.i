%native (al_get_first_config_section) int my_get_first_config_section (lua_State *L);
%native (al_get_next_config_section) int my_get_next_config_section (lua_State *L);
%native (al_get_first_config_entry) int my_get_first_config_entry (lua_State *L);
%native (al_get_next_config_entry) int my_get_next_config_entry (lua_State *L);
%{
int my_get_first_config_section(lua_State* L) {
    int SWIG_arg = 0;
    ALLEGRO_CONFIG *arg1 = (ALLEGRO_CONFIG *) 0 ;
    ALLEGRO_CONFIG_SECTION *arg2 ;
    char *result = 0 ;

    SWIG_check_num_args("get_first_config_section",1,1)
    if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("get_first_config_section",1,"ALLEGRO_CONFIG const *");

    if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_ALLEGRO_CONFIG,0))){
        SWIG_fail_ptr("get_first_config_section",1,SWIGTYPE_p_ALLEGRO_CONFIG);
    }

    result = (char *)al_get_first_config_section((struct ALLEGRO_CONFIG const *)arg1,&arg2);
    lua_pushstring(L,(const char *)result); SWIG_arg++;
    {
        SWIG_NewPointerObj (L, arg2, SWIGTYPE_p_ALLEGRO_CONFIG_SECTION, 0);
        SWIG_arg++;
    }
    return SWIG_arg;

    if(0) SWIG_fail;

fail:
    lua_error(L);
    return SWIG_arg;
}


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


int my_get_first_config_entry(lua_State* L) {
    int SWIG_arg = 0;
    ALLEGRO_CONFIG *arg1 = (ALLEGRO_CONFIG *) 0 ;
    char *arg2 = (char *) 0 ;
    ALLEGRO_CONFIG_ENTRY *arg3 ;
    char *result = 0 ;

    SWIG_check_num_args("get_first_config_entry",2,2)
    if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("get_first_config_entry",1,"ALLEGRO_CONFIG const *");
    if(!SWIG_lua_isnilstring(L,2)) SWIG_fail_arg("get_first_config_entry",2,"char const *");

    if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_ALLEGRO_CONFIG,0))){
        SWIG_fail_ptr("get_first_config_entry",1,SWIGTYPE_p_ALLEGRO_CONFIG);
    }

    arg2 = (char *)lua_tostring(L, 2);

    result = (char *)al_get_first_config_entry((struct ALLEGRO_CONFIG const *)arg1,(char const *)arg2,&arg3);
    lua_pushstring(L,(const char *)result); SWIG_arg++;
    {
        SWIG_NewPointerObj (L, arg3, SWIGTYPE_p_ALLEGRO_CONFIG_ENTRY, 0);
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
%ignore al_get_first_config_section;
%ignore al_get_next_config_section;
%ignore al_get_first_config_entry;
%ignore al_get_next_config_entry;
%include "allegro5/config.h"

