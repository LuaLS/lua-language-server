#include <bee/lua/module.h>

extern "C" int luaopen_lpeglabel (lua_State *L);
static ::bee::lua::callfunc _init_lpeg(::bee::lua::register_module, "lpeglabel", luaopen_lpeglabel);

extern "C" int luaopen_ltask_bootstrap (lua_State *L);
static ::bee::lua::callfunc _init_ltask(::bee::lua::register_module, "ltask.bootstrap", luaopen_ltask_bootstrap);

#ifdef CODE_FORMAT
extern "C" int luaopen_code_format(lua_State *L);
static ::bee::lua::callfunc _init_code_format(::bee::lua::register_module, "code_format",
                                  luaopen_code_format);
#endif
