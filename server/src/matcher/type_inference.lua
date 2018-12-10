local mt = {}
mt.__index = mt

function mt:setType(obj, type)
    if not obj then
        return
    end
    if not obj.group then
        obj.group = {
            type = type,
        }
    end
    obj.valuetype = type
end

function mt:getType(obj)
    if not obj then
        return nil
    end
    if obj.valuetype then
        return obj.valuetype
    end
    if obj.group then
        return obj.group.type
    end
    return nil
end

function mt:getUnaryType(obj)
    if obj.op == 'not' then
        return 'boolean'
    elseif obj.op == '#' then
        return 'integer'
    elseif obj.op == '-' then
        return 'number'
    elseif obj.op == '~' then
        return 'integer'
    end
    return nil
end

function mt:getBinaryType(obj)
    if     obj.op == 'or'
        or obj.op == 'and'
        or obj.op == '<='
        or obj.op == '>='
        or obj.op == '<'
        or obj.op == '>'
        or obj.op == '~='
        or obj.op == '=='
    then
        return 'boolean'
    elseif obj.op == '|'
        or obj.op == '~'
        or obj.op == '&'
        or obj.op == '<<'
        or obj.op == '>>'
        or obj.op == '//'
    then
        return 'integer'
    elseif obj.op == '..' then
        return 'string'
    elseif obj.op == '+'
        or obj.op == '-'
        or obj.op == '*'
        or obj.op == '/'
        or obj.op == '^'
        or obj.op == '%'
    then
        return 'number'
    end
    return nil
end

function mt:searchGroup(group)
    if not group then
        return
    end
    if group.type ~= nil then
        return
    end
    for obj in pairs(group) do
        if obj.valuetype then
            group.type = obj.valuetype
            return
        end
    end
    for obj in pairs(group) do
        -- TODO 搜索metatable
        if obj.type == 'unary' then
            local type = self:getUnaryType(obj)
            if type then
                group.type = type
                return
            end
        elseif obj.type == 'binary' then
            local type = self:getBinaryType(obj)
            if type then
                group.type = type
                return
            end
        end
    end
    group.type = false
end

function mt:searchVar(var)
    if var.valuetype then
        return
    end
    if self.lock[var] then
        return
    end
    self.lock[var] = true
    self:searchGroup(var.group)
    self.lock[var] = nil
    if not self:getType(var) and next(var.childs) then
        self:setType(var, 'table')
        return
    end
end

function mt:searchVars(vars)
    for _, var in ipairs(vars) do
        self:searchVar(var)
    end
end

function mt:searchCall(call)
    if not self:getType(call.func) then
        self:setType(call.func, 'function')
    end
end

function mt:searchCalls(calls)
    for _, call in ipairs(calls) do
        self:searchCall(call)
    end
end

return function (results)
    local session = setmetatable({
        lock = {},
    }, mt)
    session:searchVars(results.vars)
    session:searchCalls(results.calls)
end
