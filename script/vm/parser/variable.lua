ls.vm.registerRunnerParser('assign', function (runner, source)
    ---@cast source LuaParser.Node.Assign

    for _, exp in ipairs(source.exps) do
        runner:parse(exp)
    end
end)

---@param runner VM.Runner
---@param source LuaParser.Node.Base
---@param variable Node.Variable
local function bindSourceWithClass(runner, source, variable)
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
    else
        -- 全局变量
        local field = runner:makeNodeField(source, source.id, source.value)
        local variable = runner.node:globalAdd(field)

        runner:addDispose(function ()
            runner.node:globalRemove(field)
        end)

        bindSourceWithClass(runner, source, variable)

        return field.value
    end
end)

ls.vm.registerRunnerParser('field', function (runner, source)
    ---@cast source LuaParser.Node.Field

    local key = runner:getKey(source)

    local path, var = runner:makeFullPath(source)
    if not var then
        return
    end

    local value = source.value
    local field = runner:makeNodeField(var, key, value)

    if var.loc then
        -- 局部变量的字段
    else
        -- 全局变量的字段
        if value then
            -- 全局变量的字段赋值
            local variable = runner.node:globalAdd(field, path)
            runner:addDispose(function ()
                runner.node:globalRemove(field, path)
            end)
        end
    end

    return field.value
end)
