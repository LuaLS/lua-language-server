---@type Feature.Provider<Feature.Definition.Param>
local providers = ls.feature.helper.providers()

---@class Feature.Definition.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field vm VM
---@field sources LuaParser.Node.Base[]

---@async
---@param uri Uri
---@param offset integer
---@return Location[]
function ls.feature.definition(uri, offset)
    ls.scope.waitReady(uri)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 or not scope then
        return {}
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        vm      = scope.vm,
        sources = sources,
    }

    local results = providers.runner(param)

    return ls.feature.helper.organizeResultsByRange(results)
end

---@param callback fun(param: Feature.Definition.Param, action: Feature.ProviderActions<Location>)
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.definition(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

--- 在类型节点上查找注册了 customDefinition 的 alias（递归处理 union）
---@param node? Node
---@return Node.Alias?
local function findCustomDefinitionAlias(node)
    if not node then
        return nil
    end
    if node.kind == 'union' then
        ---@cast node Node.Union
        for _, v in ipairs(node.values) do
            local alias = findCustomDefinitionAlias(v)
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
        if alias.customDefinition then
            return alias
        end
    end
    return nil
end

--- 查找节点的 custom definition alias：优先实际值，再兜底期望类型（rt.getExpectValue）
---@param node Node?
---@param source LuaParser.Node.Base?
---@return Node.Alias?
local function findCustomDefinitionAliasFromNode(node, source)
    if not node then
        return nil
    end
    local alias = findCustomDefinitionAlias(node.value)
    if alias then
        return alias
    end
    if source then
        return findCustomDefinitionAlias(node.scope.rt:getExpectValue(source))
    end
    return nil
end

-- 自定义 alias 的跳转：光标在关联了 onDefinition 的 custom alias 上时，
-- 追加 customDefinition 回调返回的位置。
ls.feature.provider.definition(function (param, action)
    local source = param.sources[1]
    local node = param.vm:getVariable(source)
             or param.vm:getNode(source)
    local alias = findCustomDefinitionAliasFromNode(node, source)
    if not alias then
        return
    end

    local result = alias.customDefinition(alias, {
        uri    = param.uri,
        offset = param.offset,
    }, source)
    if not result then
        return
    end
    if result.range then
        ---@cast result Location
        action.push(result)
    else
        for _, loc in ipairs(result) do
            action.push(loc)
        end
    end
end)

-- 函数或表的位置
ls.feature.provider.definition(function (param, action)
    local first = param.sources[1]
    local node = param.scope.vm:getNode(first)
    if not node then
        return
    end
    ---@param func Node.Function
    node:each('function', function (func)
        if func.location then
            action.push(ls.feature.helper.convertLocation(func.location, first))
        end
    end)
    ---@param table Node.Table
    node:each('table', function (table)
        if table.locations then
            for _, location in ipairs(table.locations) do
                action.push(ls.feature.helper.convertLocation(location, first))
            end
        end
    end)
end)

-- 变量的定义位置
ls.feature.provider.definition(function (param, action)
    local var = param.sources[1]
    if  var.kind ~= 'var'
    and var.kind ~= 'local'
    and var.kind ~= 'param' then
        return
    end
    action.skip()
    local variable = param.scope.vm:getVariable(var)
    if not variable then
        return
    end

    if variable.key.literal == '...' then
        return
    end

    -- 在声明处查询定义，则查询所有等价定义的赋值位置
    if var.kind == 'local' or var.kind == 'param' then
        for _, location in ipairs(variable:getEquivalentLocations(true)) do
            action.push(ls.feature.helper.convertLocation(location, var))
        end
        return
    end

    ---@cast var LuaParser.Node.Var

    ---@param variable Node.Variable
    local function findDefinition(variable)
        ---@cast var LuaParser.Node.Var
        -- 如果是局部变量，则只查询声明位置
        local location = variable:getLocation()
        if location then
            action.push(ls.feature.helper.convertLocation(location, var))
            return
        end

        -- 否则查询所有赋值位置
        for assign in variable:eachAssign() do
            local location = assign.location
            if location then
                action.push(ls.feature.helper.convertLocation(location, var))
            end
        end
    end

    -- 如果是 self，则查询父变量的定义位置
    local p = var.loc
    if p and p.kind == 'param' then
        ---@cast p LuaParser.Node.Param
        local paramVariable = param.scope.vm:getVariable(p)
        if paramVariable and paramVariable:isSelfLike() then
            local parentVariable = paramVariable.masterVariable
            if parentVariable then
                findDefinition(parentVariable)
                return
            end
        end
    end

    -- 否则查询变量本身的定义位置
    findDefinition(variable)
end)

-- 字段的赋值位置
ls.feature.provider.definition(function (param, action)
    local first = param.sources[1]
    local field = param.sources[2]
    if not field or field.kind ~= 'field' then
        return
    end
    ---@cast field LuaParser.Node.Field
    if field.key ~= first then
        return
    end
    ---@type Node.Variable?
    local variable = param.scope.vm:getVariable(field)

    if not variable then
        return
    end

    -- 有个特殊规则，等价位置必须是 field ，且 field 名称要相同

    for _, location in ipairs(variable:getEquivalentLocations(false, true)) do
        action.push(ls.feature.helper.convertLocation(location, field))
    end
end)

-- 表中字段的定义位置
ls.feature.provider.definition(function (param, action)
    local first = param.sources[1]
    if first.kind ~= 'tablefieldid' then
        return
    end
    local node = param.scope.vm:getNode(first)
    if not node then
        return
    end
    ---@param field Node.Field
    node:each('field', function (field)
        if field.location and field.value ~= first then
            action.push(ls.feature.helper.convertLocation(field.location, first))
        end
    end)
end)

-- 标签
ls.feature.provider.definition(function (param, action)
    local source = param.sources[2]
    if not source or source.kind ~= 'goto' then
        return
    end
    action.skip()
    ---@cast source LuaParser.Node.Goto
    local label = source.label
    if not label then
        return
    end

    action.push {
        uri = label.ast.source,
        range = { label.name.start, label.name.finish },
        originUri = source.ast.source,
        originRange = { source.name.start, source.name.finish },
    }
end)

---@param node Node.Type
---@param push fun(loc: Location)
---@param source? LuaParser.Node.Base
local function findDefinitionOfType(node, push, source)
    if node.classes then
        for _, class in ipairs(node.classes) do
            local location = class.location
            if location then
                push(ls.feature.helper.convertLocation(location, source))
            end
        end
    end
    if node.aliases then
        for _, alias in ipairs(node.aliases) do
            local location = alias.location
            if location then
                push(ls.feature.helper.convertLocation(location, source))
            end
        end
    end
end

-- LuaCats 的类
ls.feature.provider.definition(function (param, action)
    local source = param.sources[1]
    if not source or source.kind ~= 'catid' then
        return
    end

    ---@cast source LuaParser.Node.CatID
    local node = param.scope.rt.type(source.id)

    ---@cast node Node.Type
    findDefinitionOfType(node, action.push)
end)

-- see 跳转，这个以后挪到文件符号功能里
ls.feature.provider.definition(function (param, action)
    local source = param.sources[1]
    if not source or source.kind ~= 'catseename' then
        return
    end
    local rt = param.scope.rt
    ---@cast source LuaParser.Node.CatSeeName
    local names = ls.util.split(source.id, '.')

    findDefinitionOfType(rt.type(source.id), action.push, source)
    local varFields = rt:findGlobalVariableFields(table.unpack(names))
    for _, field in ipairs(varFields) do
        if field.location then
            action.push(ls.feature.helper.convertLocation(field.location, source))
        end
    end

    for i = 2, #names do
        local t = rt.type(table.concat(names, '.', 1, i - 1))
        local fields = rt:findFields(t, names[i])
        for _, field in ipairs(fields) do
            if field.location then
                action.push(ls.feature.helper.convertLocation(field.location, source))
            end
        end
    end
end)
