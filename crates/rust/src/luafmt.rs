//! Lua source formatting, backed by `emmylua_formatter`.
//!
//! Registered as the `rust.luafmt` submodule:
//! `local rust = require 'rust'; rust.luafmt.format(source[, path])`.

use crate::lua;
use crate::lua::ffi::{LuaLReg, LuaState};
use emmylua_formatter::{SourceText, reformat_lua_code_with_info, resolve_config_for_path};
use emmylua_parser::LuaLanguageLevel;
use std::os::raw::c_int;
use std::path::Path;

/// `luafmt.format(source[, path])` -> `ok, result`
///
/// Re-formats the given Lua source code. The optional `path` (a filesystem
/// path) is used to discover the nearest workspace config (`.luafmt.toml`),
/// which also provides the Lua syntax level.
///
/// On success returns `true` and the formatted text; on failure (source is not
/// valid utf-8, the config cannot be built, or the source has syntax errors)
/// returns `false` and an error message.
unsafe extern "C" fn l_format(state: *mut LuaState) -> c_int {
    let source = unsafe { lua::check_bytes(state, 1) };
    let text = match std::str::from_utf8(source) {
        Ok(text) => text,
        Err(_) => {
            unsafe {
                lua::push_boolean(state, false);
                lua::push_lstring(state, b"source is not valid utf-8".as_slice());
            }
            return 2;
        }
    };

    let source_path = unsafe { lua::to_bytes(state, 2) }
        .and_then(|bytes| std::str::from_utf8(bytes).ok())
        .filter(|path| !path.is_empty())
        .map(Path::new);

    let config = match resolve_config_for_path(source_path, None) {
        Ok(resolved) => resolved.config,
        Err(err) => {
            unsafe {
                lua::push_boolean(state, false);
                lua::push_lstring(state, err.to_string().as_bytes());
            }
            return 2;
        }
    };

    let level: LuaLanguageLevel = config.syntax.level.into();
    let result = reformat_lua_code_with_info(&SourceText { text, level }, &config);
    unsafe {
        if let Some(err) = result.syntax_error {
            lua::push_boolean(state, false);
            lua::push_lstring(state, err.message.as_bytes());
        } else {
            lua::push_boolean(state, true);
            lua::push_lstring(state, result.formatted.as_bytes());
        }
    }
    2
}

/// NULL-terminated Lua bindings for this submodule.
pub const FUNCS: [LuaLReg; 2] = [
    LuaLReg {
        name: c"format".as_ptr(),
        func: Some(l_format),
    },
    LuaLReg {
        name: std::ptr::null(),
        func: None,
    },
];
