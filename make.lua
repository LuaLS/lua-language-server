
local lm = require 'luamake'
local platform = require "bee.platform"

lm:import '3rd/bee.lua/make.lua'

lm.arch = 'x64'
lm.rootdir = '3rd/'

local lua = 'lua54'
local includes = nil
local lpeglabel_ldflags = '/EXPORT:luaopen_lpeglabel'
if lm.plat == 'macos' then
    lua = 'lua'
    includes = {'bee.lua/3rd/lua/src'}
    lpeglabel_ldflags = nil
elseif lm.plat == 'linux' then
    lua = 'lua'
    includes = {'bee.lua/3rd/lua/src'}
    lpeglabel_ldflags = nil
end

lm:shared_library 'lni' {
    deps = lua,
    sources = {
        'lni/src/main.cpp',
    },
    includes = includes,
    links = {
        platform.OS == "Linux" and "stdc++",
    },
}

lm:shared_library 'lpeglabel' {
    deps = lua,
    sources = 'lpeglabel/*.c',
    ldflags = lpeglabel_ldflags,
    includes = includes
}

local rcedit = nil
if lm.plat ~= 'macos' and lm.plat ~= 'linux' then
    rcedit = 'rcedit'

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
        rcedit
    }
}

lm:default {
    'install'
}
