local path = arg[1]
if not path then
    print('No path!')
    return
end

print('Input path = ' .. path)

local root = arg[0] .. '\\..\\..'
package.path = package.path .. ';' .. root .. '\\src\\?.lua'
                            .. ';' .. root .. '\\src\\?\\init.lua'
                            .. ';' .. root .. '\\test\\?.lua'
                            .. ';' .. root .. '\\test\\?\\init.lua'

local fs     = require 'bee.filesystem'
local util   = require 'utility'
local parser = require 'parser'

local function scanFiles(fspath, callback)
    if fs.is_directory(fspath) then
        for subpath in fs.pairs(fspath) do
            scanFiles(subpath, callback)
        end
    else
        callback(fspath)
    end
end

print('Scanning files...')
local fileNames = {}
scanFiles(fs.path(path), function (fullPath)
    if fullPath:extension():string() ~= '.lua' then
        return
    end
    fileNames[#fileNames+1] = fullPath:string()
end)

print('Loading files...')
local files = {}
local size = 0
for _, fileName in ipairs(fileNames) do
    local file = util.loadFile(fileName)
    files[#files+1] = file
    size = size + #file
end

print(('Loaded %d files, total size = %.3f KB'):format(#files, size / 1000))
print('Start parsing...')
local clock = os.clock()
for _, file in ipairs(files) do
    local ast = parser.compile(file)
end
local passed = os.clock() - clock

print(('Total time = %.3f s, speed = %.3f MB/s'):format(passed, size / passed / 1000 / 1000))
