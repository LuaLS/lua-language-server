local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
if rootPath == '' then
    rootPath = './'
end
package.cpath = rootPath .. 'bin/?.so'
      .. ';' .. rootPath .. 'bin/?.dll'
package.path  = rootPath .. 'src/?.lua'
      .. ';' .. rootPath .. 'src/?/init.lua'
error '测试'
local fs = require 'bee.filesystem'
local subprocess = require 'bee.subprocess'
ROOT = fs.absolute(fs.path(rootPath))

local function runTest(root)
    local is_macos = package.cpath:sub(-3) == '.so'
    local ext = is_macos and '' or '.exe'
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
