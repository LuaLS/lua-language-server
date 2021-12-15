local lm       = require 'luamake'
local platform = require 'bee.platform'
local exe      = platform.OS == 'Windows' and ".exe" or ""

lm.bindir = "bin"

lm.EXE_DIR = ""

if platform.OS == 'macOS' then
    if lm.platform == "darwin-arm64" then
        lm.target = "arm64-apple-macos11"
    else
        lm.target = "x86_64-apple-macos10.12"
    end
end

if platform.OS == 'Windows' then
    if lm.platform == "win32-ia32" then
        lm.arch = "x86"
    else
        lm.arch = "x86_64"
    end
end

lm:import "3rd/bee.lua/make.lua"

lm:source_set 'lpeglabel' {
    rootdir = '3rd',
    includes = "bee.lua/3rd/lua",
    sources = "lpeglabel/*.c",
    defines = {
        'MAXRECLEVEL=1000',
    },
}

lm:executable "lua-language-server" {
    deps = {"lpeglabel", "source_bootstrap"},
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
    linux = {
        crt = "static",
    }
}

lm:copy "copy_bootstrap" {
    input = "make/bootstrap.lua",
    output = lm.bindir.."/main.lua",
}

lm:build 'copy_vcrt' {
    '$luamake', 'lua', 'make/copy_vcrt.lua', lm.bindir, lm.arch,
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

local function detectWindowsArch()
    if os.getenv "PROCESSOR_ARCHITECTURE" == "ARM64" then
        return "arm64"
    end
    if os.getenv "PROCESSOR_ARCHITECTURE" == "AMD64" or os.getenv "PROCESSOR_ARCHITEW6432" == "AMD64" then
        return "x64"
    end
    return "ia32"
end

local function detectPosixArch()
    local f <close> = assert(io.popen("uname -m", 'r'))
    return f:read 'l':lower()
end

local function detectArch()
    if platform.OS == 'Windows' then
        return detectWindowsArch()
    end
    return detectPosixArch()
end

local function targetPlatformArch()
    if lm.platform == nil then
        return detectArch()
    end
    return lm.platform:match "^[^-]*-(.*)$"
end

local notest = platform.OS == 'macOS'
    and targetPlatformArch() == "arm64"
    and detectArch() == "x64"

if notest then
    lm:default {
        "all",
    }
    return
end

lm:build "bee-test" {
    lm.bindir.."/lua-language-server"..exe, "3rd/bee.lua/test/test.lua",
    pool = "console",
    deps = {
        "all",
    }
}

lm:build 'unit-test' {
    lm.bindir.."/lua-language-server"..exe, 'test.lua',
    pool = "console",
    deps = {
        "bee-test",
    }
}

lm:default {
    "bee-test",
    "unit-test",
}
