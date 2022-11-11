name    = 'Defold'
files   = {'game.project', '*%.script', '*%.gui_script'}
configs = {
    {
        key    = 'Lua.runtime.version',
        action = 'set',
        value  = 'Lua 5.1',
    },
    {
        key    = 'Lua.workspace.library',
        action = 'set',
        value  = {".internal"},
    },
    {
        key    = 'Lua.workspace.ignoreDir',
        action = 'set',
        value  = {".internal"},
    },
    {
        key    = 'Lua.diagnostics.globals',
        action = 'set',
        value  = {
            "on_input",
            "on_message",
            "init",
            "update",
            "final"
        },
    },
    {
        key    = 'files.associations',
        action = 'set',
        value  = {
            ["*.script"] = "lua",
            ["*.gui_script"] = "lua",
            ["*.render_script"] = "lua",
            ["*.editor_script"] = "lua"
        }
    },
}
