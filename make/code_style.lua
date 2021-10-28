local lm = require "luamake"

lm:source_set 'luaParser' {
    rootdir = '../3rd/EmmyLuaCodeStyle',
    includes = "include",
    sources = "LuaParser/src/*.cpp",
    defines = {
        'MAXRECLEVEL=1000',
    },
}

lm:source_set 'codeService' {
    rootdir = '../3rd/EmmyLuaCodeStyle',
    includes = "include",
    sources = {
        "CodeService/src/*.cpp",
        "CodeService/src/FormatElement/*.cpp"
    },
    defines = {
        'MAXRECLEVEL=1000',
    },
}

lm:static_library 'codeFormatLib' {
    deps = {"codeService", "luaParser"},
    rootdir = '../3rd/EmmyLuaCodeStyle',
    includes = {
        "include",
        "../bee.lua/3rd/lua"
    },
    sources = "CodeFormatLib/src/*.cpp",
    defines = {
        'MAXRECLEVEL=1000',
    },
}
