local lm       = require 'luamake'
local platform = require 'bee.platform'
local exe      = platform.OS == 'Windows' and ".exe" or ""

lm.bindir = "bin"

---@diagnostic disable-next-line: codestyle-check
lm.EXE_DIR = ""

if     platform.OS == 'macOS' then
    if     lm.platform == nil then
    elseif lm.platform == "darwin-arm64" then
        lm.target = "arm64-apple-macos11"
    elseif lm.platform == "darwin-x64" then
        lm.target = "x86_64-apple-macos10.12"
    else
        error "unknown platform"
    end
elseif platform.OS == 'Windows' then
    if     lm.platform == nil then
    elseif lm.platform == "win32-ia32" then
        lm.arch = "x86"
    elseif lm.platform == "win32-x64" then
        lm.arch = "x86_64"
    else
        error "unknown platform"
    end
elseif platform.OS == 'Linux' then
    if     lm.platform == nil then
    elseif lm.platform == "linux-x64" then
    elseif lm.platform == "linux-arm64" then
        lm.cc = 'aarch64-linux-gnu-gcc'
    else
        error "unknown platform"
    end
end

lm:import "3rd/bee.lua/make.lua"
--lm:import "make/code_format.lua"

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
        --"code_format",
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
    linux = {
        crt = "static",
    }
}

lm:copy "copy_bootstrap" {
    input = "make/bootstrap.lua",
    output = lm.bindir .. "/main.lua",
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

local notest = (platform.OS == 'macOS' or platform.OS == 'Linux')
    and targetPlatformArch() == "arm64"
    and detectArch() == "x86_64"

if notest then
    lm:default {
        "all",
    }
    return
end

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
