local lm = require 'luamake'
local platform = require "bee.platform"

lm.arch = 'x64'

if lm.plat == "macos" then
    lm.flags = {
        "-mmacosx-version-min=10.13",
    }
end

lm:import '3rd/bee.lua/make.lua'

lm.rootdir = '3rd/'

lm:shared_library 'lpeglabel' {
    deps = platform.OS == "Windows" and "lua54" or "lua",
    sources = 'lpeglabel/*.c',
    visibility = 'default',
    defines = {
        'MAXRECLEVEL=1000',
    },
    ldflags = platform.OS == "Windows" and "/EXPORT:luaopen_lpeglabel",
}

if platform.OS == "Windows" then
    lm:executable 'rcedit' {
        sources = 'rcedit/src/*.cc',
        defines = {
            '_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING'
        },
        flags = {
            '/wd4477',
            '/wd4244',
            '/wd4267',
        }
    }
end

lm:build 'install' {
    '$luamake', 'lua', 'make/install.lua', lm.plat,
    deps = {
        'lua',
        'lpeglabel',
        'bee',
        'bootstrap',
        platform.OS == "Windows" and "rcedit"
    }
}

lm:build 'unittest' {
    '$luamake', 'lua', 'make/unittest.lua', lm.plat,
    deps = {
        'install',
    }
}

lm:default {
    'install',
    'test',
    'unittest',
}
