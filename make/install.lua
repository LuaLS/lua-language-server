local builddir = ...
local fs = require 'bee.filesystem'
local pf = require 'bee.platform'

local CWD = fs.current_path()
local output = CWD / 'bin' / pf.OS
local bindir = CWD / builddir / 'bin'
local exe = pf.OS == 'Windows' and ".exe" or ""
local dll = pf.OS == 'Windows' and ".dll" or ".so"
local OVERWRITE = fs.copy_options.overwrite_existing

fs.create_directories(output)
fs.copy_file(bindir / 'lpeglabel'..dll, output / 'lpeglabel'..dll, OVERWRITE)
fs.copy_file(bindir / 'bee'..dll,       output / 'bee'..dll, OVERWRITE)
fs.copy_file(bindir / 'lua'..exe,       output / 'lua-language-server'..exe, OVERWRITE)

if pf.OS == 'Windows' then
    fs.copy_file(bindir / 'lua54'..dll, output / 'lua54'..dll, OVERWRITE)
    require 'msvc'.copy_vcrt('x64', output)
end
