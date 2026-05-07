
ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    snode = snode:simplify()

    snode:each('table', function (node)
        ---@cast node Node.Table
        if node == snode then
            return
        end

        local label = node:view {
            noFunctionDetail = true,
        }
        if label == '{}' then
            return
        end

        action.push {
            label = label
        }
    end)
end)
