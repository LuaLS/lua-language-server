local vm       = require 'vm'
local util     = require 'utility'
local guide    = require 'parser.guide'

local function getKey(src)
    local key = vm.getKeyName(src)
    if not key or #key <= 2 then
        if not src.index then
            return '[any]'
        end
        local class = vm.getClass(src.index)
        if class then
            return ('[%s]'):format(class)
        end
        local tp = vm.getInferType(src.index)
        if tp then
            return ('[%s]'):format(tp)
        end
        return '[any]'
    end
    local ktype = key:sub(1, 2)
    key = key:sub(3)
    if ktype == 's|' then
        if key:match '^[%a_][%w_]*$' then
            return key
        else
            return ('[%s]'):format(util.viewLiteral(key))
        end
    end
    return ('[%s]'):format(key)
end

local function getField(src)
    if src.parent.type == 'tableindex'
    or src.parent.type == 'setindex'
    or src.parent.type == 'getindex' then
        src = src.parent
    end
    local tp = vm.getInferType(src)
    local class = vm.getClass(src)
    local literal = vm.getInferLiteral(src)
    local key = getKey(src)
    if type(literal) == 'string' and #literal >= 50 then
        literal = literal:sub(1, 47) .. '...'
    end
    return key, class or tp, literal
end

local function buildAsHash(classes, literals)
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
            lines[#lines+1] = ('    %s: %s = %s,'):format(key, class, literal)
        else
            lines[#lines+1] = ('    %s: %s,'):format(key, class)
        end
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function buildAsConst(classes, literals)
    local keys = {}
    for k in pairs(classes) do
        keys[#keys+1] = k
    end
    table.sort(keys, function (a, b)
        return tonumber(literals[a]) < tonumber(literals[b])
    end)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local class   = classes[key]
        local literal = literals[key]
        if literal then
            lines[#lines+1] = ('    %s: %s = %s,'):format(key, class, literal)
        else
            lines[#lines+1] = ('    %s: %s,'):format(key, class)
        end
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function mergeLiteral(literals)
    local results = {}
    local mark = {}
    for _, value in ipairs(literals) do
        if not mark[value] then
            mark[value] = true
            results[#results+1] = value
        end
    end
    if #results == 0 then
        return nil
    end
    table.sort(results)
    return table.concat(results, '|')
end

return function (source)
    local literals = {}
    local classes = {}
    local intValue = true
    vm.eachField(source, function (src)
        local key, class, literal = getField(src)
        if not classes[key] then
            classes[key] = {}
        end
        if not literals[key] then
            literals[key] = {}
        end
        classes[key][#classes[key]+1] = class
        literals[key][#literals[key]+1] = literal
        if class ~= 'integer'
        or not literals[key]
        or #literals[key] ~= 1 then
            intValue = false
        end
    end)
    for key, class in pairs(classes) do
        classes[key] = guide.mergeTypes(class)
        literals[key] = mergeLiteral(literals[key])
    end
    if classes['[any]'] == 'any' then
        classes['[any]'] = nil
    end
    if not next(classes) then
        return '{}'
    end
    if intValue then
        return buildAsConst(classes, literals)
    else
        return buildAsHash(classes, literals)
    end
end
