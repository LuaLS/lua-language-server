local lm = require 'luamake'

lm.bindir = "bin"
lm.c = lm.compiler == 'msvc' and 'c89' or 'c11'
lm.cxx = 'c++17'

if lm.sanitize then
    lm.mode = "debug"
    lm.flags = "-fsanitize=address"
    lm.gcc = {
        ldflags = "-fsanitize=address"
    }
    lm.clang = {
        ldflags = "-fsanitize=address"
    }
end

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

lm:rule "runtest" {
    lm.bindir .. "/lua-language-server" .. exe, "$in",
    description = "Run test: $in.",
    pool = "console",
}

lm:build "bee-test" {
    rule = "runtest",
    deps = { "all" },
    input = "3rd/bee.lua/test/test.lua",
}

lm:build 'unit-test' {
    rule = "runtest",
    deps = { "bee-test", "all" },
    input = "test.lua",
}

lm:default {
    "unit-test",
}
