local vm       = require 'vm'
local util     = require 'utility'
local guide    = require 'parser.guide'
local config   = require 'config'
local lang     = require 'language'

local function getKey(src)
    if src.type == 'library' then
        if src.name:sub(1, 1) == '@' then
            return
        end
    end
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

local function getFieldFast(src)
    local value = guide.getObjectValue(src) or src
    if not value then
        return 'any'
    end
    if value.library then
        return value.type, util.viewLiteral(value.value)
    end
    if value.type == 'boolean' then
        return value.type, util.viewLiteral(value[1])
    end
    if value.type == 'number'
    or value.type == 'integer' then
        if math.tointeger(value[1]) then
            if config.config.runtime.version == 'Lua 5.3'
            or config.config.runtime.version == 'Lua 5.4' then
                return 'integer', util.viewLiteral(value[1])
            end
        end
        return value.type, util.viewLiteral(value[1])
    end
    if value.type == 'table'
    or value.type == 'function' then
        return value.type
    end
    if value.type == 'string' then
        local literal = value[1]
        if type(literal) == 'string' and #literal >= 50 then
            literal = literal:sub(1, 47) .. '...'
        end
        return value.type, util.viewLiteral(literal)
    end
end

local function getFieldFull(src)
    local tp      = vm.getInferType(src)
    --local class   = vm.getClass(src)
    local literal = vm.getInferLiteral(src)
    if type(literal) == 'string' and #literal >= 50 then
        literal = literal:sub(1, 47) .. '...'
    end
    return tp, literal
end

local function getField(src, timeUp, mark, key)
    if src.type == 'table'
    or src.type == 'function' then
        return nil
    end
    if src.parent then
        if src.parent.type == 'tableindex'
        or src.parent.type == 'setindex'
        or src.parent.type == 'getindex' then
            if src.parent.index == src then
                src = src.parent
            end
        end
    end
    local tp, literal
    tp, literal = getFieldFast(src)
    if tp then
        return tp, literal
    end
    if timeUp or mark[key] then
        return nil
    end
    mark[key] = true
    tp, literal = getFieldFull(src)
    if tp then
        return tp, literal
    end
    return nil
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

local function mergeTypes(types)
    local results = {}
    local mark = {
        -- 讲道理table的keyvalue不会是nil
        ['nil'] = true,
    }
    for _, tv in ipairs(types) do
        for tp in tv:gmatch '[^|]+' do
            if not mark[tp] then
                mark[tp] = true
                results[#results+1] = tp
            end
        end
    end
    return guide.mergeTypes(results)
end

local function clearClasses(classes)
    local knownClasses = {
        ['any'] = true,
        ['nil'] = true,
    }
    local anyClasses = {}
    local strClasses = {}
    for key, class in pairs(classes) do
        if key == '[any]' then
            util.array2hash(class, anyClasses)
            goto CONTINUE
        elseif key == '[string]' then
            util.array2hash(class, strClasses)
            goto CONTINUE
        end
        util.array2hash(class, knownClasses)
        ::CONTINUE::
    end
    for c in pairs(knownClasses) do
        anyClasses[c] = nil
        strClasses[c] = nil
    end
    if next(anyClasses) then
        classes['[any]'] = util.hash2array(anyClasses)
    else
        classes['[any]'] = nil
    end
    if next(strClasses) then
        classes['[string]'] = util.hash2array(strClasses)
    else
        classes['[string]'] = nil
    end
end

return function (source)
    local literals = {}
    local classes = {}
    local clock = os.clock()
    local timeUp
    local mark = {}
    local fields = vm.getFields(source, 'deep')
    local keyCount = 0
    for _, src in ipairs(fields) do
        local key = getKey(src)
        if not key then
            goto CONTINUE
        end
        if not classes[key] then
            classes[key] = {}
            keyCount = keyCount + 1
        end
        if not literals[key] then
            literals[key] = {}
        end
        if not TEST and os.clock() - clock > config.config.hover.fieldInfer / 1000.0 then
            timeUp = true
        end
        local class, literal = getField(src, timeUp, mark, key)
        if literal == 'nil' then
            literal = nil
        end
        classes[key][#classes[key]+1] = class
        literals[key][#literals[key]+1] = literal
        if keyCount >= 1000 then
            break
        end
        ::CONTINUE::
    end

    clearClasses(classes)

    for key, class in pairs(classes) do
        literals[key] = mergeLiteral(literals[key])
        classes[key] = mergeTypes(class)
    end

    if not next(classes) then
        return '{}'
    end

    local intValue = true
    for key, class in pairs(classes) do
        if class ~= 'integer' or not tonumber(literals[key]) then
            intValue = false
            break
        end
    end
    local result
    if intValue then
        result = buildAsConst(classes, literals)
    else
        result = buildAsHash(classes, literals)
    end
    if timeUp then
        result = ('\n--%s\n%s'):format(lang.script.HOVER_TABLE_TIME_UP, result)
    end
    return result
end
