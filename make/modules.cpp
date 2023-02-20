#include <binding/binding.h>

extern "C" int luaopen_lpeglabel (lua_State *L);
static ::bee::lua::callfunc _init(::bee::lua::register_module, "lpeglabel", luaopen_lpeglabel);

#ifdef CODE_FORMAT
extern "C" int luaopen_code_format(lua_State *L);
static ::bee::lua::callfunc _init_code_format(::bee::lua::register_module, "code_format",
                                  luaopen_code_format);
#endif
