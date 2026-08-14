-- 自定义 alias 的 hover 支持：
-- 当 hover 的 source 所属变量被 `---@type X` 注解为某个注册了 `onHover`
-- 的 custom alias 时，调用该 alias 的 customHover 回调，把返回的字符串
-- （或字符串数组）作为额外的 hover 内容追加显示。
-- 不限制 source 类型（字符串/数字/变量名等），由 custom 回调自行判断。

--- 遍历 param.sources（由内到外、所有包含触发位置的节点链），查找所属变量（localdef / assign）
---@param param Feature.Hover.Param
---@return Node.Variable?
local function findOwnerVariable(param)
    local source = param.source
    local vm = param.vm
    for _, s in ipairs(param.sources) do
        if s.kind == 'localdef' then
            ---@cast s LuaParser.Node.LocalDef
            for i, value in ipairs(s.values or {}) do
                if value == source then
                    local var = s.vars and s.vars[i]
                    if var then
                        return vm:getVariable(var)
                    end
                end
            end
            -- 变量名本身（hover 声明处的名字）
            for i, var in ipairs(s.vars or {}) do
                if var == source then
                    return vm:getVariable(var)
                end
            end
        elseif s.kind == 'assign' then
            ---@cast s LuaParser.Node.Assign
            for i, value in ipairs(s.values or {}) do
                if value == source then
                    local exp = s.exps and s.exps[i]
                    if exp then
                        return vm:getVariable(exp)
                    end
                end
            end
            -- 变量名本身（hover 赋值左侧的名字）
            for i, exp in ipairs(s.exps or {}) do
                if exp == source then
                    return vm:getVariable(exp)
                end
            end
        end
    end
    return nil
end

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

--- 查找变量的 custom hover alias：优先 value（静态/当前值），再兜底 getExpectValue（类型注解）
---@param variable Node.Variable
---@return Node.Alias?
local function findCustomHoverAliasFromVariable(variable)
    if not variable then
        return nil
    end
    local alias = findCustomHoverAlias(variable.value)
    if alias then
        return alias
    end
    return findCustomHoverAlias(variable:getExpectValue())
end

ls.feature.provider.hover(function (param, action)
    local source = param.source
    local variable = findOwnerVariable(param)
    if not variable then
        return
    end

    local alias = findCustomHoverAliasFromVariable(variable)
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
        for _, label in ipairs(result) do
            if type(label) == 'string' and label ~= '' then
                action.push { label = label }
            end
        end
    end
end)
