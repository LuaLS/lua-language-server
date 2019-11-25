local script = ...

local function findExePath()
    local n = 0
    while arg[n-1] do
        n = n - 1
    end
    return arg[n]
end

local exePath = findExePath()
local exeDir  = exePath:gsub('[^/\\]-$', '')
local dll     = exePath:sub(-4) == '.exe' and '.dll' or '.so'
package.cpath = exeDir .. '?' .. dll
if not package.loadlib('bee'..dll, 'luaopen_bee_platform') then
    error([[It doesn't seem to support your OS, please let me know at https://github.com/sumneko/lua-language-server/issues]])
end

local fs = require 'bee.filesystem'
local rootPath = fs.path(exePath):parent_path():parent_path():remove_filename():string()
if dll == '.dll' then
    rootPath = rootPath:gsub('/', '\\')
    package.path  = rootPath .. script .. '\\?.lua'
          .. ';' .. rootPath .. script .. '\\?\\init.lua'
else
    rootPath = rootPath:gsub('\\', '/')
    package.path  = rootPath .. script .. '/?.lua'
          .. ';' .. rootPath .. script .. '/?/init.lua'
end
