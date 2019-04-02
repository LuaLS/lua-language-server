local lm = require 'luamake'

lm:import '3rd/bee.lua/make.lua'

lm.arch = 'x64'
lm.rootdir = '3rd/'

lm:shared_library 'lni' {
    deps = 'lua54',
    sources = {
        'lni/src/main.cpp',
    }
}

lm:shared_library 'lpeglabel' {
    deps = 'lua54',
    sources = 'lpeglabel/*.c',
    ldflags = '/EXPORT:luaopen_lpeglabel'
}

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

lm:build 'install' {
    '$luamake', 'lua', 'make/install.lua',
    deps = {
        'lua',
        'lni',
        'lpeglabel',
        'bee',
        'rcedit'
    }
}

lm:default {
    'install'
}
