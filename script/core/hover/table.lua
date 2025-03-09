local vm       = require 'vm'
local config   = require 'config'
local await    = require 'await'
local guide    = require 'parser.guide'

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
                key,
                isOptional and '?' or '',
                typeView,
                literalView
            )
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                key,
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
                key,
                isOptional and '?' or '',
                typeView,
                literalView
            )
        else
            lines[#lines+1] = ('    %s%s: %s,'):format(
                key,
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

---@param source parser.object
---@param fields parser.object[]
local function getVisibleKeyMap(source, fields)
    local uri  = guide.getUri(source)
    local keys = {}
    local map  = {}
    local ignored = {}
    for _, field in ipairs(fields) do
        local key = vm.viewKey(field, uri)
        local rawKey = guide.getKeyName(field)
        if rawKey and rawKey ~= key then
            ignored[rawKey] = true
            map[rawKey] = nil
        end
        if  not ignored[key]
        and vm.isVisible(source, field) then
            if key and not map[key] then
                map[key] = true
            end
        end
    end
    for key in pairs(map) do
        keys[#keys+1] = key
    end
    table.sort(keys, function (a, b)
        if a == b then
            return false
        end
        local s1 = 0
        local s2 = 0
        if a:sub(1, 1) == '_' then
            s1 = s1 + 10
        end
        if b:sub(1, 1) == '_' then
            s2 = s2 + 10
        end
        if a:sub(1, 1) == '[' then
            s1 = s1 + 1
        end
        if b:sub(1, 1) == '[' then
            s2 = s2 + 1
        end
        if s1 == s2 then
            return a < b
        end
        return s1 < s2
    end)
    return keys, map
end

---@async
local function getNodeMap(uri, fields, keyMap)
    ---@type table<string, vm.node>
    local nodeMap = {}
    for _, field in ipairs(fields) do
        local key = vm.viewKey(field, uri)
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
---@param level integer
---@return string?
---@return integer?
return function (source, level)
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
        elseif n.type == 'doc.type.sign' then
            return nil
        end
    end

    local fields    = vm.getFields(source)
    local keys, map = getVisibleKeyMap(source, fields)
    if #keys == 0 then
        return nil
    end

    local maxLevel = math.ceil(math.sqrt(#keys / maxFields))
    if level <= 0 then
        return nil, maxLevel
    end

    local finalMaxFields = maxFields * level * level
    local reachMax = #keys - finalMaxFields
    if #keys > finalMaxFields then
        for i = finalMaxFields + 1, #keys do
            map[keys[i]] = nil
            keys[i] = nil
        end
    end

    local nodeMap = getNodeMap(uri, fields, map)

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

    return result, maxLevel
end
