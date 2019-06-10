local lm = require 'luamake'
local platform = require "bee.platform"

lm:import '3rd/bee.lua/make.lua'

lm.arch = 'x64'
lm.rootdir = '3rd/'

lm:shared_library 'lni' {
    deps = platform.OS == "Windows" and "lua54" or "lua",
    sources = {
        'lni/src/main.cpp',
    },
    links = {
        platform.OS == "Linux" and "stdc++",
    },
}

lm:shared_library 'lpeglabel' {
    deps = platform.OS == "Windows" and "lua54" or "lua",
    sources = 'lpeglabel/*.c',
    undefs = "NDEBUG",
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
        'lni',
        'lpeglabel',
        'bee',
        platform.OS == "Windows" and "rcedit"
    }
}

lm:default {
    'install'
}
