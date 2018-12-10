local library = require 'matcher.library'

local mt = {}
mt.__index = mt

function mt:isGlobal(var)
    if var.type ~= 'field' then
        return false
    end
    if not var.parent then
        return false
    end
    return var.parent.key == '_ENV' or var.parent.key == '_G'
end

function mt:setType(obj, type)
    if not obj then
        return
    end
    if not obj.group then
        obj.group = {}
    end
    obj.valuetype = type
    obj.group.type = type
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
    if group.type ~= nil then
        return
    end
    group.type = false
    -- 1. 搜索确定类型
    for obj in pairs(group) do
        if obj.valuetype then
            group.type = obj.valuetype
        end
    end
    if group.type then
        return
    end
    -- 2. 推测运算结果
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
end

function mt:searchVar(var)
    if self.lock[var] then
        return
    end
    if not var.group then
        var.group = {}
        var.group[var] = var
    end
    self.lock[var] = true
    self:searchGroup(var.group)
    self.lock[var] = nil

    if not self:getType(var) then
        -- 1. 检查全局lib
        if self:isGlobal(var) then
            local lib = library:get('global', var.key)
            if lib then
                var.lib = lib
                if lib.type then
                    self:setType(var, lib.type)
                    self:searchVar(var)
                    return
                end
            end
        end
        -- 2. 检查索引
        if next(var.childs) then
            self:setType(var, 'table')
            self:searchVar(var)
            return
        end
    end
end

function mt:searchVars(vars)
    for _, var in ipairs(vars) do
        self:searchVar(var)
    end
end

function mt:searchCall(call)
    if call.func then
        if not self:getType(call.func) then
            self:setType(call.func, 'function')
            self:searchVar(call.func)
        end
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
