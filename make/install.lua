local fs = require 'bee.filesystem'

local CWD = fs.current_path()

fs.create_directories(CWD / 'server' / 'bin')
fs.copy_file(CWD / 'build' / 'msvc' / 'bin' / 'lni.dll', CWD / 'server' / 'bin' / 'lni.dll', true)
fs.copy_file(CWD / 'build' / 'msvc' / 'bin' / 'lpeglabel.dll', CWD / 'server' / 'bin' / 'lpeglabel.dll', true)
fs.copy_file(CWD / '3rd' / 'bee.lua' / 'bin' / 'msvc_x86_release' / 'bee.dll', CWD / 'server' / 'bin' / 'bee.dll', true)
fs.copy_file(CWD / '3rd' / 'bee.lua' / 'bin' / 'msvc_x86_release' / 'lua54.dll', CWD / 'server' / 'bin' / 'lua54.dll', true)
fs.copy_file(CWD / '3rd' / 'bee.lua' / 'bin' / 'msvc_x86_release' / 'lua.exe', CWD / 'server' / 'bin' / 'lua-language-server.exe', true)

local msvc_crt = dofile 'make/msvc_crt.lua'
msvc_crt('x86', CWD / 'server' / 'bin')
