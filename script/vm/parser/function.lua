ls.vm.registerRunnerParser('function', function (runner, source)
    ---@cast source LuaParser.Node.Function
    local catGroup = runner:getCatGroup(source)
    local node = runner.node

    ---@param key string
    ---@return LuaParser.Node.CatType?
    local function findParamType(key)
        if not catGroup then
            return nil
        end
        for _, cat in ipairs(catGroup) do
            local cvalue = cat.value
            ---@cast cvalue -?
            if cvalue.kind == 'catparam' then
                ---@cast cvalue LuaParser.Node.CatParam
                if cvalue.key.id == key then
                    return cvalue.value
                end
            end
        end
    end

    local func = node.func()
    for _, param in ipairs(source.params) do
        if param.id == '...' then
            func:addVarargParam(runner:unsolve(node.ANY, findParamType '...'))
        else
            func:addParam(param.id, runner:unsolve(node.ANY, findParamType(param.id)))
        end
    end
    if catGroup then
        for _, cat in ipairs(catGroup) do
            local cvalue = cat.value
            ---@cast cvalue -?
            if cvalue.kind == 'catreturn' then
                ---@cast cvalue LuaParser.Node.CatReturn
                func:addReturn(cvalue.key and cvalue.key.id, runner:unsolve(node.ANY, cvalue.value))
            end
        end
    end

    if source.name then
        runner:parse(source.name)
    end

    return func
end)
