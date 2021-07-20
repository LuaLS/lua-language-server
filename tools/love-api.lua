
package.path = package.path .. ';script/?.lua;tools/?.lua;3rd/love-api/?.lua'

local lua51 = require 'Lua51'
local api   = lua51.require 'love_api'
local fs    = require 'bee.filesystem'
local fsu   = require 'fs-utility'

local metaPath    = fs.path 'meta/3rd/love2d'
local libraryPath = metaPath / 'library'
fs.create_directories(libraryPath)

local function buildType(param)
    return param.type
end

local function buildFile(class, defs)
    local filePath = libraryPath / (class .. '.lua')
    local text = {}

    text[#text+1] = ('---@class %s'):format(class)
    text[#text+1] = ('%s = {}'):format(class)

    for _, func in ipairs(defs.functions or {}) do
        text[#text+1] = ''
        text[#text+1] = '---'
        text[#text+1] = ('---%s'):format(func.description:gsub('([\r\n])', '%1---'))
        text[#text+1] = '---'
        local params = {}
        for _, param in ipairs(func.variants[1].arguments or {}) do
            params[#params+1] = param.name
            text[#text+1] = ('---@param %s %s # %s'):format(
                param.name,
                buildType(param),
                param.description
            )
        end
        for _, rtn in ipairs(func.variants[1].returns or {}) do
            text[#text+1] = ('---@return %s %s # %s'):format(
                buildType(rtn),
                rtn.name,
                rtn.description
            )
        end
        text[#text+1] = ('function %s.%s(%s) end'):format(
            class,
            func.name,
            table.concat(params, ', ')
        )
    end

    text[#text+1] = ''

    fsu.saveFile(filePath, table.concat(text, '\n'))
end

buildFile('love', api)

for _, module in ipairs(api.modules) do
    buildFile('love.' .. module.name, module)
end
