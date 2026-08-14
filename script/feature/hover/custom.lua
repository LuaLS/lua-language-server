-- 自定义 alias 的 hover：hover 到关联了 onHover 的 custom alias 时，
-- 追加 customHover 回调返回的内容。期望类型经 Node:getExpectValue() 反推。

--- 在类型节点上查找注册了 customHover 的 alias（递归处理 union）
---@param node? Node
---@return Node.Alias?
local function findCustomHoverAlias(node)
    if not node then
        return nil
    end
    if node.kind == 'union' then
        ---@cast node Node.Union
        for _, v in ipairs(node.values) do
            local alias = findCustomHoverAlias(v)
            if alias then
                return alias
            end
        end
        return nil
    end
    if node.kind ~= 'type' then
        return nil
    end
    ---@cast node Node.Type
    if not node.aliases then
        return nil
    end
    for _, alias in ipairs(node.aliases) do
        if alias.customHover then
            return alias
        end
    end
    return nil
end

--- 查找节点的 custom hover alias：优先实际值，再兜底期望类型（getExpectValue）
---@param node Node?
---@return Node.Alias?
local function findCustomHoverAliasFromNode(node)
    if not node then
        return nil
    end
    local alias = findCustomHoverAlias(node.value)
    if alias then
        return alias
    end
    return findCustomHoverAlias(node:getExpectValue())
end

ls.feature.provider.hover(function (param, action)
    local source = param.source

    -- 变量名取 variable 本身，其它表达式取值节点（经 expectParent 反推期望类型）
    local node = param.vm:getVariable(source)
             or param.vm:getNode(source)
    local alias = findCustomHoverAliasFromNode(node)
    if not alias then
        return
    end

    local result = alias.customHover(alias, {
        uri    = param.uri,
        offset = param.offset,
    }, source)
    if type(result) == 'string' then
        if result ~= '' then
            action.push { label = result }
        end
    elseif type(result) == 'table' then
        action.push {
            label       = result.label or '',
            description = result.description,
        }
    end
end)
