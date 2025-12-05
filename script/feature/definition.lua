local providers = ls.tools.pqueue.create()

---@class Feature.Definition.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources? LuaParser.Node.Base[]

---@param uri Uri
---@param offset integer
---@return Location[]
function ls.feature.definition(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 then
        return {}
    end

    local results = {}
    local skipPriorty = -1

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
    }

    for provider, priority in providers:pairs() do
        if priority <= skipPriorty then
            break
        end
        xpcall(provider, log.error, param, function (loc)
            results[#results+1] = loc
        end, function (p)
            p = p or priority
            if skipPriorty < p then
                skipPriorty = p
            end
        end)
    end

    return ls.feature.helper.organizeResults(results)
end

---@param callback fun(param: Feature.Definition.Param, push: fun(loc: Location), skip: fun(priority?: integer))
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.definition(callback, priority)
    providers:insert(callback, priority)
    return function ()
        providers:remove(callback)
    end
end

-- 函数或表的位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    local node = param.scope.vm:getNode(first)
    if not node then
        return
    end
    ---@param func Node.Function
    node:each('function', function (func)
        if func.location then
            push(ls.feature.helper.convertLocation(func.location, first))
        end
    end)
    ---@param table Node.Table
    node:each('table', function (table)
        if table.locations then
            for _, location in ipairs(table.locations) do
                push(ls.feature.helper.convertLocation(location, first))
            end
        end
    end)
end)

-- 变量的定义位置
ls.feature.provider.definition(function (param, push, skip)
    local var = param.sources[1]
    if  var.kind ~= 'var'
    and var.kind ~= 'local'
    and var.kind ~= 'param' then
        return
    end
    skip()
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
            push(ls.feature.helper.convertLocation(location, var))
        end
        return
    end

    ---@cast var LuaParser.Node.Var

    ---@param variable Node.Variable
    local function findDefinition(variable)
        ---@cast var LuaParser.Node.Var
        -- 如果是局部变量，则只查询声明位置
        local location = variable.location
        if location then
            push(ls.feature.helper.convertLocation(location, var))
            return
        end

        -- 否则查询所有赋值位置
        if variable.assigns then
            for assign in variable.assigns:pairsFast() do
                ---@cast assign Node.Field
                local location = assign.location
                if location then
                    push(ls.feature.helper.convertLocation(location, var))
                end
            end
        end
    end

    -- 如果是 self，则查询父变量的定义位置
    local p = var.loc
    if p and p.kind == 'param' then
        ---@cast p LuaParser.Node.Param
        local coder = param.scope.vm:getCoder(var)
        if coder then
            local looksLikeSelf, parent = coder:looksLikeSelf(p)
            if looksLikeSelf and parent then
                local parentVariable = param.scope.vm:getVariable(parent)
                if parentVariable then
                    findDefinition(parentVariable)
                    return
                end
            end
        end
    end

    -- 否则查询变量本身的定义位置
    findDefinition(variable)
end)

-- 字段的赋值位置
ls.feature.provider.definition(function (param, push)
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
        push(ls.feature.helper.convertLocation(location, field))
    end
end)

-- 表中字段的定义位置
ls.feature.provider.definition(function (param, push)
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
            push(ls.feature.helper.convertLocation(field.location, first))
        end
    end)
end)

-- 标签
ls.feature.provider.definition(function (param, push, skip)
    local source = param.sources[2]
    if not source or source.kind ~= 'goto' then
        return
    end
    skip()
    ---@cast source LuaParser.Node.Goto
    local label = source.label
    if not label then
        return
    end

    push {
        uri = label.ast.source,
        range = { label.name.start, label.name.finish },
        originRange = { source.name.start, source.name.finish },
    }
end)

---@param node Node.Type
---@param push fun(loc: Location)
---@param source? LuaParser.Node.Base
local function findDefinitionOfType(node, push, source)
    if node.classes then
        for class in node.classes:pairsFast() do
            ---@cast class Node.Class
            local location = class.location
            if location then
                push(ls.feature.helper.convertLocation(location, source))
            end
        end
    end
    if node.aliases then
        for alias in node.aliases:pairsFast() do
            ---@cast alias Node.Alias
            local location = alias.location
            if location then
                push(ls.feature.helper.convertLocation(location, source))
            end
        end
    end
end

-- LuaCats 的类
ls.feature.provider.definition(function (param, push)
    local source = param.sources[1]
    if not source or source.kind ~= 'catid' then
        return
    end

    ---@cast source LuaParser.Node.CatID
    local node = param.scope.rt.type(source.id)

    ---@cast node Node.Type
    findDefinitionOfType(node, push)
end)

-- see 跳转，这个以后挪到文件符号功能里
ls.feature.provider.definition(function (param, push)
    local source = param.sources[1]
    if not source or source.kind ~= 'catseename' then
        return
    end
    local rt = param.scope.rt
    ---@cast source LuaParser.Node.CatSeeName
    local names = ls.util.split(source.id, '.')

    findDefinitionOfType(rt.type(source.id), push, source)

    local varFields = rt:findGlobalVariableFields(table.unpack(names))
    for _, field in ipairs(varFields) do
        if field.location then
            push(ls.feature.helper.convertLocation(field.location, source))
        end
    end

    for i = 2, #names do
        local t = rt.type(table.concat(names, '.', 1, i - 1))
        local fields = rt:findFields(t, names[i])
        for _, field in ipairs(fields) do
            if field.location then
                push(ls.feature.helper.convertLocation(field.location, source))
            end
        end
    end
end)
