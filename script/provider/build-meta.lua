local util     = require 'utility'
local await    = require 'await'
local progress = require 'progress'
local lang     = require 'language'

local m = {}

---@class meta
---@field root    string
---@field classes meta.class[]

---@class meta.class
---@field name        string
---@field comment     string
---@field location    string
---@field namespace   string
---@field baseClass   string
---@field attribute   string
---@field integerface string[]
---@field fields      meta.field[]
---@field methods     meta.method[]

---@class meta.field
---@field name     string
---@field typeName string
---@field comment  string
---@field location string

---@class meta.method
---@field name           string
---@field comment        string
---@field location       string
---@field isStatic       boolean
---@field returnTypeName string
---@field params         {name: string, typeName: string}[]

---@param ... string
---@return string
local function mergeString(...)
    local buf = {}
    for i = 1, select('#', ...) do
        local str = select(i, ...)
        if str ~= '' then
            buf[#buf+1] = str
        end
    end
    return table.concat(buf, '.')
end

local function addComments(lines, comment)
    if comment == '' then
        return
    end
    lines[#lines+1] = '--'
    lines[#lines+1] = '--' .. comment:gsub('[\r\n]+$', ''):gsub('\n', '\n--')
    lines[#lines+1] = '--'
end

---@param lines string[]
---@param name string
---@param method meta.method
local function addMethod(lines, name, method)
    if not method.name:match '^[%a_][%w_]*$' then
        return
    end
    addComments(lines, method.comment)
    lines[#lines+1] = ('---@source %s'):format(method.location:gsub('#', ':'))
    local params = {}
    for _, param in ipairs(method.params) do
        lines[#lines+1] = ('---@param %s %s'):format(param.name, param.typeName)
        params[#params+1] = param.name
    end
    if  method.returnTypeName ~= ''
    and method.returnTypeName ~= 'Void' then
        lines[#lines+1] = ('---@return %s'):format(method.returnTypeName)
    end
    lines[#lines+1] = ('function %s%s%s(%s) end'):format(
        name,
        method.isStatic and ':' or '.',
        method.name,
        table.concat(params, ', ')
    )
    lines[#lines+1] = ''
end

---@param root string
---@param class meta.class
---@return string
local function buildText(root, class)
    local lines = {}

    addComments(lines, class.comment)
    lines[#lines+1] = ('---@source %s'):format(class.location:gsub('#', ':'))
    if class.baseClass == '' then
        lines[#lines+1] = ('---@class %s'):format(mergeString(class.namespace, class.name))
    else
        lines[#lines+1] = ('---@class %s: %s'):format(mergeString(class.namespace, class.name), class.baseClass)
    end

    for _, field in ipairs(class.fields) do
        addComments(lines, field.comment)
        lines[#lines+1] = ('---@source %s'):format(field.location:gsub('#', ':'))
        lines[#lines+1] = ('---@field %s %s'):format(field.name, field.typeName)
    end

    lines[#lines+1] = ('---@source %s'):format(class.location:gsub('#', ':'))
    local name = mergeString(root, class.namespace, class.name)
    lines[#lines+1] = ('%s = {}'):format(name)
    lines[#lines+1] = ''

    for _, method in ipairs(class.methods) do
        addMethod(lines, name, method)
    end

    return table.concat(lines, '\n')
end

local function buildRootText(api)
    local lines = {}

    lines[#lines+1] = ('---@class %s'):format(api.root)
    lines[#lines+1] = ('%s = {}'):format(api.root)
    lines[#lines+1] = ''
    return table.concat(lines, '\n')
end

---@async
---@param path string
---@param api meta
function m.build(path, api)

    local files = util.multiTable(2, function ()
        return { '---@meta' }
    end)

    files[api.root][#files[api.root]+1] = buildRootText(api)

    local proc <close> = progress.create(nil, lang.script.WINDOW_PROCESSING_BUILD_META, 0.5)
    for i, class in ipairs(api.classes) do
        local space = class.namespace ~= '' and class.namespace or api.root
        proc:setMessage(space)
        proc:setPercentage(i / #api.classes * 100)
        local text = buildText(api.root, class)
        files[space][#files[space]+1] = text
        await.delay()
    end

    for space, texts in pairs(files) do
        util.saveFile(path .. '/' .. space .. '.lua', table.concat(texts, '\n\n'))
    end
end

return m
