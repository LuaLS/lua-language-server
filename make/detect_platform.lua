local lm = require 'luamake'

local platform = require 'bee.platform'

if     platform.os == 'macos' then
    if     lm.platform == nil then
    elseif lm.platform == "darwin-arm64" then
        lm.target = "arm64-apple-macos11"
    elseif lm.platform == "darwin-x64" then
        lm.target = "x86_64-apple-macos10.12"
    else
        error "unknown platform"
    end
elseif platform.os == 'windows' then
    if     lm.platform == nil then
    elseif lm.platform == "win32-ia32" then
        lm.arch = "x86"
    elseif lm.platform == "win32-x64" then
        lm.arch = "x86_64"
    else
        error "unknown platform"
    end
elseif platform.os == 'linux' then
    if     lm.platform == nil then
    elseif lm.platform == "linux-x64" then
    elseif lm.platform == "linux-arm64" then
        lm.cc = 'aarch64-linux-gnu-gcc'
    else
        error "unknown platform"
    end
end

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

local ARCH <const> = {
    x86_64 = 'x64',
    i686 = 'ia32',
    arm64 = 'arm64',
}

local function detectArch()
    if platform.os == 'windows' then
        return detectWindowsArch()
    end
    local posixArch = detectPosixArch()
    return ARCH[posixArch]
end

local function targetPlatformArch()
    if lm.platform == nil then
        return detectArch()
    end
    return lm.platform:match "^[^-]*-(.*)$"
end

if not lm.notest then
    lm.notest = (platform.os ~= 'windows' and targetPlatformArch() ~= detectArch())
end
