local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
if rootPath == '' then
    rootPath = './'
end

package.path  = rootPath .. 'src/?.lua'
      .. ';' .. rootPath .. 'src/?/init.lua'

if package.loadlib(rootPath .. 'macOS/bin/bee.so', 'luaopen_bee_platform') then
    package.cpath = rootPath .. 'macOS/bin/?.so'
elseif package.loadlib(rootPath .. 'Linux/bin/bee.so', 'luaopen_bee_platform') then
    package.cpath = rootPath .. 'Linux/bin/?.so'
elseif package.loadlib(rootPath .. 'Windows/bin/bee.dll', 'luaopen_bee_platform') then
    package.cpath = rootPath .. 'Windows/bin/?.dll'
else
    error([[It doesn't seem to support your OS, please let me know at https://github.com/sumneko/lua-language-server/issues]])
end
