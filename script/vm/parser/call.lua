ls.vm.registerRunnerParser('call', function (runner, source)
    ---@cast source LuaParser.Node.Call

    local funcNode = runner:parse(source.node).solve

    local returns = {}
    local allMin = 0
    ---@type integer?
    local allMax = 0
    local hasDef

    for f in funcNode:each 'function' do
        hasDef = true
        ---@cast f Node.Function
        local min, max = f:getReturnCount()
        for i = 1, min do
            returns[i] = returns[i] | f:getReturn(i)
        end
        if not allMin or allMin > min then
            allMin = min
        end
        if not max then
            allMax = nil
        elseif allMax and allMax < max then
            allMax = max
        end
    end

    if not hasDef then
        return runner.node.UNKNOWN
    end

    local vararg = runner.node.vararg(returns, allMin, allMax)

    return vararg
end)
