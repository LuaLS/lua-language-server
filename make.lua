local lm = require 'luamake'

lm:lua_library 'lni' {
    sources = '3rd/lni/src/*.cpp'
}

lm:lua_library 'lpeglabel' {
    sources = '3rd/lpeglabel/*.c'
}

lm:executable 'rcedit' {
    sources = '3rd/rcedit/src/*.cc',
    defines = {
        '_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING'
    },
    flags = {
        '/wd4477',
        '/wd4244',
        '/wd4267',
    }
}

lm:build 'bee' {
    '$luamake', '-C', '3rd/bee.lua'
}

lm:build 'install' {
    '$luamake', 'lua', 'make/install.lua',
    deps = {
        'lni',
        'lpeglabel',
        'bee',
        'rcedit'
    }
}
