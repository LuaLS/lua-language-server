local vm       = require 'vm'
local util     = require 'utility'
local getClass = require 'core.hover.class'

local function getKey(info)
    if not info.key then
        return 'any'
    end
    local ktype = info.key:sub(1, 2)
    if ktype == 's|' then
        return info.key:sub(3)
    end
    return ('[%s]'):format(info.key:sub(3))
end

local function getField(info)
    local type = vm.getType(info.source)
    local class = getClass(info.source)
    local literal = vm.getLiteral(info.source)
    local key = getKey(info)
    local label
    if literal then
        label = ('%s: %s = %s'):format(key, class or type, util.viewLiteral(literal))
    else
        label = ('%s: %s'):format(key, class or type)
    end
    return label, key
end

return function (source)
    local fields = {}
    local keys = {}
    vm.eachField(source, function (info)
        local field, key = getField(info)
        fields[#fields+1] = field
        keys[field] = key
    end)
    local fieldsBuf
    if #fields == 0 then
        fieldsBuf = '{}'
    else
        table.sort(fields, function (a, b)
            return keys[a] < keys[b]
        end)
        local lines = {}
        lines[#lines+1] = '{'
        for _, field in ipairs(fields) do
            lines[#lines+1] = '    ' .. field .. ','
        end
        lines[#lines+1] = '}'
        fieldsBuf = table.concat(lines, '\n')
    end
    return fieldsBuf
end
