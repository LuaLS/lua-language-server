local lm = require 'luamake'

lm.c = lm.compiler == 'msvc' and 'c89' or 'c11'
lm.cxx = 'c++17'

lm:source_set 'code_format' {
    rootdir = '../3rd/EmmyLuaCodeStyle',
    includes = {
        "Util/include",
        "CodeFormatCore/include",
        "LuaParser/include",
        "../bee.lua/3rd/lua",
        "3rd/wildcards/include"
    },
    sources = {
        -- codeFormatLib
        "CodeFormatLib/src/*.cpp",
        -- LuaParser
        "LuaParser/src/**/*.cpp",
        -- Util
        "Util/src/StringUtil.cpp",
        "Util/src/Utf8.cpp",
        "Util/src/SymSpell/*.cpp",
        "Util/src/InfoTree/*.cpp",
        --CodeService
        "CodeFormatCore/src/**/*.cpp",
    },
    windows = {
        flags = "/utf-8",
    },
    macos = {
        flags = "-Wall -Werror",
    },
    linux = {
        flags = "-Wall -Werror"
    }
}
