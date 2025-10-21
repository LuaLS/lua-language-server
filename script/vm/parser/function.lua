---@param catGroup LuaParser.Node.Cat[]?
---@param key string
---@return LuaParser.Node.CatExp?
local function findParamType(catGroup, key)
    if not catGroup then
        return nil
    end
    for _, cat in ipairs(catGroup) do
        local cvalue = cat.value
        ---@cast cvalue -?
        if cvalue.kind == 'catstateparam' then
            ---@cast cvalue LuaParser.Node.CatStateParam
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
    variable:addSubVariable(headVar)
    headVar:addSubVariable(variable)
    runner:addDispose(function ()
        variable:removeSubVariable(headVar)
        headVar:removeSubVariable(variable)
    end)
    local classes = headVar.classes
    if not classes then
        return
    end
    local classList = classes:toArray()
    runner:setNode(first, runner.node.union(classList))
    ---@param class Node.Type
    for _, class in ipairs(classList) do
        class:addVariable(variable)
        variable:addClass(class)
    end
    runner:addDispose(function ()
        ---@param class Node.Type
        for _, class in ipairs(classList) do
            class:removeVariable(variable)
            variable:removeClass(class)
        end
    end)
end

ls.vm.registerRunnerParser('function', function (runner, source)
    ---@cast source LuaParser.Node.Function
    local catGroup = runner:getCatGroup(source)
    local node = runner.node
    local subRunner = runner:getSubRunner(source)

    bindSelf(subRunner, source)

    local func = node.func()
    func:setLocation(runner:makeLocation(source))
    runner:setNode(source, func)
    for _, param in ipairs(source.params) do
        local variable = subRunner:getVariable(param)
        if not variable then
            goto continue
        end
        local cat = findParamType(catGroup, param.id)
        ---@type Node
        local tp = node.ANY
        if cat then
            tp = subRunner:parse(cat)
            variable:addType(tp)
            subRunner:setNode(param, tp)
        else
            tp = subRunner:parse(param)
        end
        if param.id == '...' then
            func:addVarargParamDef(tp)
        else
            func:addParamDef(param.id, tp)
        end
        ::continue::
    end
    if catGroup then
        for _, cat in ipairs(catGroup) do
            local cvalue = cat.value
            ---@cast cvalue -?
            if cvalue.kind == 'catstatereturn' then
                ---@cast cvalue LuaParser.Node.CatStateReturn
                func:addReturnDef(cvalue.key and cvalue.key.id, subRunner:parse(cvalue.value))
            elseif cvalue.kind == 'catstategeneric' then
                ---@cast cvalue LuaParser.Node.CatStateGeneric
                for _, generic in ipairs(cvalue.typeParams) do
                    local gnode = subRunner:parse(generic)
                    ---@cast gnode Node.Generic
                    func:addTypeParam(gnode)
                end
            end
        end
    end

    return func
end)

ls.vm.registerRunnerParser('return', function (runner, source)
    ---@cast source LuaParser.Node.Return

    local node = runner.node
    local func = source.parentFunction
    if not func then
        return
    end

    local funcNode = runner.vfile:getNode(func)
    if not funcNode or funcNode.kind ~= 'function' then
        return
    end
    ---@cast funcNode Node.Function

    for i, exp in ipairs(source.exps) do
        funcNode:setReturnNode(i, runner:lazyParse(exp, node.UNKNOWN))
    end
end)
