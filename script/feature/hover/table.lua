ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    snode = snode:simplify()

    ---@param prefix string
    ---@param node Node.Table
    ---@param viewOptions? Node.Viewer.Options
    local function pushWithPrefix(prefix, node, viewOptions)
        local opts = { noFunctionDetail = true, inlineMax = 0 }
        if viewOptions then
            ls.util.tableMerge(opts, viewOptions)
        end
        local label = node:view(opts)
        if label == '{}' then
            return
        end

        action.push {
            label = prefix .. label
        }
    end

    ---@param source LuaParser.Node.Base
    ---@return boolean
    local function isTypeHover(source)
        if source.kind == 'catid' then
            return true
        end
        local variable = param.vm:getVariable(source)
        if variable and variable.types and not variable.classes then
            return true
        end
        return false
    end

    if snode.kind == 'type' then
        ---@cast snode Node.Type
        local value = snode.value
        if value.kind == 'table' then
            ---@cast value Node.Table
            if snode:isClassLike() then
                pushWithPrefix('(class) ' .. snode:view() .. ' ', value, isTypeHover(param.source) and { hidePrivate = true } or nil)
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
