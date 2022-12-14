local lm = require 'luamake'

lm.notest = true
lm.bindir = "bin"
lm.c = lm.compiler == 'msvc' and 'c89' or 'c11'
lm.cxx = 'c++17'

---@diagnostic disable-next-line: codestyle-check
lm.EXE_DIR = ""

local includeCodeFormat = true

require "make.detect_platform"

lm:import "3rd/bee.lua"
lm:import "make/code_format.lua"

lm:source_set 'lpeglabel' {
    rootdir = '3rd',
    includes = "bee.lua/3rd/lua",
    sources = "lpeglabel/*.c",
    defines = {
        'MAXRECLEVEL=1000',
    },
}

lm:source_set 'luafilesystem' {
    rootdir = '3rd',
    includes = "luafilesystem/src",
    sources = "luafilesystem/src/*.c",
}

lm:executable "lua-language-server" {
    deps = {
        "lpeglabel",
        "source_bootstrap",
        includeCodeFormat and "code_format" or nil,
    },
    includes = {
        "3rd/bee.lua",
        "3rd/bee.lua/3rd/lua",
    },
    sources = "make/modules.cpp",
    windows = {
        sources = {
            "make/lua-language-server.rc",
        }
    },
    defines = {
        includeCodeFormat and 'CODE_FORMAT' or nil,
    },
    linux = {
        crt = "static",
    }
}

lm:copy "copy_bootstrap" {
    input = "make/bootstrap.lua",
    output = lm.bindir .. "/main.lua",
}

lm:msvc_copydll 'copy_vcrt' {
    type = "vcrt",
    output = lm.bindir,
}

lm:phony "all" {
    deps = {
        "lua-language-server",
        "copy_bootstrap",
    },
    windows = {
        deps = {
            "copy_vcrt"
        }
    }
}

if lm.notest then
    lm:default {
        "all",
    }
    return
end

local platform = require 'bee.platform'
local exe      = platform.OS == 'Windows' and ".exe" or ""

lm:build "bee-test" {
    lm.bindir .. "/lua-language-server" .. exe, "3rd/bee.lua/test/test.lua",
    pool = "console",
    deps = {
        "all",
    }
}

lm:build 'unit-test' {
    lm.bindir .. "/lua-language-server" .. exe, 'test.lua',
    pool = "console",
    deps = {
        "bee-test",
    }
}

lm:default {
    "bee-test",
    "unit-test",
}
