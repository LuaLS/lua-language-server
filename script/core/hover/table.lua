local vm       = require 'vm'
local util     = require 'utility'
local config   = require 'config'
local infer    = require 'core.infer'
local await    = require 'await'

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

local function buildAsHash(keys, inferMap, literalMap, optMap, reachMax)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local inferView   = inferMap[key]
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s%s: %s = %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                inferView,
                literalView)
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                inferView
            )
        end
    end
    if reachMax > 0 then
        lines[#lines+1] = ('    ...(+%d)'):format(reachMax)
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function buildAsConst(keys, inferMap, literalMap, optMap, reachMax)
    table.sort(keys, function (a, b)
        return tonumber(literalMap[a]) < tonumber(literalMap[b])
    end)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local inferView   = inferMap[key]
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s%s: %s = %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                inferView,
                literalView
            )
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                inferView
            )
        end
    end
    if reachMax > 0 then
        lines[#lines+1] = ('    ...(+%d)'):format(reachMax)
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local typeSorter = {
    ['string']  = 1,
    ['number']  = 2,
    ['boolean'] = 3,
}

local function getKeyMap(fields)
    local keys = {}
    local mark = {}
    for _, field in ipairs(fields) do
        local key = vm.getKeyName(field)
        local tp  = vm.getKeyType(field)
        if tp == 'number' or tp == 'integer' then
            key = tonumber(key)
        elseif tp == 'boolean' then
            key = key == 'true'
        end
        if key and not mark[key] then
            mark[key] = true
            keys[#keys+1] = key
        end
    end
    table.sort(keys, function (a, b)
        if a == b then
            return false
        end
        local ta  = type(a)
        local tb  = type(b)
        local tsa = typeSorter[ta]
        local tsb = typeSorter[tb]
        if tsa == tsb then
            if ta == 'boolean' then
                return a == true
            end
            return a < b
        else
            return tsa < tsb
        end
    end)
    return keys
end

local function getOptionalMap(fields)
    local optionals = {}
    for _, field in ipairs(fields) do
        if field.type == 'doc.field.name' then
            if field.parent.optional then
                local key = vm.getKeyName(field)
                optionals[key] = true
            end
        end
        if field.type == 'doc.type.field' then
            if field.optional then
                local key = vm.getKeyName(field)
                optionals[key] = true
            end
        end
    end
    return optionals
end

---@async
return function (source)
    local maxFields = config.get 'Lua.hover.previewFields'
    if maxFields <= 0 then
        return 'table'
    end

    local fields = vm.getRefs(source, '*')
    local keys   = getKeyMap(fields)
    local optMap = getOptionalMap(fields)

    if #keys == 0 then
        return '{}'
    end

    local inferMap   = {}
    local literalMap = {}

    local reachMax = #keys - maxFields
    if #keys > maxFields then
        for i = maxFields + 1, #keys do
            keys[i] = nil
        end
    end

    local isConsts = true
    for i = 1, #keys do
        await.delay()
        local key = keys[i]
        inferMap[key]   = infer.searchAndViewInfers(source, key)
        literalMap[key] = infer.searchAndViewLiterals(source, key)
        if not tonumber(literalMap[key]) then
            isConsts = false
        end
    end

    local result

    if isConsts then
        result = buildAsConst(keys, inferMap, literalMap, optMap, reachMax)
    else
        result = buildAsHash(keys, inferMap, literalMap, optMap, reachMax)
    end

    --if timeUp then
    --    result = ('\n--%s\n%s'):format(lang.script.HOVER_TABLE_TIME_UP, result)
    --end

    return result
end
