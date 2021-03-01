local lm       = require 'luamake'
local platform = require 'bee.platform'

lm.arch = 'x64'

if lm.plat == "macos" then
    lm.flags = {
        "-mmacosx-version-min=10.13",
    }
end

lm:import("3rd/bee.lua/make.lua", {
    EXE_RESOURCE = "../../make/lua-language-server.rc"
})

lm.rootdir = '3rd/'

lm:lua_dll 'lpeglabel' {
    sources = 'lpeglabel/*.c',
    visibility = 'default',
    defines = {
        'MAXRECLEVEL=1000',
    },
}

lm:build 'install' {
    '$luamake', 'lua', 'make/install.lua', lm.plat,
    deps = {
        'lua',
        'lpeglabel',
        'bee',
        'bootstrap',
    }
}

lm:build 'unittest' {
    '$luamake', 'lua', 'make/unittest.lua', lm.plat,
    deps = {
        'install',
        'test',
    }
}

lm:default {
    'install',
    'test',
    'unittest',
}
