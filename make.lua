local lm       = require 'luamake'

lm.EXE = "lua"
lm.EXE_RESOURCE = "../../make/lua-language-server.rc"
lm:import "3rd/bee.lua/make.lua"

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
    }
}

lm:default 'unittest'
