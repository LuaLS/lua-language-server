---@param catGroup LuaParser.Node.Cat[]?
---@param key string
---@return LuaParser.Node.CatType?
local function findParamType(catGroup, key)
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

---@param runner VM.Runner
---@param source LuaParser.Node.Function
local function bindSelf(runner, source)
    local params = source.params
    if not params then
        return
    end
    local first = params[1]
    if not first or first.id ~= 'self' then
        return
    end
    local variable = runner:getVariable(first)
    if not variable then
        return
    end
    local name = source.name
    if not name or name.subtype ~= 'method' then
        return
    end
    local last = name.last
    if not last then
        return
    end
    local headVar = runner.vfile:getVariable(last)
    if not headVar then
        return
    end
    local classes = headVar.classes
    if not classes then
        return
    end
    ---@param class Node.Type
    for class in classes:pairsFast() do
        class:addVariable(variable)
        variable:addClass(class)
    end
    runner:addDispose(function ()
        ---@param class Node.Type
        for class in classes:pairsFast() do
            class:removeVariable(variable)
            variable:removeClass(class)
        end
    end)
end

ls.vm.registerRunnerParser('function', function (runner, source)
    ---@cast source LuaParser.Node.Function
    local catGroup = runner:getCatGroup(source)
    local node = runner.node

    local func = node.func()
    for _, param in ipairs(source.params) do
        if param.id == '...' then
            func:addVarargParam(runner:unsolve(node.ANY, findParamType(catGroup, '...')))
        else
            func:addParam(param.id, runner:unsolve(node.ANY, findParamType(catGroup, param.id)))
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

    bindSelf(runner, source)

    return func
end)
