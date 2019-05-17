local fs = require 'bee.filesystem'
local sp = require 'bee.subprocess'

local is_macos = package.cpath:sub(-3) == '.so'

local platform = require "bee.platform"

local CWD = fs.current_path()

local output = CWD / 'server' / 'bin'
local bindir = CWD / 'build' / 'msvc' / 'bin'

local lib_ext = ".dll"
local exc_ext = ".exe"

if is_macos then
    bindir = CWD / 'build' / 'macos' / 'bin'
    lib_ext = ".so"
    exc_ext = ""
end

if platform.OS == "Linux" then
    bindir = CWD / 'build' / 'linux' / 'bin'
    lib_ext = ".so"
    exc_ext = ""
end

fs.create_directories(output)
fs.copy_file(bindir / 'lni'..lib_ext, output / 'lni'..lib_ext, true)
fs.copy_file(bindir / 'lpeglabel'..lib_ext, output / 'lpeglabel'..lib_ext, true)
fs.copy_file(bindir / 'bee'..lib_ext, output / 'bee'..lib_ext, true)
fs.copy_file(bindir / 'lua'..exc_ext, output / 'lua-language-server'..exc_ext, true)

if not is_macos and platform.OS ~= "Linux" then
    fs.copy_file(bindir / 'lua54'..lib_ext, output / 'lua54'..lib_ext, true)
end

if not is_macos and platform.OS ~= "Linux" then
    local process = assert(sp.spawn {
        bindir / 'rcedit.exe',
        output / 'lua-language-server.exe',
        '--set-icon',
        CWD / 'images' / 'icon.ico'
    })
    assert(process:wait())

    local msvc_crt = dofile 'make/msvc_crt.lua'
    msvc_crt('x86', output)
end
