local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
if rootPath == '' then
    rootPath = './'
end
package.cpath = rootPath .. 'bin/?.so'
      .. ';' .. rootPath .. 'bin/?.dll'
package.path  = rootPath .. 'src/?.lua'
      .. ';' .. rootPath .. 'src/?/init.lua'

local fs = require 'bee.filesystem'
local subprocess = require 'bee.subprocess'
local platform = require 'bee.platform'
ROOT = fs.absolute(fs.path(rootPath))

local function runTest(root)
    local ext = platform.OS == 'Windows' and '.exe' or ''
    local exe = root / 'bin' / 'lua-language-server' .. ext
    local test = root / 'test' / 'main.lua'
    local lua = subprocess.spawn {
        exe,
        test,
        '-E',
        cwd = root,
        stdout = true,
        stderr = true,
    }
    for line in lua.stdout:lines 'l' do
        print(line)
    end
    lua:wait()
    local err = lua.stderr:read 'a'
    if err ~= '' then
        error(err)
    end
end

runTest(ROOT)
