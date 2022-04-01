local vm       = require 'vm'
local util     = require 'utility'
local config   = require 'config'
local infer    = require 'vm.infer'
local await    = require 'await'
local guide    = require 'parser.guide'

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

local function buildAsHash(keys, typeMap, literalMap, optMap, reachMax)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local typeView    = typeMap[key]
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s%s: %s = %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                typeView,
                literalView)
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                typeView
            )
        end
    end
    if reachMax > 0 then
        lines[#lines+1] = ('    ...(+%d)'):format(reachMax)
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function buildAsConst(keys, typeMap, literalMap, optMap, reachMax)
    table.sort(keys, function (a, b)
        return tonumber(literalMap[a]) < tonumber(literalMap[b])
    end)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local typeView    = typeMap[key]
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s%s: %s = %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                typeView,
                literalView
            )
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                formatKey(key),
                optMap[key] and '?' or '',
                typeView
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
    local map  = {}
    for _, field in ipairs(fields) do
        local key = vm.getKeyName(field)
        if key and not map[key] then
            map[key] = true
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
    return keys, map
end

local function getOptMap(fields, keyMap)
    local optMap = {}
    for _, field in ipairs(fields) do
        if field.type == 'doc.field.name' then
            if field.parent.optional then
                local key = vm.getKeyName(field)
                if keyMap[key] then
                    optMap[key] = true
                end
            end
        end
        if field.type == 'doc.type.field' then
            if field.optional then
                local key = vm.getKeyName(field)
                if keyMap[key] then
                    optMap[key] = true
                end
            end
        end
    end
    return optMap
end

---@async
local function getInferMap(fields, keyMap)
    ---@type table<string, vm.infer>
    local inferMap = {}
    for _, field in ipairs(fields) do
        local key = vm.getKeyName(field)
        if not keyMap[key] then
            goto CONTINUE
        end
        await.delay()
        local ifr = infer.getInfer(field)
        if inferMap[key] then
            inferMap[key]:merge(ifr)
        else
            inferMap[key] = ifr
        end
        ::CONTINUE::
    end
    return inferMap
end

---@async
---@return string?
return function (source)
    local uri = guide.getUri(source)
    local maxFields = config.get(uri, 'Lua.hover.previewFields')
    if maxFields <= 0 then
        return nil
    end

    local fields    = vm.getFields(source)
    local keys, map = getKeyMap(fields)
    if #keys == 0 then
        return nil
    end

    local reachMax = #keys - maxFields
    if #keys > maxFields then
        for i = maxFields + 1, #keys do
            map[keys[i]] = nil
            keys[i] = nil
        end
    end

    local optMap   = getOptMap(fields, map)
    local inferMap = getInferMap(fields, map)

    local typeMap    = {}
    local literalMap = {}
    local isConsts = true
    for i = 1, #keys do
        await.delay()
        local key = keys[i]

        typeMap[key]    = inferMap[key]:view('unknown', uri)
        literalMap[key] = inferMap[key]:viewLiterals()
        if not tonumber(literalMap[key]) then
            isConsts = false
        end
    end

    local result

    if isConsts then
        result = buildAsConst(keys, typeMap, literalMap, optMap, reachMax)
    else
        result = buildAsHash(keys, typeMap, literalMap, optMap, reachMax)
    end

    --if timeUp then
    --    result = ('\n--%s\n%s'):format(lang.script.HOVER_TABLE_TIME_UP, result)
    --end

    return result
end
