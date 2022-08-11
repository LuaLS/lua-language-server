local vm       = require 'vm'
local util     = require 'utility'
local config   = require 'config'
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

---@param uri uri
---@param keys string[]
---@param nodeMap table<string, vm.node>
---@param reachMax integer
local function buildAsHash(uri, keys, nodeMap, reachMax)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local node        = nodeMap[key]
        local isOptional  = node:isOptional()
        if isOptional then
            node = node:copy()
            node:removeOptional()
        end
        local ifr         = vm.getInfer(node)
        local typeView    = ifr:view(uri, 'unknown')
        local literalView = ifr:viewLiterals()
        if literalView then
            lines[#lines+1] = ('    %s%s: %s = %s,'):format(
                formatKey(key),
                isOptional and '?' or '',
                typeView,
                literalView
            )
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                formatKey(key),
                isOptional and '?' or '',
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

---@param uri uri
---@param keys string[]
---@param nodeMap table<string, vm.node>
---@param reachMax integer
local function buildAsConst(uri, keys, nodeMap, reachMax)
    local literalMap = {}
    for _, key in ipairs(keys) do
        literalMap[key] = vm.getInfer(nodeMap[key]):viewLiterals()
    end
    table.sort(keys, function (a, b)
        return tonumber(literalMap[a]) < tonumber(literalMap[b])
    end)
    local lines = {}
    lines[#lines+1] = '{'
    for _, key in ipairs(keys) do
        local node        = nodeMap[key]
        local isOptional    = node:isOptional()
        if isOptional then
            node = node:copy()
            node:removeOptional()
        end
        local typeView    = vm.getInfer(node):view(uri, 'unknown')
        local literalView = literalMap[key]
        if literalView then
            lines[#lines+1] = ('    %s%s: %s = %s,'):format(
                formatKey(key),
                isOptional and '?' or '',
                typeView,
                literalView
            )
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                formatKey(key),
                isOptional and '?' or '',
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
            if ta == 'string' then
                if a:sub(1, 1) == '_' then
                    if b:sub(1, 1) == '_' then
                        return a < b
                    else
                        return false
                    end
                elseif b:sub(1, 1) == '_' then
                    return true
                else
                    return a < b
                end
            end
            return a < b
        else
            return tsa < tsb
        end
    end)
    return keys, map
end

---@async
local function getNodeMap(fields, keyMap)
    ---@type table<string, vm.node>
    local nodeMap = {}
    for _, field in ipairs(fields) do
        local key = vm.getKeyName(field)
        if not key or not keyMap[key] then
            goto CONTINUE
        end
        await.delay()
        local node = vm.compileNode(field)
        if nodeMap[key] then
            nodeMap[key]:merge(node)
        else
            nodeMap[key] = node:copy()
        end
        ::CONTINUE::
    end
    return nodeMap
end

---@async
---@return string?
return function (source)
    local uri = guide.getUri(source)
    local maxFields = config.get(uri, 'Lua.hover.previewFields')
    if maxFields <= 0 then
        return nil
    end

    local node = vm.compileNode(source)
    for n in node:eachObject() do
        if n.type == 'global' and n.cate == 'type' then
            if n.name == 'string'
            or (n.name ~= 'unknown' and n.name ~= 'any' and vm.isSubType(uri, n.name, 'string')) then
                return nil
            end
        elseif n.type == 'doc.type.string'
        or     n.type == 'string' then
            return nil
        end
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

    local nodeMap = getNodeMap(fields, map)

    local isConsts = true
    for i = 1, #keys do
        await.delay()
        local key = keys[i]
        local literal = vm.getInfer(nodeMap[key]):viewLiterals()
        if not tonumber(literal) then
            isConsts = false
        end
    end

    local result

    if isConsts then
        result = buildAsConst(uri, keys, nodeMap, reachMax)
    else
        result = buildAsHash(uri, keys, nodeMap, reachMax)
    end

    --if timeUp then
    --    result = ('\n--%s\n%s'):format(lang.script.HOVER_TABLE_TIME_UP, result)
    --end

    return result
end
