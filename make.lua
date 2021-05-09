local lm       = require 'luamake'

lm:import("3rd/bee.lua/make.lua", {
    EXE_RESOURCE = "../../make/lua-language-server.rc"
})

lm:lua_dll 'lpeglabel' {
    rootdir = '3rd',
    sources = 'lpeglabel/*.c',
    visibility = 'default',
    defines = {
        'MAXRECLEVEL=1000',
    },
}

lm:build 'install' {
    '$luamake', 'lua', 'make/install.lua', lm.builddir,
    deps = {
        'lua',
        'lpeglabel',
        'bee',
        'bootstrap',
    }
}

local fs = require 'bee.filesystem'
local pf = require 'bee.platform'
local exe = pf.OS == 'Windows' and ".exe" or ""
lm:build 'unittest' {
    fs.path 'bin' / pf.OS / ('lua-language-server' .. exe), 'test.lua', '-E',
    pool = "console",
    deps = {
        'install',
        'test',
    }
}

lm:default 'unittest'
