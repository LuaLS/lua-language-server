package.path = package.path .. ';3rd/love-api/?.lua'

local lua51 = require 'lua51'
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
    ['light userdata'] = 'lightuserdata',
    ['Variant']        = 'any',
}

local function trim(name)
    name = name:gsub('^%s+', '')
    name = name:gsub('%s+$', '')
    return name
end

---@param names string
local function getTypeName(names)
    local types = {}
    names = names:gsub('%sor%s', '|')
    for name in names:gmatch '[^|]+' do
        name = trim(name)
        types[#types+1] = knownTypes[name] or ('love.' .. name)
    end
    return table.concat(types, '|')
end

local function formatIndex(key)
    if key:match '^[%a_][%w_]*$' then
        return key
    end
    return ('[%q]'):format(key)
end

local function getOptional(param)
    if param.type == 'table' then
        if not param.table then
            return ''
        end
        for _, field in ipairs(param.table) do
            if field.default == nil then
                return ''
            end
        end
        return '?'
    else
        return (param.default ~= nil) and '?' or ''
    end
end

local buildType

local function buildDocTable(tbl)
    local fields = {}
    for _, field in ipairs(tbl) do
        if field.name ~= '...' then
            fields[#fields+1] = ('%s: %s'):format(formatIndex(field.name), buildType(field))
        end
    end
    return ('{%s}'):format(table.concat(fields, ', '))
end

function buildType(param)
    if param.table then
        return buildDocTable(param.table)
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

local function buildMD(desc)
    return desc:gsub('([\r\n])', '%1---')
               :gsub('%.  ', '.\n---\n---')
end

---@param desc any
---@param notes any
---@param wikiPage string?
---@return string
local function buildDescription(desc, notes, wikiPage)
    local lines = {}
    if desc then
        lines[#lines+1] = '---'
        lines[#lines+1] = '---' .. buildMD(desc)
        lines[#lines+1] = '---'
    end
    if notes then
        lines[#lines+1] = '---'
        lines[#lines+1] = '---### NOTE:'
        lines[#lines+1] = '---' .. buildMD(notes)
        lines[#lines+1] = '---'
    end
    if wikiPage then
        lines[#lines+1] = '---'
        lines[#lines+1] = ("---[Open in Browser](https://love2d.org/wiki/%s)"):format(wikiPage)
        lines[#lines+1] = '---'
    end
    return table.concat(lines, '\n')
end

local function buildDocFunc(variant, overload)
    local params  = {}
    local returns = {}
    if overload then
        params[1] = ('self: %s'):format(overload)
    end
    for _, param in ipairs(variant.arguments or {}) do
        if param.name == '...' then
            params[#params+1] = '...'
        else
            if param.name:find '^[\'"]' then
                params[#params+1] = ('%s%s: %s|%s'):format(param.name:sub(2, -2), getOptional(param), getTypeName(param.type), param.name)
            else
                params[#params+1] = ('%s%s: %s'):format(param.name, getOptional(param), getTypeName(param.type))
            end
        end
    end
    for _, rtn in ipairs(variant.returns or {}) do
        returns[#returns+1] = ('%s'):format(getTypeName(rtn.type))
    end
    return ('fun(%s)%s'):format(
        table.concat(params, ', '),
        #returns > 0 and (':' .. table.concat(returns, ', ')) or ''
    )
end

local function buildMultiDocFunc(tp)
    local cbs = {}
    for _, variant in ipairs(tp.variants) do
        cbs[#cbs+1] = buildDocFunc(variant)
    end
    return table.concat(cbs, '|')
end

local function buildFunction(func, node, typeName)
    local text = {}
    text[#text+1] = buildDescription(func.description, func.notes, node..func.name)
    for i = 2, #func.variants do
        local variant = func.variants[i]
        text[#text+1] = ('---@overload %s'):format(buildDocFunc(variant, typeName))
    end
    local params = {}
    for _, param in ipairs(func.variants[1].arguments or {}) do
        for paramName in param.name:gmatch '[%a_][%w_]*' do
            params[#params+1] = paramName
            text[#text+1] = ('---@param %s%s %s # %s'):format(
                paramName,
                getOptional(param),
                buildType(param),
                param.description
            )
        end

        if param.name == "..." then
            params[#params+1] = param.name
            text[#text+1] = ('---@vararg %s # %s'):format(
                buildType(param),
                param.description
            )
        end
    end
    for _, rtn in ipairs(func.variants[1].returns or {}) do
        for returnName in rtn.name:gmatch '[%a_][%w_]*' do
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
    local filePath = libraryPath / (class:gsub('%.', '/') .. '.lua')
    local text = {}

    text[#text+1] = '---@meta'
    text[#text+1] = ''
    if defs.version then
        text[#text+1] = ('-- version: %s'):format(defs.version)
    end
    text[#text+1] = buildDescription(defs.description, defs.notes, class)
    text[#text+1] = ('---@class %s'):format(class)
    text[#text+1] = ('%s = {}'):format(class)

    for _, func in ipairs(defs.functions or {}) do
        text[#text+1] = ''
        text[#text+1] = buildFunction(func, class .. '.')
    end

    for _, tp in ipairs(defs.types or {}) do
        local mark = {}
        text[#text+1] = ''
        text[#text+1] = buildDescription(tp.description, tp.notes, class)
        text[#text+1] = ('---@class %s%s'):format(getTypeName(tp.name), buildSuper(tp))
        text[#text+1] = ('local %s = {}'):format(tp.name)
        for _, func in ipairs(tp.functions or {}) do
            if not mark[func.name] then
                mark[func.name] = true
                text[#text+1] = ''
                text[#text+1] = buildFunction(func, tp.name .. ':', getTypeName(tp.name))
            end
        end
    end

    for _, cb in ipairs(defs.callbacks or {}) do
        text[#text+1] = ''
        text[#text+1] = buildDescription(cb.description, cb.notes)
        text[#text+1] = ('---@alias %s %s'):format(getTypeName(cb.name), buildMultiDocFunc(cb))
    end

    for _, enum in ipairs(defs.enums or {}) do
        text[#text+1] = ''
        text[#text+1] = buildDescription(enum.description, enum.notes, enum.name)
        text[#text+1] = ('---@alias %s'):format(getTypeName(enum.name))
        for _, constant in ipairs(enum.constants) do
            text[#text+1] = buildDescription(constant.description, constant.notes)
            text[#text+1] = ([[---| %q]]):format(constant.name)
        end
    end

    if defs.version then
        text[#text+1] = ''
        text[#text+1] = ('return %s'):format(class)
    end

    text[#text+1] = ''

    fs.create_directories(filePath:parent_path())
    fsu.saveFile(filePath, table.concat(text, '\n'))
end

buildFile('love', api)

for _, module in ipairs(api.modules) do
    buildFile('love.' .. module.name, module)
end
