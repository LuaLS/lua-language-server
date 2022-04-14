local lm = require 'luamake'

lm.c = lm.compiler == 'msvc' and 'c89' or 'c11'
lm.cxx = 'c++17'

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
    },
    windows = {
        -- 不要开哦
        -- flasg = "/W3 /WX"
    },
    macos = {
        flags = "-Wall -Werror",
        defines = "NOT_SUPPORT_FILE_SYSTEM"
    },
    linux = {
        defines = (function()
            if lm.platform == "linux-arm64" then
                return "NOT_SUPPORT_FILE_SYSTEM"
            end
        end)(),
        flags = "-Wall -Werror"
    }
}
