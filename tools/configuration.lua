local json     = require 'json'
local template = require 'config.template'
local util     = require 'utility'

local function getType(temp)
    if temp.name == 'Boolean' then
        return 'boolean'
    end
    if temp.name == 'String' then
        return 'string'
    end
    if temp.name == 'Integer' then
        return 'integer'
    end
    if temp.name == 'Nil' then
        return 'null'
    end
    if temp.name == 'Array' then
        return 'array'
    end
    if temp.name == 'Hash' then
        return 'object'
    end
    if temp.name == 'Or' then
        return { getType(temp.subs[1]), getType(temp.subs[2]) }
    end
    error('Unknown type: ' .. temp.name)
end

local function getDefault(temp)
    local default = temp.default
    if default == nil and temp.hasDefault then
        default = json.null
    end
    if  type(default) == 'table'
    and not next(default)
    and getType(temp) == 'object' then
        default = json.createEmptyObject()
    end
    return default
end

local function getEnum(temp)
    return temp.enums
end

local function getEnumDesc(name, temp)
    if not temp.enums then
        return nil
    end
    local descs = {}

    for _, enum in ipairs(temp.enums) do
        descs[#descs+1] = name:gsub('^Lua', '%%config') .. '.' .. enum .. '%'
    end

    return descs
end

local function insertArray(conf, temp)
    conf.items = {
        type = getType(temp.sub),
        enum = getEnum(temp.sub),
    }
end

local function insertHash(name, conf, temp)
    conf.title = name:match '[^%.]+$'
    conf.additionalProperties = false

    if type(conf.default) == 'table' and next(conf.default) then
        local default = conf.default
        conf.default = nil
        conf.properties = {}
        local descHead = name:gsub('^Lua', '%%config')
        if util.stringStartWith(descHead, '%config.diagnostics') then
            descHead = '%config.diagnostics'
        end
        for key, value in pairs(default) do
            conf.properties[key] = {
                type    = getType( temp.subvalue),
                default = value,
                enum    = getEnum( temp.subvalue),
                description = descHead .. '.' .. key .. '%',
            }
        end
    else
        conf.patternProperties = {
            ['.*'] = {
                type    = getType( temp.subvalue),
                default = getDefault( temp.subvalue),
                enum    = getEnum( temp.subvalue),
            }
        }
    end
end

local config = {}

for name, temp in pairs(template) do
    if not util.stringStartWith(name, 'Lua.') then
        goto CONTINUE
    end
    config[name] = {
        scope   = 'resource',
        type    = getType(temp),
        default = getDefault(temp),
        enum    = getEnum(temp),

        markdownDescription      = name:gsub('^Lua', '%%config') .. '%',
        markdownEnumDescriptions = getEnumDesc(name, temp),
    }

    if temp.name == 'Array' then
        insertArray(config[name], temp)
    end

    if temp.name == 'Hash' then
        insertHash(name, config[name], temp)
    end

    ::CONTINUE::
end

return config
