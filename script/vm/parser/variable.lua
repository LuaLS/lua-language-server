ls.vm.registerRunnerParser('assign', function (runner, source)
    ---@cast source LuaParser.Node.Assign

    for _, exp in ipairs(source.exps) do
        runner:parse(exp)
    end
end)

---@param runner VM.Runner
---@param source LuaParser.Node.Base
---@param variable Node.Variable
---@return Node?
local function bindVariableWithClass(runner, source, variable)
    local catGroup = runner:getCatGroup(source)
    if not catGroup then
        return nil
    end
    local first = catGroup[1]
    if first.value.kind ~= 'catstateclass' then
        return nil
    end
    local class = runner:parse(first)
    ---@cast class Node.Type
    class:addVariable(variable)
    variable:addClass(class)

    runner:addDispose(function ()
        class:removeVariable(variable)
        variable:removeClass(class)
    end)

    return class
end

---@param runner VM.Runner
---@param source LuaParser.Node.Base
---@param variable Node.Variable
---@return Node?
local function bindVariableWithType(runner, source, variable)
    local catGroup = runner:getCatGroup(source)
    if not catGroup then
        return nil
    end
    local tnode
    for _, cat in ipairs(catGroup) do
        if cat.value.kind == 'catstatetype' then
            tnode = runner:parse(cat)
        end
    end
    if not tnode then
        return nil
    end

    variable:addType(tnode)

    return tnode
end

ls.vm.registerRunnerParser('var', function (runner, source)
    ---@cast source LuaParser.Node.Var

    if source.loc then
        -- 局部变量
        local locNode = runner:parse(source.loc)
        local variable = runner:getVariable(source.loc)
        if variable then
            runner:setVariable(source, variable)
            if source.value then
                local field = runner:makeNodeField(source, source.id, source.value)
                variable:addAssign(field)
            end
        end
        return locNode
    else
        -- 全局变量
        local field = runner:makeNodeField(source, source.id, source.value)
        local variable = runner.node:globalAdd(field)

        runner:addDispose(function ()
            runner.node:globalRemove(field)
        end)

        runner:setVariable(source, variable)

        bindVariableWithClass(runner, source, variable)

        return field.value
    end
end)

ls.vm.registerRunnerParser('localdef', function (runner, source)
    ---@cast source LuaParser.Node.LocalDef

    local firstVar = source.vars[1]

    local firstVariable = runner:getVariable(firstVar)
    if firstVariable then
        bindVariableWithClass(runner, source, firstVariable)
    end

    for _, var in ipairs(source.vars) do
        runner:parse(var)
    end
end)

ls.vm.registerRunnerParser('local', function (runner, source)
    ---@cast source LuaParser.Node.Local

    local variable = runner.node.variable(source.id)
    runner:setVariable(source, variable)

    local bindType = bindVariableWithType(runner, source, variable)
    if bindType then
        return bindType
    end

    if source.value then
        local vnode = runner:parse(source.value)
        if vnode.kind == 'table' then
            ---@cast vnode Node.Table
            if vnode.fields then
                for field in vnode.fields:pairsFast() do
                    variable:addField(field)
                end
            end
        end

        return vnode
    end
end)

ls.vm.registerRunnerParser('param', function (runner, source)
    ---@cast source LuaParser.Node.Param

    local variable = runner.node.variable(source.id)
    runner:setVariable(source, variable)

    return runner.node.ANY
end)

---@param runner VM.Runner
---@param last LuaParser.Node.Base
---@param key Node.Key
---@return Node.Unsolve
local function unsolveField(runner, last, key)
    return runner.node.unsolve(runner.node.UNKNOWN, nil, function (unsolve, context)
        local fields = runner:findFields(last, key)
        if not fields then
            return runner.node.UNKNOWN
        end
        local values = ls.util.map(fields, function (v, k)
            return v.value
        end)
        return runner.node.union(values)
    end)
end

ls.vm.registerRunnerParser('field', function (runner, source)
    ---@cast source LuaParser.Node.Field

    local key = runner.vm:getKey(source)

    local var = runner:getFirstVar(source)
    if not var then
        return
    end

    local value = source.value
    local field = runner:makeNodeField(source.key, key, value)

    if var.loc then
        -- 局部变量的字段
        local lastVariable = runner:getVariable(source.last)
        if not lastVariable then
            return field.value
        end

        local variable = lastVariable:addField(field)
        runner:addDispose(function ()
            lastVariable:removeField(field)
        end)
        runner:setVariable(source, variable)

        if value then
            -- 局部变量的字段赋值
            bindVariableWithClass(runner, source, variable)
            variable:addAssign(field)
        end
    else
        -- 全局变量的字段
        local path = runner:getFullPath(source)
        local variable = runner.node:globalAdd(field, path)
        runner:addDispose(function ()
            runner.node:globalRemove(field, path)
        end)
        runner:setVariable(source, variable)

        if value then
            -- 全局变量的字段赋值
            bindVariableWithClass(runner, source, variable)
            variable:addAssign(field)
        end
    end

    if value and value.kind == 'function' then
        ---@cast value LuaParser.Node.Function
        if source.subtype == 'method' then
            runner:indexSubRunner(value)
        end
    end

    return field.value or unsolveField(runner, source.last, key)
end)
