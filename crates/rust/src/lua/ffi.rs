//! Raw FFI declarations for the Lua 5.5 C API.
//!
//! The Lua VM lives inside the lua-language-server process (statically linked
//! into the exe). On Windows the exe exports the `lua_*`/`luaL_*` symbols, so we
//! reference them with `raw-dylib` + `+verbatim` (resolved against the already
//! loaded `lua-language-server.exe` at runtime, no import lib needed). On other
//! platforms the symbols are resolved at `dlopen` time from the host process
//! (built with `-Wl,-E`/`-rdynamic`); macOS additionally needs
//! `-undefined dynamic_lookup`, which [`build.rs`] adds via
//! `cargo:rustc-cdylib-link-arg`.

use std::os::raw::{c_char, c_int, c_uint, c_void};

/// Opaque `lua_State`.
#[repr(C)]
pub struct LuaState {
    _private: [u8; 0],
}

/// `lua_Integer` (`long long` on all supported platforms).
pub type LuaInteger = i64;
/// `lua_Number` (double).
pub type LuaNumber = f64;
/// `lua_Unsigned`.
pub type LuaUnsigned = u64;
/// `lua_KContext`.
pub type LuaKContext = isize;

/// Lua C function signature.
pub type LuaCFunction = unsafe extern "C" fn(state: *mut LuaState) -> c_int;
/// Lua continuation function signature.
pub type LuaKFunction =
    unsafe extern "C" fn(state: *mut LuaState, status: c_int, ctx: LuaKContext) -> c_int;
/// Lua reader function signature.
pub type LuaReader =
    unsafe extern "C" fn(state: *mut LuaState, ud: *mut c_void, size: *mut usize) -> *const c_char;
/// Lua writer function signature.
pub type LuaWriter = unsafe extern "C" fn(
    state: *mut LuaState,
    p: *const c_void,
    sz: usize,
    ud: *mut c_void,
) -> c_int;
/// Lua allocator function signature.
pub type LuaAlloc = unsafe extern "C" fn(
    ud: *mut c_void,
    ptr: *mut c_void,
    osize: usize,
    nsize: usize,
) -> *mut c_void;

/// Name/function pair passed to [`luaL_setfuncs`].
#[repr(C)]
pub struct LuaLReg {
    pub name: *const c_char,
    pub func: Option<LuaCFunction>,
}

pub const LUA_VERSION_NUM: c_int = 505;
pub const LUA_MULTRET: c_int = -1;

pub const LUA_REGISTRYINDEX: c_int = -(i32::MAX / 2 + 1000);

pub const LUA_OK: c_int = 0;
pub const LUA_YIELD: c_int = 1;
pub const LUA_ERRRUN: c_int = 2;
pub const LUA_ERRSYNTAX: c_int = 3;
pub const LUA_ERRMEM: c_int = 4;
pub const LUA_ERRERR: c_int = 5;

pub const LUA_TNONE: c_int = -1;
pub const LUA_TNIL: c_int = 0;
pub const LUA_TBOOLEAN: c_int = 1;
pub const LUA_TLIGHTUSERDATA: c_int = 2;
pub const LUA_TNUMBER: c_int = 3;
pub const LUA_TSTRING: c_int = 4;
pub const LUA_TTABLE: c_int = 5;
pub const LUA_TFUNCTION: c_int = 6;
pub const LUA_TUSERDATA: c_int = 7;
pub const LUA_TTHREAD: c_int = 8;
pub const LUA_NUMTYPES: c_int = 9;

pub const LUA_RIDX_GLOBALS: c_int = 2;
pub const LUA_RIDX_MAINTHREAD: c_int = 3;

pub const LUA_NOREF: c_int = -2;
pub const LUA_REFNIL: c_int = -1;

pub const LUA_GCSTOP: c_int = 0;
pub const LUA_GCRESTART: c_int = 1;
pub const LUA_GCCOLLECT: c_int = 2;
pub const LUA_GCCOUNT: c_int = 3;
pub const LUA_GCCOUNTB: c_int = 4;
pub const LUA_GCSTEP: c_int = 5;
pub const LUA_GCISRUNNING: c_int = 6;

/// `lua_upvalueindex(i)`.
pub fn upvalue_index(i: c_int) -> c_int {
    LUA_REGISTRYINDEX - i
}

#[cfg(windows)]
#[link(
    name = "lua-language-server.exe",
    kind = "raw-dylib",
    modifiers = "+verbatim"
)]
unsafe extern "C" {
    // state manipulation
    pub fn lua_newstate(f: LuaAlloc, ud: *mut c_void, seed: c_uint) -> *mut LuaState;
    pub fn lua_close(state: *mut LuaState);
    pub fn lua_newthread(state: *mut LuaState) -> *mut LuaState;
    pub fn lua_closethread(state: *mut LuaState, from: *mut LuaState) -> c_int;

    // basic stack manipulation
    pub fn lua_absindex(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_gettop(state: *mut LuaState) -> c_int;
    pub fn lua_settop(state: *mut LuaState, idx: c_int);
    pub fn lua_pushvalue(state: *mut LuaState, idx: c_int);
    pub fn lua_rotate(state: *mut LuaState, idx: c_int, n: c_int);
    pub fn lua_copy(state: *mut LuaState, fromidx: c_int, toidx: c_int);
    pub fn lua_checkstack(state: *mut LuaState, n: c_int) -> c_int;
    pub fn lua_xmove(from: *mut LuaState, to: *mut LuaState, n: c_int);

    // access functions (stack -> C)
    pub fn lua_isnumber(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_isstring(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_iscfunction(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_isinteger(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_isuserdata(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_type(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_typename(state: *mut LuaState, tp: c_int) -> *const c_char;

    pub fn lua_tonumberx(state: *mut LuaState, idx: c_int, isnum: *mut c_int) -> LuaNumber;
    pub fn lua_tointegerx(state: *mut LuaState, idx: c_int, isnum: *mut c_int) -> LuaInteger;
    pub fn lua_toboolean(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_tolstring(state: *mut LuaState, idx: c_int, len: *mut usize) -> *const c_char;
    pub fn lua_rawlen(state: *mut LuaState, idx: c_int) -> LuaUnsigned;
    pub fn lua_tocfunction(state: *mut LuaState, idx: c_int) -> LuaCFunction;
    pub fn lua_touserdata(state: *mut LuaState, idx: c_int) -> *mut c_void;
    pub fn lua_tothread(state: *mut LuaState, idx: c_int) -> *mut LuaState;
    pub fn lua_topointer(state: *mut LuaState, idx: c_int) -> *const c_void;

    // comparison
    pub fn lua_rawequal(state: *mut LuaState, idx1: c_int, idx2: c_int) -> c_int;
    pub fn lua_compare(state: *mut LuaState, idx1: c_int, idx2: c_int, op: c_int) -> c_int;

    // push functions (C -> stack)
    pub fn lua_pushnil(state: *mut LuaState);
    pub fn lua_pushnumber(state: *mut LuaState, n: LuaNumber);
    pub fn lua_pushinteger(state: *mut LuaState, n: LuaInteger);
    pub fn lua_pushlstring(state: *mut LuaState, s: *const c_char, len: usize) -> *const c_char;
    pub fn lua_pushstring(state: *mut LuaState, s: *const c_char) -> *const c_char;
    pub fn lua_pushcclosure(state: *mut LuaState, f: LuaCFunction, n: c_int);
    pub fn lua_pushboolean(state: *mut LuaState, b: c_int);
    pub fn lua_pushlightuserdata(state: *mut LuaState, p: *mut c_void);
    pub fn lua_pushthread(state: *mut LuaState) -> c_int;

    // get functions (Lua -> stack)
    pub fn lua_getglobal(state: *mut LuaState, name: *const c_char) -> c_int;
    pub fn lua_gettable(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_getfield(state: *mut LuaState, idx: c_int, k: *const c_char) -> c_int;
    pub fn lua_geti(state: *mut LuaState, idx: c_int, n: LuaInteger) -> c_int;
    pub fn lua_rawget(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_rawgeti(state: *mut LuaState, idx: c_int, n: LuaInteger) -> c_int;
    pub fn lua_rawgetp(state: *mut LuaState, idx: c_int, p: *const c_void) -> c_int;

    pub fn lua_createtable(state: *mut LuaState, narr: c_int, nrec: c_int);
    pub fn lua_newuserdatauv(state: *mut LuaState, sz: usize, nuvalue: c_int) -> *mut c_void;
    pub fn lua_getmetatable(state: *mut LuaState, objindex: c_int) -> c_int;
    pub fn lua_getiuservalue(state: *mut LuaState, idx: c_int, n: c_int) -> c_int;

    // set functions (stack -> Lua)
    pub fn lua_setglobal(state: *mut LuaState, name: *const c_char);
    pub fn lua_settable(state: *mut LuaState, idx: c_int);
    pub fn lua_setfield(state: *mut LuaState, idx: c_int, k: *const c_char);
    pub fn lua_seti(state: *mut LuaState, idx: c_int, n: LuaInteger);
    pub fn lua_rawset(state: *mut LuaState, idx: c_int);
    pub fn lua_rawseti(state: *mut LuaState, idx: c_int, n: LuaInteger);
    pub fn lua_rawsetp(state: *mut LuaState, idx: c_int, p: *const c_void);
    pub fn lua_setmetatable(state: *mut LuaState, objindex: c_int) -> c_int;
    pub fn lua_setiuservalue(state: *mut LuaState, idx: c_int, n: c_int) -> c_int;

    // 'load' and 'call' functions
    pub fn lua_callk(
        state: *mut LuaState,
        nargs: c_int,
        nresults: c_int,
        ctx: LuaKContext,
        k: Option<LuaKFunction>,
    );
    pub fn lua_pcallk(
        state: *mut LuaState,
        nargs: c_int,
        nresults: c_int,
        errfunc: c_int,
        ctx: LuaKContext,
        k: Option<LuaKFunction>,
    ) -> c_int;
    pub fn lua_load(
        state: *mut LuaState,
        reader: LuaReader,
        dt: *mut c_void,
        chunkname: *const c_char,
        mode: *const c_char,
    ) -> c_int;
    pub fn lua_dump(
        state: *mut LuaState,
        writer: LuaWriter,
        data: *mut c_void,
        strip: c_int,
    ) -> c_int;

    // coroutine functions
    pub fn lua_yieldk(
        state: *mut LuaState,
        nresults: c_int,
        ctx: LuaKContext,
        k: Option<LuaKFunction>,
    ) -> c_int;
    pub fn lua_resume(
        state: *mut LuaState,
        from: *mut LuaState,
        narg: c_int,
        nres: *mut c_int,
    ) -> c_int;
    pub fn lua_status(state: *mut LuaState) -> c_int;
    pub fn lua_isyieldable(state: *mut LuaState) -> c_int;

    // miscellaneous functions
    pub fn lua_error(state: *mut LuaState) -> c_int;
    pub fn lua_next(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_concat(state: *mut LuaState, n: c_int);
    pub fn lua_len(state: *mut LuaState, idx: c_int);
    pub fn lua_stringtonumber(state: *mut LuaState, s: *const c_char) -> usize;
    pub fn lua_getallocf(state: *mut LuaState, ud: *mut *mut c_void) -> LuaAlloc;
    pub fn lua_setallocf(state: *mut LuaState, f: LuaAlloc, ud: *mut c_void);
    pub fn lua_toclose(state: *mut LuaState, idx: c_int);
    pub fn lua_closeslot(state: *mut LuaState, idx: c_int);

    // lauxlib
    pub fn luaL_checkversion_(state: *mut LuaState, ver: LuaNumber, sz: usize);
    pub fn luaL_getmetafield(state: *mut LuaState, obj: c_int, e: *const c_char) -> c_int;
    pub fn luaL_callmeta(state: *mut LuaState, obj: c_int, e: *const c_char) -> c_int;
    pub fn luaL_tolstring(state: *mut LuaState, idx: c_int, len: *mut usize) -> *const c_char;
    pub fn luaL_argerror(state: *mut LuaState, arg: c_int, extramsg: *const c_char) -> c_int;
    pub fn luaL_typeerror(state: *mut LuaState, arg: c_int, tname: *const c_char) -> c_int;
    pub fn luaL_checklstring(state: *mut LuaState, arg: c_int, len: *mut usize) -> *const c_char;
    pub fn luaL_optlstring(
        state: *mut LuaState,
        arg: c_int,
        def: *const c_char,
        len: *mut usize,
    ) -> *const c_char;
    pub fn luaL_checknumber(state: *mut LuaState, arg: c_int) -> LuaNumber;
    pub fn luaL_optnumber(state: *mut LuaState, arg: c_int, def: LuaNumber) -> LuaNumber;
    pub fn luaL_checkinteger(state: *mut LuaState, arg: c_int) -> LuaInteger;
    pub fn luaL_optinteger(state: *mut LuaState, arg: c_int, def: LuaInteger) -> LuaInteger;
    pub fn luaL_checkstack(state: *mut LuaState, sz: c_int, msg: *const c_char);
    pub fn luaL_checktype(state: *mut LuaState, arg: c_int, t: c_int);
    pub fn luaL_checkany(state: *mut LuaState, arg: c_int);
    pub fn luaL_newmetatable(state: *mut LuaState, tname: *const c_char) -> c_int;
    pub fn luaL_setmetatable(state: *mut LuaState, tname: *const c_char);
    pub fn luaL_testudata(state: *mut LuaState, ud: c_int, tname: *const c_char) -> *mut c_void;
    pub fn luaL_checkudata(state: *mut LuaState, ud: c_int, tname: *const c_char) -> *mut c_void;
    pub fn luaL_where(state: *mut LuaState, lvl: c_int);
    pub fn luaL_ref(state: *mut LuaState, t: c_int) -> c_int;
    pub fn luaL_unref(state: *mut LuaState, t: c_int, r: c_int);
    pub fn luaL_loadfilex(
        state: *mut LuaState,
        filename: *const c_char,
        mode: *const c_char,
    ) -> c_int;
    pub fn luaL_loadbufferx(
        state: *mut LuaState,
        buff: *const c_char,
        sz: usize,
        name: *const c_char,
        mode: *const c_char,
    ) -> c_int;
    pub fn luaL_loadstring(state: *mut LuaState, s: *const c_char) -> c_int;
    pub fn luaL_newstate() -> *mut LuaState;
    pub fn luaL_len(state: *mut LuaState, idx: c_int) -> LuaInteger;
    pub fn luaL_setfuncs(state: *mut LuaState, l: *const LuaLReg, nup: c_int);
    pub fn luaL_getsubtable(state: *mut LuaState, idx: c_int, fname: *const c_char) -> c_int;
    pub fn luaL_traceback(
        state: *mut LuaState,
        l1: *mut LuaState,
        msg: *const c_char,
        level: c_int,
    );
    pub fn luaL_requiref(
        state: *mut LuaState,
        modname: *const c_char,
        openf: LuaCFunction,
        glb: c_int,
    );
}

#[cfg(not(windows))]
unsafe extern "C" {
    // state manipulation
    pub fn lua_newstate(f: LuaAlloc, ud: *mut c_void, seed: c_uint) -> *mut LuaState;
    pub fn lua_close(state: *mut LuaState);
    pub fn lua_newthread(state: *mut LuaState) -> *mut LuaState;
    pub fn lua_closethread(state: *mut LuaState, from: *mut LuaState) -> c_int;

    // basic stack manipulation
    pub fn lua_absindex(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_gettop(state: *mut LuaState) -> c_int;
    pub fn lua_settop(state: *mut LuaState, idx: c_int);
    pub fn lua_pushvalue(state: *mut LuaState, idx: c_int);
    pub fn lua_rotate(state: *mut LuaState, idx: c_int, n: c_int);
    pub fn lua_copy(state: *mut LuaState, fromidx: c_int, toidx: c_int);
    pub fn lua_checkstack(state: *mut LuaState, n: c_int) -> c_int;
    pub fn lua_xmove(from: *mut LuaState, to: *mut LuaState, n: c_int);

    // access functions (stack -> C)
    pub fn lua_isnumber(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_isstring(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_iscfunction(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_isinteger(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_isuserdata(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_type(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_typename(state: *mut LuaState, tp: c_int) -> *const c_char;

    pub fn lua_tonumberx(state: *mut LuaState, idx: c_int, isnum: *mut c_int) -> LuaNumber;
    pub fn lua_tointegerx(state: *mut LuaState, idx: c_int, isnum: *mut c_int) -> LuaInteger;
    pub fn lua_toboolean(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_tolstring(state: *mut LuaState, idx: c_int, len: *mut usize) -> *const c_char;
    pub fn lua_rawlen(state: *mut LuaState, idx: c_int) -> LuaUnsigned;
    pub fn lua_tocfunction(state: *mut LuaState, idx: c_int) -> LuaCFunction;
    pub fn lua_touserdata(state: *mut LuaState, idx: c_int) -> *mut c_void;
    pub fn lua_tothread(state: *mut LuaState, idx: c_int) -> *mut LuaState;
    pub fn lua_topointer(state: *mut LuaState, idx: c_int) -> *const c_void;

    // comparison
    pub fn lua_rawequal(state: *mut LuaState, idx1: c_int, idx2: c_int) -> c_int;
    pub fn lua_compare(state: *mut LuaState, idx1: c_int, idx2: c_int, op: c_int) -> c_int;

    // push functions (C -> stack)
    pub fn lua_pushnil(state: *mut LuaState);
    pub fn lua_pushnumber(state: *mut LuaState, n: LuaNumber);
    pub fn lua_pushinteger(state: *mut LuaState, n: LuaInteger);
    pub fn lua_pushlstring(state: *mut LuaState, s: *const c_char, len: usize) -> *const c_char;
    pub fn lua_pushstring(state: *mut LuaState, s: *const c_char) -> *const c_char;
    pub fn lua_pushcclosure(state: *mut LuaState, f: LuaCFunction, n: c_int);
    pub fn lua_pushboolean(state: *mut LuaState, b: c_int);
    pub fn lua_pushlightuserdata(state: *mut LuaState, p: *mut c_void);
    pub fn lua_pushthread(state: *mut LuaState) -> c_int;

    // get functions (Lua -> stack)
    pub fn lua_getglobal(state: *mut LuaState, name: *const c_char) -> c_int;
    pub fn lua_gettable(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_getfield(state: *mut LuaState, idx: c_int, k: *const c_char) -> c_int;
    pub fn lua_geti(state: *mut LuaState, idx: c_int, n: LuaInteger) -> c_int;
    pub fn lua_rawget(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_rawgeti(state: *mut LuaState, idx: c_int, n: LuaInteger) -> c_int;
    pub fn lua_rawgetp(state: *mut LuaState, idx: c_int, p: *const c_void) -> c_int;

    pub fn lua_createtable(state: *mut LuaState, narr: c_int, nrec: c_int);
    pub fn lua_newuserdatauv(state: *mut LuaState, sz: usize, nuvalue: c_int) -> *mut c_void;
    pub fn lua_getmetatable(state: *mut LuaState, objindex: c_int) -> c_int;
    pub fn lua_getiuservalue(state: *mut LuaState, idx: c_int, n: c_int) -> c_int;

    // set functions (stack -> Lua)
    pub fn lua_setglobal(state: *mut LuaState, name: *const c_char);
    pub fn lua_settable(state: *mut LuaState, idx: c_int);
    pub fn lua_setfield(state: *mut LuaState, idx: c_int, k: *const c_char);
    pub fn lua_seti(state: *mut LuaState, idx: c_int, n: LuaInteger);
    pub fn lua_rawset(state: *mut LuaState, idx: c_int);
    pub fn lua_rawseti(state: *mut LuaState, idx: c_int, n: LuaInteger);
    pub fn lua_rawsetp(state: *mut LuaState, idx: c_int, p: *const c_void);
    pub fn lua_setmetatable(state: *mut LuaState, objindex: c_int) -> c_int;
    pub fn lua_setiuservalue(state: *mut LuaState, idx: c_int, n: c_int) -> c_int;

    // 'load' and 'call' functions
    pub fn lua_callk(
        state: *mut LuaState,
        nargs: c_int,
        nresults: c_int,
        ctx: LuaKContext,
        k: Option<LuaKFunction>,
    );
    pub fn lua_pcallk(
        state: *mut LuaState,
        nargs: c_int,
        nresults: c_int,
        errfunc: c_int,
        ctx: LuaKContext,
        k: Option<LuaKFunction>,
    ) -> c_int;
    pub fn lua_load(
        state: *mut LuaState,
        reader: LuaReader,
        dt: *mut c_void,
        chunkname: *const c_char,
        mode: *const c_char,
    ) -> c_int;
    pub fn lua_dump(
        state: *mut LuaState,
        writer: LuaWriter,
        data: *mut c_void,
        strip: c_int,
    ) -> c_int;

    // coroutine functions
    pub fn lua_yieldk(
        state: *mut LuaState,
        nresults: c_int,
        ctx: LuaKContext,
        k: Option<LuaKFunction>,
    ) -> c_int;
    pub fn lua_resume(
        state: *mut LuaState,
        from: *mut LuaState,
        narg: c_int,
        nres: *mut c_int,
    ) -> c_int;
    pub fn lua_status(state: *mut LuaState) -> c_int;
    pub fn lua_isyieldable(state: *mut LuaState) -> c_int;

    // miscellaneous functions
    pub fn lua_error(state: *mut LuaState) -> c_int;
    pub fn lua_next(state: *mut LuaState, idx: c_int) -> c_int;
    pub fn lua_concat(state: *mut LuaState, n: c_int);
    pub fn lua_len(state: *mut LuaState, idx: c_int);
    pub fn lua_stringtonumber(state: *mut LuaState, s: *const c_char) -> usize;
    pub fn lua_getallocf(state: *mut LuaState, ud: *mut *mut c_void) -> LuaAlloc;
    pub fn lua_setallocf(state: *mut LuaState, f: LuaAlloc, ud: *mut c_void);
    pub fn lua_toclose(state: *mut LuaState, idx: c_int);
    pub fn lua_closeslot(state: *mut LuaState, idx: c_int);

    // lauxlib
    pub fn luaL_checkversion_(state: *mut LuaState, ver: LuaNumber, sz: usize);
    pub fn luaL_getmetafield(state: *mut LuaState, obj: c_int, e: *const c_char) -> c_int;
    pub fn luaL_callmeta(state: *mut LuaState, obj: c_int, e: *const c_char) -> c_int;
    pub fn luaL_tolstring(state: *mut LuaState, idx: c_int, len: *mut usize) -> *const c_char;
    pub fn luaL_argerror(state: *mut LuaState, arg: c_int, extramsg: *const c_char) -> c_int;
    pub fn luaL_typeerror(state: *mut LuaState, arg: c_int, tname: *const c_char) -> c_int;
    pub fn luaL_checklstring(state: *mut LuaState, arg: c_int, len: *mut usize) -> *const c_char;
    pub fn luaL_optlstring(
        state: *mut LuaState,
        arg: c_int,
        def: *const c_char,
        len: *mut usize,
    ) -> *const c_char;
    pub fn luaL_checknumber(state: *mut LuaState, arg: c_int) -> LuaNumber;
    pub fn luaL_optnumber(state: *mut LuaState, arg: c_int, def: LuaNumber) -> LuaNumber;
    pub fn luaL_checkinteger(state: *mut LuaState, arg: c_int) -> LuaInteger;
    pub fn luaL_optinteger(state: *mut LuaState, arg: c_int, def: LuaInteger) -> LuaInteger;
    pub fn luaL_checkstack(state: *mut LuaState, sz: c_int, msg: *const c_char);
    pub fn luaL_checktype(state: *mut LuaState, arg: c_int, t: c_int);
    pub fn luaL_checkany(state: *mut LuaState, arg: c_int);
    pub fn luaL_newmetatable(state: *mut LuaState, tname: *const c_char) -> c_int;
    pub fn luaL_setmetatable(state: *mut LuaState, tname: *const c_char);
    pub fn luaL_testudata(state: *mut LuaState, ud: c_int, tname: *const c_char) -> *mut c_void;
    pub fn luaL_checkudata(state: *mut LuaState, ud: c_int, tname: *const c_char) -> *mut c_void;
    pub fn luaL_where(state: *mut LuaState, lvl: c_int);
    pub fn luaL_ref(state: *mut LuaState, t: c_int) -> c_int;
    pub fn luaL_unref(state: *mut LuaState, t: c_int, r: c_int);
    pub fn luaL_loadfilex(
        state: *mut LuaState,
        filename: *const c_char,
        mode: *const c_char,
    ) -> c_int;
    pub fn luaL_loadbufferx(
        state: *mut LuaState,
        buff: *const c_char,
        sz: usize,
        name: *const c_char,
        mode: *const c_char,
    ) -> c_int;
    pub fn luaL_loadstring(state: *mut LuaState, s: *const c_char) -> c_int;
    pub fn luaL_newstate() -> *mut LuaState;
    pub fn luaL_len(state: *mut LuaState, idx: c_int) -> LuaInteger;
    pub fn luaL_setfuncs(state: *mut LuaState, l: *const LuaLReg, nup: c_int);
    pub fn luaL_getsubtable(state: *mut LuaState, idx: c_int, fname: *const c_char) -> c_int;
    pub fn luaL_traceback(
        state: *mut LuaState,
        l1: *mut LuaState,
        msg: *const c_char,
        level: c_int,
    );
    pub fn luaL_requiref(
        state: *mut LuaState,
        modname: *const c_char,
        openf: LuaCFunction,
        glb: c_int,
    );
}
