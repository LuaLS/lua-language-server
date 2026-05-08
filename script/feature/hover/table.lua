ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    snode = snode:simplify()

    ---@param prefix string
    ---@param node Node.Table
    local function pushWithPrefix(prefix, node)
        local label = node:view {
            noFunctionDetail = true,
        }
        if label == '{}' then
            return
        end

        action.push {
            label = prefix .. label
        }
    end

    if snode.kind == 'type' then
        ---@cast snode Node.Type
        local value = snode.value
        if value.kind == 'table' then
            ---@cast value Node.Table
            if snode:isClassLike() then
                pushWithPrefix('(class) ' .. snode:view() .. ' ', value)
                return
            end
        end
        return
    end

    snode:each('table', function (node)
        ---@cast node Node.Table
        if node == snode then
            return
        end

        pushWithPrefix('', node)
    end)
end)
