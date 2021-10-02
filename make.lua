local lm       = require 'luamake'
local platform = require 'bee.platform'
local fs       = require 'bee.filesystem'
local exe      = platform.OS == 'Windows' and ".exe" or ""

lm.bindir = "bin/"..platform.OS

lm.EXE_NAME = "lua-language-server"
lm.EXE_DIR = lm.bindir
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
    '$luamake', 'lua', 'make/install.lua',
}

lm:copy "copy_bootstrap" {
    input = "make/bootstrap.lua",
    output = lm.bindir.."/main.lua",
}

lm:build "bee-test" {
    lm.bindir.."/"..lm.EXE_NAME..exe, "3rd/bee.lua/test/test.lua",
    pool = "console",
    deps = {
        lm.EXE_NAME,
        "copy_bootstrap"
    },
}

lm:build 'unit-test' {
    lm.bindir.."/"..lm.EXE_NAME..exe, 'test.lua',
    pool = "console",
    deps = {
        "bee-test",
        "lpeglabel",
    },
    windows = {
        deps = "lua54"
    }
}

lm:default {
    "bee-test",
    "unit-test",
    "install",
}
