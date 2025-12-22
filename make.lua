local lm = require 'luamake'

lm.c = lm.compiler == 'msvc' and 'c89' or 'c11'
lm.cxx = 'c++17'
lm.lua = '55'

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

local includeCodeFormat = true

require "make.detect_platform"

lm:import "3rd/bee.lua/make.lua"
lm:import "make/code_format.lua"

lm:source_set 'lpeglabel' {
    rootdir = '3rd',
    includes = "bee.lua/3rd/lua55",
    sources = "lpeglabel/*.c",
    defines = {
        'MAXRECLEVEL=1000',
    },
    deps = "source_lua",
}

lm:executable "lua-language-server" {
    deps = {
        "source_bee",
        "source_lua",
        "lpeglabel",
        "source_bootstrap",
        includeCodeFormat and "code_format" or nil,
    },
    includes = {
        "3rd/bee.lua",
        "3rd/bee.lua/3rd/lua55",
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
        ldflags = { "-rdynamic" },
    }
}

local platform = require 'bee.platform'
local exe      = platform.os == 'windows' and ".exe" or ""

lm:copy "copy_lua-language-server" {
    inputs = "$bin/lua-language-server" .. exe,
    outputs = "bin/lua-language-server" .. exe,
}

lm:copy "copy_bootstrap" {
    inputs = "make/bootstrap.lua",
    outputs = "bin/main.lua",
}

lm:msvc_copydll 'copy_vcrt' {
    type = "vcrt",
    outputs = "bin",
}

lm:phony "all" {
    deps = {
        "lua-language-server",
        "copy_lua-language-server",
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

lm:rule "run-bee-test" {
    args = { "$bin/lua-language-server" .. exe, "$in" },
    description = "Run test: $in.",
    pool = "console",
}

lm:rule "run-unit-test" {
    args = { "bin/lua-language-server" .. exe, "$in" },
    description = "Run test: $in.",
    pool = "console",
}

lm:build "bee-test" {
    rule = "run-bee-test",
    deps = { "lua-language-server", "copy_script" },
    inputs = "3rd/bee.lua/test/test.lua",
}

lm:build 'unit-test' {
    rule = "run-unit-test",
    deps = { "bee-test", "all" },
    inputs = "test.lua",
}

lm:default {
    "unit-test",
}
