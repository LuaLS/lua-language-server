local lm = require 'luamake'

lm.rootdir = '3rd/lni'
lm:lua_library 'lni' {
    sources = "src/*.cpp"
}

lm.rootdir = '3rd/lpeglabel'
lm:lua_library 'lpeglabel' {
    sources = "*.c"
}

lm:build 'bee' {
    '$luamake', '-C', '3rd/bee.lua'
}

lm:build 'install' {
    '$luamake', 'lua', 'make/install.lua',
    deps = {
        "lni",
        "lpeglabel",
        "bee",
    }
}
