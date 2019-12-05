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
    return key, class or type, literal
end

local function mergeLiteral(a, b)
    if not a then
        return b
    end
    local view = util.viewLiteral(a)
    if not b then
        return { view, [view] = true }
    end
    if b[view] then
        return b
    end
    b[view] = true
    b[#b+1] = view
    return b
end

return function (source)
    local literals = {}
    local classes = {}
    vm.eachField(source, function (info)
        local key, class, literal = getField(info)
        classes[key] = vm.mergeTypeViews(class, classes[key])
        literals[key] = mergeLiteral(literal, literals[key])
    end)
    if not next(classes) then
        return '{}'
    end
    local keys = {}
    for k in pairs(classes) do
        keys[#keys+1] = k
    end
    table.sort(keys)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local class   = classes[key]
        local literal = literals[key]
        if literal then
            table.sort(literal)
            local view = table.concat(literal, '|')
            lines[#lines+1] = ('    %s: %s = %s,'):format(key, class, view)
        else
            lines[#lines+1] = ('    %s: %s,'):format(key, class)
        end
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end
