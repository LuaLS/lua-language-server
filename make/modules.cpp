#include <bee/lua/binding.h>

extern "C" int luaopen_lpeglabel (lua_State *L);
static ::bee::lua::callfunc _init(::bee::lua::register_module, "lpeglabel", luaopen_lpeglabel);
