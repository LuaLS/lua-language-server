
ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    local tnode = snode:finalValue()
    if tnode.kind ~= 'table' then
        return
    end

    local label = tnode:view {
        noFunctionDetail = true,
    }
    if label == '{}' then
        return
    end

    ---@cast tnode Node.Table
    action.push {
        label = label
    }
end)
