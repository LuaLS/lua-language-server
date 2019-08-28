local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
if rootPath == '' then
    rootPath = './'
end

package.path  = rootPath .. 'src/?.lua'
      .. ';' .. rootPath .. 'src/?/init.lua'

if package.loadlib(rootPath .. '/bin-macos/bee.so', 'luaopen_bee_platform') then
    package.cpath = rootPath .. 'bin-macos/?.so'
elseif package.loadlib(rootPath .. '/bin-linux/bee.so', 'luaopen_bee_platform') then
    package.cpath = rootPath .. 'bin-linux/?.so'
elseif package.loadlib(rootPath .. '/bin-windows/bee.dll', 'luaopen_bee_platform') then
    package.cpath = rootPath .. 'bin-windows/?.dll'
end
