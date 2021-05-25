local vm       = require 'vm'
local util     = require 'utility'
local searcher = require 'core.searcher'
local config   = require 'config'
local lang     = require 'language'
local infer    = require 'core.infer'

local function formatKey(src)
    local key = vm.getKeyName(src)
    if not key or #key <= 0 then
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
    if vm.getKeyType(src) == 'string' then
        if key:match '^[%a_][%w_]*$' then
            return key
        else
            return ('[%s]'):format(util.viewLiteral(key))
        end
    end
    return ('[%s]'):format(key)
end

local function buildAsHash(keyMap, inferMap, literalMap, reachMax)
    local keys = {}
    for k in pairs(keyMap) do
        keys[#keys+1] = k
    end
    table.sort(keys)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local inferView   = inferMap[key]
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s: %s = %s,'):format(formatKey(key), inferView, literalView)
        else
            lines[#lines+1] = ('    %s: %s,'):format(formatKey(key), inferView)
        end
    end
    if reachMax then
        lines[#lines+1] = '    ...'
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function buildAsConst(keyMap, inferMap, literalMap, reachMax)
    local keys = {}
    for k in pairs(keyMap) do
        keys[#keys+1] = k
    end
    table.sort(keys, function (a, b)
        return tonumber(literalMap[a]) < tonumber(literalMap[b])
    end)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local inferView   = inferMap[key]
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s: %s = %s,'):format(formatKey(key), inferView, literalView)
        else
            lines[#lines+1] = ('    %s: %s,'):format(formatKey(key), inferView)
        end
    end
    if reachMax then
        lines[#lines+1] = '    ...'
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function clearClasses(classes)
    classes['[nil]'] = nil
    classes['[any]'] = nil
    classes['[string]'] = nil
end

--[[
return function (source)
    if config.config.hover.previewFields <= 0 then
        return 'table'
    end
    local literals = {}
    local classes = {}
    local clock = os.clock()
    local timeUp
    local mark = {}
    local fields = vm.getFields(source, 0)
    local keyCount = 0
    local reachMax
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
        if keyCount >= config.config.hover.previewFields then
            reachMax = true
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
        result = buildAsConst(classes, literals, reachMax)
    else
        result = buildAsHash(classes, literals, reachMax)
    end
    if timeUp then
        result = ('\n--%s\n%s'):format(lang.script.HOVER_TABLE_TIME_UP, result)
    end
    return result
end
--]]

local function getKeyMap(fields)
    local keys = {}
    for _, field in ipairs(fields) do
        local key = vm.getKeyName(field)
        if key then
            keys[key] = true
        end
    end
    return keys
end

return function (source)
    if config.config.hover.previewFields <= 0 then
        return 'table'
    end
    local fields = vm.getFields(source)
    local keyMap = getKeyMap(fields)
    local inferMap   = {}
    local literalMap = {}
    for key in pairs(keyMap) do
        inferMap[key] = infer.searchAndViewInfers(source, key)
    end
end
