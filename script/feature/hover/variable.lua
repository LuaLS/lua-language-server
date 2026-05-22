---@param variable Node.Variable
---@param source LuaParser.Node.Base
---@return 'local' | 'global' | '(field)' | '(method)' | '(parameter)' | '(self)' | '(upvalue)'
local function getVariableType(variable, source)
    local kind = source.kind

    if kind == 'local' then
        return 'local'
    end

    if kind == 'param' then
        if variable:isSelfLike() then
            return '(self)'
        end
        return '(parameter)'
    end

    if variable:isGlobal() then
        return 'global'
    end

    if kind == 'var' then
        ---@cast source LuaParser.Node.Var
        if source.subtype == 'global' then
            return 'global'
        end
        local loc = source.loc
        if loc then
            if loc.kind == 'param' then
                ---@cast loc LuaParser.Node.Param
                if loc.isSelf then
                    return '(self)'
                end
                return '(parameter)'
            end
            -- upvalue: 变量声明所在的函数与使用处所在的函数不同
            -- 当 loc.parent == loc.referFunction 时（即 local function x()），
            -- 声明的作用域是该函数的外层
            local locRef = loc.referFunction
            local declFunc
            if locRef and loc.parent == locRef then
                declFunc = locRef.parentFunction
            else
                declFunc = locRef
            end
            if source.parentFunction ~= declFunc then
                return '(upvalue)'
            end
        end
        return 'local'
    end

    if kind == 'fieldid' then
        ---@cast source LuaParser.Node.FieldID
        local field = source.parent
        if field.subtype == 'method' then
            return '(method)'
        end
        return '(field)'
    end

    return 'local'
end

---@param variable Node.Variable
---@return string
local function getVariableName(variable)
    return variable:viewAsVariable()
end

ls.feature.provider.hover(function (param, action)
    local variable = param.vm:getVariable(param.source)
    if not variable then
        return
    end
    local variableType = getVariableType(variable, param.source)
    local varibaleName = getVariableName(variable)
    local variableValue = variable:view {
        noFunctionDetail = true,
    }

    local label = '{} {}: {}' % { variableType, varibaleName, variableValue }

    action.push {
        label = label,
    }
end)
