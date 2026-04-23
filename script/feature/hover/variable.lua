---@param variable Node.Variable
---@param source LuaParser.Node.Base
---@return 'local' | 'global' | 'field' | 'method' | 'parameter' | 'self'
local function getVariableType(variable, source)
    local kind = source.kind

    if kind == 'local' then
        return 'local'
    end

    if kind == 'param' then
        if variable:isSelfLike() then
            return 'self'
        end
        return 'parameter'
    end

    if kind == 'var' then
        ---@cast source LuaParser.Node.Var
        if source.subtype == 'global' then
            return 'global'
        end
        local loc = source.loc
        if loc and loc.kind == 'param' then
            if variable:isSelfLike() then
                return 'self'
            end
            return 'parameter'
        end
        return 'local'
    end

    if kind == 'field' then
        ---@cast source LuaParser.Node.Field
        if source.subtype == 'method' then
            return 'method'
        end
        return 'field'
    end

    return 'local'
end

---@param variable Node.Variable
---@return string
local function getVariableName(variable)
    local literal = variable.key.literal
    if type(literal) == 'string' then
        return literal
    end
    return tostring(literal)
end

ls.feature.provider.hover(function (param, action)
    local variable = param.vm:getVariable(param.source)
    if not variable then
        return
    end
    local variableType = getVariableType(variable, param.source)
    local varibaleName = getVariableName(variable)
    local variableValue = variable:view()

    local md = ls.tools.markdown.create()

    local label = '{} {}: {}' % { variableType, varibaleName, variableValue }

    action.push {
        label = label,
    }
end)
