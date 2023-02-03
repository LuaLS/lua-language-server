local lm = require 'luamake'

lm.c = lm.compiler == 'msvc' and 'c89' or 'c11'
lm.cxx = 'c++17'

lm:source_set 'code_format' {
    rootdir = '../3rd/EmmyLuaCodeStyle',
    includes = {
        "include",
        "../bee.lua/3rd/lua",
        "3rd/wildcards/include"
    },
    sources = {
        -- codeFormatLib
        "CodeFormatLib/src/*.cpp",
        -- LuaParser
        "LuaParser/src/**.cpp",
        -- Util
        "Util/src/StringUtil.cpp",
        "Util/src/Utf8.cpp",
        "Util/src/SymSpell/*.cpp",
        --CodeService
        "CodeService/src/**.cpp",
    },
    windows = {
        -- 不要开哦
        -- flasg = "/W3 /WX"
    },
    macos = {
        flags = "-Wall -Werror",
    },
    linux = {
        flags = "-Wall -Werror"
    }
}
