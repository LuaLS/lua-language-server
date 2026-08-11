//! High-level bindings to the Lua 5.5 C API for building extension modules.

pub mod ffi;

use ffi::*;
use std::ffi::CStr;
use std::os::raw::{c_char, c_int};

// ---------------------------------------------------------------------------
// stack
// ---------------------------------------------------------------------------

/// Returns the index of the top element of the stack.
pub unsafe fn get_top(state: *mut LuaState) -> c_int {
    unsafe { lua_gettop(state) }
}

/// Sets the stack top (`idx >= 0` pushes, `idx < 0` pops).
pub unsafe fn set_top(state: *mut LuaState, idx: c_int) {
    unsafe { lua_settop(state, idx) }
}

/// Pops `n` values from the stack.
pub unsafe fn pop(state: *mut LuaState, n: c_int) {
    unsafe { lua_settop(state, -n - 1) }
}

/// Pushes a copy of the element at `idx`.
pub unsafe fn push_value(state: *mut LuaState, idx: c_int) {
    unsafe { lua_pushvalue(state, idx) }
}

/// Converts a negative (relative) index to an absolute index.
pub unsafe fn abs_index(state: *mut LuaState, idx: c_int) -> c_int {
    unsafe { lua_absindex(state, idx) }
}

// ---------------------------------------------------------------------------
// push
// ---------------------------------------------------------------------------

pub unsafe fn push_nil(state: *mut LuaState) {
    unsafe { lua_pushnil(state) }
}

pub unsafe fn push_boolean(state: *mut LuaState, b: bool) {
    unsafe { lua_pushboolean(state, b as c_int) }
}

pub unsafe fn push_integer(state: *mut LuaState, n: LuaInteger) {
    unsafe { lua_pushinteger(state, n) }
}

pub unsafe fn push_number(state: *mut LuaState, n: LuaNumber) {
    unsafe { lua_pushnumber(state, n) }
}

/// Pushes a byte string (not NUL-terminated required).
pub unsafe fn push_lstring(state: *mut LuaState, bytes: &[u8]) {
    unsafe {
        lua_pushlstring(state, bytes.as_ptr() as *const c_char, bytes.len());
    }
}

/// Pushes a NUL-terminated string.
pub unsafe fn push_string(state: *mut LuaState, s: &CStr) {
    unsafe {
        lua_pushstring(state, s.as_ptr());
    }
}

/// Pushes a C function as a closure with `n` upvalues (already on the stack).
pub unsafe fn push_cclosure(state: *mut LuaState, f: LuaCFunction, n: c_int) {
    unsafe { lua_pushcclosure(state, f, n) }
}

// ---------------------------------------------------------------------------
// type / access
// ---------------------------------------------------------------------------

/// Returns the type of the element at `idx`, or [`LUA_TNONE`].
pub unsafe fn type_of(state: *mut LuaState, idx: c_int) -> c_int {
    unsafe { lua_type(state, idx) }
}

pub unsafe fn is_integer(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_isinteger(state, idx) != 0 }
}

pub unsafe fn is_number(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_isnumber(state, idx) != 0 }
}

pub unsafe fn is_string(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_isstring(state, idx) != 0 }
}

pub unsafe fn is_table(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_type(state, idx) == LUA_TTABLE }
}

pub unsafe fn is_function(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_type(state, idx) == LUA_TFUNCTION }
}

pub unsafe fn is_nil(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_type(state, idx) == LUA_TNIL }
}

pub unsafe fn is_userdata(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_type(state, idx) == LUA_TUSERDATA }
}

/// Converts the element at `idx` to an integer, if possible.
pub unsafe fn to_integer(state: *mut LuaState, idx: c_int) -> Option<LuaInteger> {
    let mut isnum = 0;
    let n = unsafe { lua_tointegerx(state, idx, &mut isnum) };
    if isnum != 0 { Some(n) } else { None }
}

/// Converts the element at `idx` to a number, if possible.
pub unsafe fn to_number(state: *mut LuaState, idx: c_int) -> Option<LuaNumber> {
    let mut isnum = 0;
    let n = unsafe { lua_tonumberx(state, idx, &mut isnum) };
    if isnum != 0 { Some(n) } else { None }
}

pub unsafe fn to_boolean(state: *mut LuaState, idx: c_int) -> bool {
    unsafe { lua_toboolean(state, idx) != 0 }
}

/// Returns the element at `idx` as a byte string, if it is a string.
pub unsafe fn to_bytes<'a>(state: *mut LuaState, idx: c_int) -> Option<&'a [u8]> {
    let mut len = 0usize;
    let ptr = unsafe { lua_tolstring(state, idx, &mut len) };
    if ptr.is_null() {
        None
    } else {
        Some(unsafe { std::slice::from_raw_parts(ptr as *const u8, len) })
    }
}

/// Returns the element at `idx` as a NUL-terminated string, if it is a string.
pub unsafe fn to_cstr<'a>(state: *mut LuaState, idx: c_int) -> Option<&'a CStr> {
    let mut len = 0usize;
    let ptr = unsafe { lua_tolstring(state, idx, &mut len) };
    if ptr.is_null() {
        None
    } else {
        Some(unsafe { CStr::from_ptr(ptr) })
    }
}

/// Returns the length of the element at `idx` (string or table).
pub unsafe fn raw_len(state: *mut LuaState, idx: c_int) -> LuaUnsigned {
    unsafe { lua_rawlen(state, idx) }
}

// ---------------------------------------------------------------------------
// checked arguments (raise Lua errors on failure)
// ---------------------------------------------------------------------------

pub unsafe fn check_integer(state: *mut LuaState, idx: c_int) -> LuaInteger {
    unsafe { luaL_checkinteger(state, idx) }
}

pub unsafe fn check_number(state: *mut LuaState, idx: c_int) -> LuaNumber {
    unsafe { luaL_checknumber(state, idx) }
}

pub unsafe fn opt_integer(state: *mut LuaState, idx: c_int, def: LuaInteger) -> LuaInteger {
    unsafe { luaL_optinteger(state, idx, def) }
}

pub unsafe fn opt_number(state: *mut LuaState, idx: c_int, def: LuaNumber) -> LuaNumber {
    unsafe { luaL_optnumber(state, idx, def) }
}

/// Checks that the element at `idx` is a string and returns it as bytes.
pub unsafe fn check_bytes<'a>(state: *mut LuaState, idx: c_int) -> &'a [u8] {
    let mut len = 0usize;
    let ptr = unsafe { luaL_checklstring(state, idx, &mut len) };
    debug_assert!(!ptr.is_null());
    unsafe { std::slice::from_raw_parts(ptr as *const u8, len) }
}

/// Checks that the element at `idx` is a string and returns it as [`CStr`].
pub unsafe fn check_cstr<'a>(state: *mut LuaState, idx: c_int) -> &'a CStr {
    let mut len = 0usize;
    let ptr = unsafe { luaL_checklstring(state, idx, &mut len) };
    debug_assert!(!ptr.is_null());
    unsafe { CStr::from_ptr(ptr) }
}

pub unsafe fn check_type(state: *mut LuaState, idx: c_int, t: c_int) {
    unsafe { luaL_checktype(state, idx, t) }
}

// ---------------------------------------------------------------------------
// table / globals
// ---------------------------------------------------------------------------

pub unsafe fn create_table(state: *mut LuaState, narr: c_int, nrec: c_int) {
    unsafe { lua_createtable(state, narr, nrec) }
}

/// Pushes the field `key` of the element at `idx` and returns its type.
pub unsafe fn get_field(state: *mut LuaState, idx: c_int, key: *const c_char) -> c_int {
    unsafe { lua_getfield(state, idx, key) }
}

/// Pops a value from the stack and stores it into the field `key` of `idx`.
pub unsafe fn set_field(state: *mut LuaState, idx: c_int, key: *const c_char) {
    unsafe { lua_setfield(state, idx, key) }
}

/// Pushes the value of the global `name` and returns its type.
pub unsafe fn get_global(state: *mut LuaState, name: *const c_char) -> c_int {
    unsafe { lua_getglobal(state, name) }
}

/// Pops a value from the stack and stores it into the global `name`.
pub unsafe fn set_global(state: *mut LuaState, name: *const c_char) {
    unsafe { lua_setglobal(state, name) }
}

/// Merges all the given NULL-terminated [`LuaLReg`] tables into a new module
/// table on the stack. Returns the number of results (1: the module table).
pub unsafe fn new_module(state: *mut LuaState, funcs: &[&[LuaLReg]]) -> c_int {
    unsafe {
        create_table(state, 0, 0);
        for f in funcs {
            luaL_setfuncs(state, f.as_ptr(), 0);
        }
    }
    1
}

/// Merges a NULL-terminated [`LuaLReg`] table into the table at the top.
pub unsafe fn set_funcs(state: *mut LuaState, funcs: &[LuaLReg]) {
    unsafe { luaL_setfuncs(state, funcs.as_ptr(), 0) }
}

/// Pushes a new submodule table built from a NULL-terminated [`LuaLReg`] table.
pub unsafe fn push_submodule(state: *mut LuaState, funcs: &[LuaLReg]) {
    unsafe {
        create_table(state, 0, 0);
        luaL_setfuncs(state, funcs.as_ptr(), 0);
    }
}

// ---------------------------------------------------------------------------
// metatables / userdata
// ---------------------------------------------------------------------------

/// Creates a new metatable named `tname` in the registry. Returns 1 if it is
/// new, 0 if it already existed (and pushes the existing one).
pub unsafe fn new_metatable(state: *mut LuaState, tname: *const c_char) -> c_int {
    unsafe { luaL_newmetatable(state, tname) }
}

/// Sets the metatable of the object at the top of the stack.
pub unsafe fn set_metatable(state: *mut LuaState, tname: *const c_char) {
    unsafe { luaL_setmetatable(state, tname) }
}

// ---------------------------------------------------------------------------
// references
// ---------------------------------------------------------------------------

/// Creates a reference to the value at the top of the stack (and pops it).
pub unsafe fn ref_registry(state: *mut LuaState) -> c_int {
    unsafe { luaL_ref(state, LUA_REGISTRYINDEX) }
}

/// Releases a registry reference created by [`ref_registry`].
pub unsafe fn unref_registry(state: *mut LuaState, reference: c_int) {
    unsafe { luaL_unref(state, LUA_REGISTRYINDEX, reference) }
}

// ---------------------------------------------------------------------------
// call
// ---------------------------------------------------------------------------

/// Calls the function (and its arguments) at the top of the stack.
pub unsafe fn call(state: *mut LuaState, nargs: c_int, nresults: c_int) {
    unsafe { lua_callk(state, nargs, nresults, 0, None) }
}

/// Protected call. Returns the error status ([`LUA_OK`] on success).
pub unsafe fn pcall(state: *mut LuaState, nargs: c_int, nresults: c_int, errfunc: c_int) -> c_int {
    unsafe { lua_pcallk(state, nargs, nresults, errfunc, 0, None) }
}

// ---------------------------------------------------------------------------
// error
// ---------------------------------------------------------------------------

/// Raises a Lua error with the given message (never returns).
pub unsafe fn raise_error(state: *mut LuaState, msg: &[u8]) -> ! {
    unsafe { push_lstring(state, msg) };
    unsafe { lua_error(state) };
    unreachable!()
}

/// Raises a "bad argument" Lua error (`extra` must be a NUL-terminated string).
pub unsafe fn arg_error(state: *mut LuaState, arg: c_int, extra: *const c_char) -> ! {
    unsafe { luaL_argerror(state, arg, extra) };
    unreachable!()
}
