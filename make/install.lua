local platform = ...
local fs = require 'bee.filesystem'
local sp = require 'bee.subprocess'

local CWD = fs.current_path()
local output = CWD / 'server' / 'bin'
local bindir = CWD / 'build' / platform / 'bin'
local exe = platform == 'msvc' and ".exe" or ""
local dll = platform == 'msvc' and ".dll" or ".so"

fs.create_directories(output)
fs.copy_file(bindir / 'lni'..dll, output / 'lni'..dll, true)
fs.copy_file(bindir / 'lpeglabel'..dll, output / 'lpeglabel'..dll, true)
fs.copy_file(bindir / 'bee'..dll, output / 'bee'..dll, true)
fs.copy_file(bindir / 'lua'..exe, output / 'lua-language-server'..exe, true)

if platform == 'msvc' then
    fs.copy_file(bindir / 'lua54'..dll, output / 'lua54'..dll, true)
    require 'msvc'.copy_crtdll('x64', output)

    local process = assert(sp.spawn {
        bindir / 'rcedit.exe',
        output / 'lua-language-server.exe',
        '--set-icon',
        CWD / 'images' / 'icon.ico'
    })
    assert(process:wait())
end
