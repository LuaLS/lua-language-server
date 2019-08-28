local platform = ...
local fs = require 'bee.filesystem'
local sp = require 'bee.subprocess'
local exe = platform == 'msvc' and ".exe" or ""

error('测试')
local CWD = fs.current_path()

local process = assert(sp.spawn {
    CWD / 'server' / 'bin' / ('lua-language-server' .. exe),
    CWD / 'server' / 'test.lua',
    '-E',
    stdout = true,
    stderr = true,
})

for line in process.stdout:lines 'l' do
    print(line)
end
process:wait()
local err = process.stderr:read 'a'
if err ~= '' then
    error(err)
end
