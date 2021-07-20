
package.path = package.path .. ';script/?.lua;tools/?.lua;3rd/love-api/?.lua'

local lua51 = require 'Lua51'
local api   = lua51.require 'love_api'
local fs    = require 'bee.filesystem'
local fsu   = require 'fs-utility'

local metaPath    = fs.path 'meta/3rd/love2d'
local libraryPath = metaPath / 'library'
fs.create_directories(libraryPath)

local knownTypes = {
    ['nil']            = 'nil',
    ['any']            = 'any',
    ['boolean']        = 'boolean',
    ['number']         = 'number',
    ['integer']        = 'integer',
    ['string']         = 'string',
    ['table']          = 'table',
    ['function']       = 'function',
    ['userdata']       = 'userdata',
    ['lightuserdata']  = 'lightuserdata',
    ['thread']         = 'thread',
    ['cdata']          = 'ffi.cdata*',
    ['light userdata'] = 'lightuserdata'
}

local function getTypeName(name)
    if knownTypes[name] then
        return knownTypes[name]
    end
    return 'love.' .. name
end

local function buildType(param)
    if param.table then
        getTypeName(param.type)
    end
    return getTypeName(param.type)
end

local function buildSuper(tp)
    if not tp.supertypes then
        return ''
    end
    local parents = {}
    for _, parent in ipairs(tp.supertypes) do
        parents[#parents+1] = getTypeName(parent)
    end
    return (': %s'):format(table.concat(parents, ', '))
end

local function buildDescription(desc)
    return ('---%s'):format(desc:gsub('([\r\n])', '%1---'))
end

local function buildFunction(class, func, node)
    local text = {}
    text[#text+1] = '---'
    text[#text+1] = buildDescription(func.description)
    text[#text+1] = '---'
    local params = {}
    for _, param in ipairs(func.variants[1].arguments or {}) do
        for paramName in param.name:gmatch '[%a_][%w_]+' do
            params[#params+1] = paramName
            text[#text+1] = ('---@param %s %s # %s'):format(
                paramName,
                buildType(param),
                param.description
            )
        end
    end
    for _, rtn in ipairs(func.variants[1].returns or {}) do
        for returnName in rtn.name:gmatch '[%a_][%w_]+' do
            text[#text+1] = ('---@return %s %s # %s'):format(
                buildType(rtn),
                returnName,
                rtn.description
            )
        end
    end
    text[#text+1] = ('function %s%s(%s) end'):format(
        node,
        func.name,
        table.concat(params, ', ')
    )
    return table.concat(text, '\n')
end

local function buildFile(class, defs)
    local filePath = libraryPath / (class .. '.lua')
    local text = {}

    text[#text+1] = '---@meta'
    text[#text+1] = ''
    text[#text+1] = ('---@class %s'):format(class)
    text[#text+1] = ('%s = {}'):format(class)

    for _, func in ipairs(defs.functions or {}) do
        text[#text+1] = ''
        text[#text+1] = buildFunction(class, func, class .. '.')
    end

    for _, tp in ipairs(defs.types or {}) do
        text[#text+1] = ''
        text[#text+1] = ('---@class %s%s'):format(getTypeName(tp.name), buildSuper(tp))
        text[#text+1] = ('local %s = {}'):format(tp.name)
        for _, func in ipairs(tp.functions or {}) do
            text[#text+1] = ''
            text[#text+1] = buildFunction(class, func, tp.name .. ':')
        end
    end

    for _, tp in ipairs(defs.callbacks or {}) do
        text[#text+1] = ''
        text[#text+1] = ('---@type %s'):format(getTypeName(tp.name))
    end

    for _, enum in ipairs(defs.enums or {}) do
        text[#text+1] = ''
        text[#text+1] = ('---@class %s'):format(getTypeName(enum.name))
        for _, constant in ipairs(enum.constants) do
            text[#text+1] = ('---@field %s integer # %s'):format(constant.name, constant.description)
        end
    end

    text[#text+1] = ''

    fsu.saveFile(filePath, table.concat(text, '\n'))
end

buildFile('love', api)

for _, module in ipairs(api.modules) do
    buildFile('love.' .. module.name, module)
end
