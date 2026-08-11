//! Rust native library for lua-language-server.
//!
//! Built as a `cdylib` and copied to `bin/` by `make.lua`. The crate exposes
//! a Lua C module entry point [`luaopen_rust`] so Lua can `require 'rust'`;
//! extension APIs register themselves through the [`lua`] module.
//!
//! The [`lua`] binding surface is a library meant to be consumed by extension
//! modules, so unused items are allowed here.

#![allow(dead_code)]

mod lua;
mod luafmt;

use std::os::raw::c_int;

pub use lua::ffi::{LuaInteger, LuaLReg, LuaNumber, LuaState};

/// `luaopen_rust(state)` - Lua module entry point.
///
/// # Safety
/// `state` must be a valid `lua_State*` of the running Lua VM.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn luaopen_rust(state: *mut LuaState) -> c_int {
    unsafe {
        lua::new_module(state, &[]);
        lua::push_submodule(state, &luafmt::FUNCS);
        lua::set_field(state, -2, c"luafmt".as_ptr());
    }
    1
}
