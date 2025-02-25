ls.vm.registerRunnerParser('function', function (runner, source)
    ---@cast source LuaParser.Node.Function
    local catGroup
    local node = runner.node

    local function findParamType(key)
        if not catGroup then
            return nil
        end
        for _, cat in ipairs(catGroup.cats) do
            local cvalue = cat.value
            ---@cast cvalue -?
            if cvalue.kind == 'catparam' then
                ---@cast cvalue LuaParser.Node.CatParam
                if cvalue.key.id == key then
                    return runner:parse(cvalue.value)
                end
            end
        end
    end

    local func = node.func()
    for _, param in ipairs(source.params) do
        if param.id == '...' then
            func:addVarargParam(findParamType '...' or node.ANY)
        else
            func:addParam(param.id, findParamType(param.id) or node.ANY)
        end
    end
    if catGroup then
        for _, cat in ipairs(catGroup.cats) do
            local cvalue = cat.value
            ---@cast cvalue -?
            if cvalue.kind == 'catreturn' then
                ---@cast cvalue LuaParser.Node.CatReturn
                func:addReturn(cvalue.key and cvalue.key.id, runner:parse(cvalue.value))
            end
        end
    end

    return func
end)
