local fs    = require 'bee.filesystem'
local fsu   = require 'fs-utility'

local api = dofile('3rd/lovr-api/api/init.lua')

local metaPath    = fs.path 'meta/3rd/lovr'
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
    if names == '*' then
        return 'any'
    end
    local types = {}
    names = names:gsub('%sor%s', '|')
    for name in names:gmatch '[^|]+' do
        name = trim(name)
        types[#types+1] = knownTypes[name] or ('lovr.' .. name)
    end
    return table.concat(types, '|')
end

local function formatIndex(key)
    if key:match '^[%a_][%w_]*$' then
        return key
    end
    return ('[%q]'):format(key)
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
    if param.type then
        return getTypeName(param.type)
    end
    return 'any'
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
    if desc then
        return ('---\n---%s\n---'):format(desc:gsub('([\r\n])', '%1---'))
    else
        return nil
    end
end

local function buildDocFunc(variant)
    local params  = {}
    local returns = {}
    for _, param in ipairs(variant.arguments or {}) do
        if param.name == '...' then
            params[#params+1] = '...'
        else
            if param.name:find '^[\'"]' then
                params[#params+1] = ('%s: %s|%q'):format(param.name:sub(2, -2), getTypeName(param.type), param.name)
            else
                params[#params+1] = ('%s: %s'):format(param.name, getTypeName(param.type))
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

local function buildFunction(func)
    local text = {}
    text[#text+1] = buildDescription(func.description)
    for i = 2, #func.variants do
        local variant = func.variants[i]
        text[#text+1] = ('---@overload %s'):format(buildDocFunc(variant))
    end
    local params = {}
    for _, param in ipairs(func.variants[1].arguments or {}) do
        for paramName in param.name:gmatch '[%a_][%w_]*' do
            params[#params+1] = paramName
            text[#text+1] = ('---@param %s%s %s # %s'):format(
                paramName,
                param.default == nil and '' or '?',
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
    text[#text+1] = ('function %s(%s) end'):format(
        func.key,
        table.concat(params, ', ')
    )
    return table.concat(text, '\n')
end

local function buildFile(defs)
    local class = defs.key
    local filePath = libraryPath / (class .. '.lua')
    local text = {}

    text[#text+1] = '---@meta'
    text[#text+1] = ''
    text[#text+1] = buildDescription(defs.description)
    text[#text+1] = ('---@class %s'):format(class)
    text[#text+1] = ('%s = {}'):format(class)

    for _, func in ipairs(defs.functions or {}) do
        text[#text+1] = ''
        text[#text+1] = buildFunction(func)
    end

    for _, obj in ipairs(defs.objects or {}) do
        local mark = {}
        text[#text+1] = ''
        text[#text+1] = buildDescription(obj.description)
        text[#text+1] = ('---@class %s%s'):format(getTypeName(obj.name), buildSuper(obj))
        text[#text+1] = ('local %s = {}'):format(obj.name)
        for _, func in ipairs(obj.methods or {}) do
            if not mark[func.name] then
                mark[func.name] = true
                text[#text+1] = ''
                text[#text+1] = buildFunction(func)
            end
        end
    end

    for _, enum in ipairs(defs.enums or {}) do
        text[#text+1] = ''
        text[#text+1] = buildDescription(enum.description)
        text[#text+1] = ('---@class %s'):format(getTypeName(enum.name))
        for _, constant in ipairs(enum.values) do
            text[#text+1] = buildDescription(constant.description)
            text[#text+1] = ('---@field %s integer'):format(formatIndex(constant.name))
        end
    end

    if defs.version then
        text[#text+1] = ''
        text[#text+1] = ('return %s'):format(class)
    end

    text[#text+1] = ''

    fsu.saveFile(filePath, table.concat(text, '\n'))
end

local function buildCallback(defs)
    local filePath = libraryPath / ('callback.lua')
    local text = {}

    text[#text+1] = '---@meta'

    for _, cb in ipairs(defs.callbacks or {}) do
        text[#text+1] = ''
        text[#text+1] = buildDescription(cb.description)
        text[#text+1] = ('---@type %s'):format(buildMultiDocFunc(cb))
        text[#text+1] = ('%s = nil'):format(cb.key)
    end

    text[#text+1] = ''

    fsu.saveFile(filePath, table.concat(text, '\n'))
end

buildCallback(api)

for _, module in ipairs(api.modules) do
    buildFile(module)
end
