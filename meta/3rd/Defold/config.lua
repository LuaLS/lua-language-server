name    = 'Defold'
files   = {'game.project'}
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
            ["*.project"] = "ini",
            ["*.script"] = "lua",
            ["*.gui_script"] = "lua",
            ["*.render_script"] = "lua",
            ["*.editor_script"] = "lua",
            ["*.fp"] = "glsl",
            ["*.vp"] = "glsl",
            ["*.go"] = "textproto",
            ["*.animationset"] = "textproto",
            ["*.atlas"] = "textproto",
            ["*.buffer"] = "json",
            ["*.camera"] = "textproto",
            ["*.collection"] = "textproto",
            ["*.collectionfactory"] = "textproto",
            ["*.collectionproxy"] = "textproto",
            ["*.collisionobject"] = "textproto",
            ["*.display_profiles"] = "textproto",
            ["*.factory"] = "textproto",
            ["*.gamepads"] = "textproto",
            ["*.gui"] = "textproto",
            ["*.input_binding"] = "textproto",
            ["*.label"] = "textproto",
            ["*.material"] = "textproto",
            ["*.mesh"] = "textproto",
            ["*.model"] = "textproto",
            ["*.particlefx"] = "textproto",
            ["*.render"] = "textproto",
            ["*.sound"] = "textproto",
            ["*.spinemodel"] = "textproto",
            ["*.spinescene"] = "textproto",
            ["*.sprite"] = "textproto",
            ["*.texture_profiles"] = "textproto",
            ["*.tilemap"] = "textproto",
            ["*.tilesource"] = "textproto",
            ["*.manifest"] = "textproto"
        }
    },
}
