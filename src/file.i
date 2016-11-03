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
    arg2 = malloc (arg3);
    if (!arg2) {
        lua_pushliteral (L, "Couldn't allocate enough buffer for \"fgets\"");
        SWIG_fail;
    }

    result = (char *)al_fgets(arg1,arg2,arg3);
    lua_pushstring(L,(const char *)result); SWIG_arg++;
    // and free it, no memory leaks allowed ;]
    free (arg2);
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
