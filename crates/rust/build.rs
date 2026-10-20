fn main() {
    // The Lua VM symbols (`lua_*`/`luaL_*`) are provided at load time by the
    // host process (the lua-language-server executable). macOS linkers reject
    // undefined symbols in a cdylib by default, so mark them to be resolved
    // lazily at load time. On Linux undefined symbols in shared libraries are
    // allowed by default, and on Windows the `raw-dylib` linkage handles them.
    #[cfg(any(
        target_os = "macos",
        target_os = "ios",
        target_os = "tvos",
        target_os = "watchos",
        target_os = "visionos"
    ))]
    {
        println!("cargo:rustc-cdylib-link-arg=-undefined");
        println!("cargo:rustc-cdylib-link-arg=dynamic_lookup");
    }
}
