---@param source LuaParser.Node.TableFieldID
---@return string
local function getName(source)
    return source.id
end

ls.feature.provider.hover(function (param, action)
    if param.source.kind ~= 'tablefieldid' then
        return
    end
    local source = param.source
    ---@cast source LuaParser.Node.TableFieldID

    local field = source.parent
    if not field or not field.value then
        return
    end

    local fieldNode = param.vm:getNode(field)
    if not fieldNode then
        return
    end

    local variableName = getName(source)
    local variableValue = fieldNode:simplify():view {
        noFunctionDetail = true,
    }

    local label = '(field) {}: {}' % { variableName, variableValue }

    action.push {
        label = label,
    }
end, 1)
