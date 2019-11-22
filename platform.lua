local script = ...
local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
if package.loadlib(rootPath .. 'bin/Windows/bee.dll', 'luaopen_bee_platform') then
    if rootPath == '' then
        rootPath = '.\\'
    else
        rootPath = rootPath:gsub('/', '\\')
    end
    package.cpath = rootPath .. 'bin\\Windows\\?.dll'
    package.path  = rootPath .. script .. '\\?.lua'
          .. ';' .. rootPath .. script .. '\\?\\init.lua'
elseif package.loadlib(rootPath .. 'bin/macOS/bee.so', 'luaopen_bee_platform') then
    if rootPath == '' then
        rootPath = './'
    end
    package.cpath = rootPath .. 'macOS/bin/?.so'
    package.path  = rootPath .. script .. '/?.lua'
          .. ';' .. rootPath .. script .. '/?/init.lua'
elseif package.loadlib(rootPath .. 'bin/Linux/bee.so', 'luaopen_bee_platform') then
    if rootPath == '' then
        rootPath = './'
    end
    package.cpath = rootPath .. 'bin/Linux/?.so'
    package.path  = rootPath .. script .. '/?.lua'
          .. ';' .. rootPath .. script .. '/?/init.lua'
else
    error([[It doesn't seem to support your OS, please let me know at https://github.com/sumneko/lua-language-server/issues]])
end
