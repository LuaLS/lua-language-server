local lm = require 'luamake'

lm:source_set 'code_format' {
    rootdir = '../3rd/EmmyLuaCodeStyle',
    includes = {
        "include",
        "../bee.lua/3rd/lua"
    },
    sources = {
        -- codeFormatLib
        "CodeFormatLib/src/*.cpp",
        -- LuaParser
        "LuaParser/src/*.cpp",
        "LuaParser/src/LuaAstNode/LuaAstNode.cpp",
        -- Util
        "Util/src/StringUtil.cpp",
        "Util/src/Utf8.cpp",
        --CodeService
        "CodeService/src/*.cpp",
        "CodeService/src/FormatElement/*.cpp",
        "CodeService/src/NameStyle/*.cpp"
    }
}
