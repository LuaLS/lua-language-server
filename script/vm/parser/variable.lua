ls.vm.registerRunnerParser('assign', function (runner, source)
    ---@cast source LuaParser.Node.Assign

    for _, exp in ipairs(source.exps) do
        runner:parse(exp)
    end
end)

---@param runner VM.Runner
---@param source LuaParser.Node.Base
---@param variable Node.Variable
local function bindVariableWithClass(runner, source, variable)
    local catGroup = runner:getCatGroup(source, 'catclass')
    if not catGroup then
        return
    end
    local class = runner:parse(catGroup[1])
    ---@cast class Node.Type
    class:addVariable(variable)
    variable:addClass(class)

    runner:addDispose(function ()
        class:removeVariable(variable)
        variable:removeClass(class)
    end)
end

ls.vm.registerRunnerParser('var', function (runner, source)
    ---@cast source LuaParser.Node.Var

    if source.loc then
        -- 局部变量
        local locNode = runner:parse(source.loc)
        local variable = runner:getVariable(source.loc)
        if variable then
            runner:setVariable(source, variable)
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
end)

ls.vm.registerRunnerParser('local', function (runner, source)
    ---@cast source LuaParser.Node.Local

    local variable = runner.node.variable(source.id)
    runner:setVariable(source, variable)
end)

ls.vm.registerRunnerParser('field', function (runner, source)
    ---@cast source LuaParser.Node.Field

    local key = runner:getKey(source)

    local var = runner:getFirstVar(source)
    if not var then
        return
    end

    local value = source.value
    local field = runner:makeNodeField(var, key, value)

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
        end
    end

    return field.value
end)
