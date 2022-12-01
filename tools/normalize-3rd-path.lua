local fs  = require 'bee.filesystem'
local fsu = require 'fs-utility'

local thirdPath = fs.path 'meta/3rd'

for dir in fs.pairs(thirdPath) do
    local libraryPath = dir / 'library'
    if fs.is_directory(libraryPath) then
        fsu.scanDirectory(libraryPath, function (fullPath)
            if fullPath:stem():string():find '%.' then
                local newPath = fullPath:parent_path() / (fullPath:stem():string():gsub('%.', '/') .. '.lua')
                fs.create_directories(newPath:parent_path())
                fs.rename(fullPath, newPath)
            end
        end)
    end
end
