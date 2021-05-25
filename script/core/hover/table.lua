local vm       = require 'vm'
local util     = require 'utility'
local searcher = require 'core.searcher'
local config   = require 'config'
local lang     = require 'language'
local infer    = require 'core.infer'

local function formatKey(key)
    if type(key) == 'string' then
        if key:match '^[%a_][%w_]*$' then
            return key
        else
            return ('[%s]'):format(util.viewLiteral(key))
        end
    end
    return ('[%s]'):format(key)
end

local function buildAsHash(keys, inferMap, literalMap, reachMax)
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

local function buildAsConst(keys, inferMap, literalMap, reachMax)
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
    local mark = {}
    for _, field in ipairs(fields) do
        local key = vm.getKeyName(field)
        if key and not mark[key] then
            keys[#keys+1] = key
        end
    end
    table.sort(keys, function (a, b)
        return tostring(a) < tostring(b)
    end)
    return keys
end

return function (source)
    local maxFields = config.config.hover.previewFields
    if maxFields <= 0 then
        return 'table'
    end

    local fields     = vm.getRefs(source, '*')
    local keys       = getKeyMap(fields)

    if #keys == 0 then
        return '{}'
    end

    local inferMap   = {}
    local literalMap = {}

    local reachMax = maxFields < #keys

    local isConsts = true
    for i = 1, math.min(maxFields, #keys) do
        local key = keys[i]
        inferMap[key]   = infer.searchAndViewInfers(source, key)
        literalMap[key] = infer.searchAndViewLiterals(source, key)
        if not tonumber(literalMap[key]) then
            isConsts = false
        end
    end

    if isConsts then
        return buildAsConst(keys, inferMap, literalMap, reachMax)
    else
        return buildAsHash(keys, inferMap, literalMap, reachMax)
    end
end
