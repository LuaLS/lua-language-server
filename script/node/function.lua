---@class Node.Function: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope): Node.Function
local M = ls.node.register 'Node.Function'

M.kind = 'function'

---@class Node.Function.Param
---@field key string
---@field value Node

---@class Node.Function.Return
---@field key? string
---@field value Node

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    ---@type Node.Function.Param[]
    self.params = {}
    ---@type Node.Function.Return[]
    self.returns = {}

    ---@type table<string, Node>
    self.paramMap = {}

    ---@type table<string, Node>
    self.returnMap = {}
end

function M:setAsync()
    self.async = true
    return self
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if other.typeName == 'function' then
        return true
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.typeName == 'function' then
        return true
    end
    if other.kind == 'function' then
        ---@cast other Node.Function
        for i, oparam in ipairs(other.params) do
            local param = self:getParam(i)
            if not param then
                return false
            end
            if not param:canCast(oparam.value) then
                return false
            end
        end
        if other.varargParam then
            for i = #other.params + 1, #self.params do
                local param = self:getParam(i)
                if not param then
                    return false
                end
                if not param:canCast(other.varargParam) then
                    return false
                end
            end
            if self.varargParam then
                if not self.varargParam:canCast(other.varargParam) then
                    return false
                end
            end
        end
        for i, oreturn in ipairs(other.returns) do
            local ret = self:getReturn(i)
            if not ret then
                return false
            end
            if not ret:canCast(oreturn.value) then
                return false
            end
        end
        if other.varargReturn then
            for i = #other.returns + 1, #self.returns do
                local ret = self:getReturn(i)
                if not ret then
                    return false
                end
                if not ret:canCast(other.varargReturn) then
                    return false
                end
            end
            if self.varargReturn then
                if not self.varargReturn:canCast(other.varargReturn) then
                    return false
                end
            end
        end
        return true
    end
    return false
end

---@param key string
---@param value Node
---@return Node.Function
function M:addParam(key, value)
    self.params[#self.params+1] = { key = key, value = value }
    self.paramMap[key] = value
    return self
end

---@param key? string
---@param value Node
---@return Node.Function
function M:addReturn(key, value)
    self.returns[#self.returns+1] = { key = key, value = value }
    if key then
        self.returnMap[key] = value
    end
    return self
end

---@param value Node
---@return Node.Function
function M:addVarargParam(value)
    ---@type Node?
    self.varargParam = value
    return self
end

---@param value Node
---@return Node.Function
function M:addVarargReturn(value)
    ---@type Node?
    self.varargReturn = value
    return self
end

---@param index integer
---@return Node?
function M:getParam(index)
    if self.params[index] then
        return self.params[index].value
    end
    if self.varargParam then
        return self.varargParam
    end
    return nil
end

---@param index integer
---@return Node?
function M:getReturn(index)
    if self.returns[index] then
        return self.returns[index].value
    end
    if self.varargReturn then
        return self.varargReturn
    end
    return nil
end

---@param index integer
---@return Node?
function M:getParamFrom(index)
    local nodes = {}
    for i = index, #self.params do
        nodes[#nodes+1] = self.params[i].value
    end
    nodes[#nodes+1] = self.varargParam
    if #nodes == 0 then
        return nil
    end
    if #nodes == 1 then
        return nodes[1]
    end
    return self.scope.node.union(nodes)
end

---@param index integer
---@return Node?
function M:getReturnFrom(index)
    local nodes = {}
    for i = index, #self.returns do
        nodes[#nodes+1] = self.returns[i].value
    end
    nodes[#nodes+1] = self.varargReturn
    if #nodes == 0 then
        return nil
    end
    if #nodes == 1 then
        return nodes[1]
    end
    return self.scope.node.union(nodes)
end

function M:view(skipLevel)
    local params = {}
    for i, v in ipairs(self.params) do
        params[i] = string.format('%s: %s'
            , v.key
            , v.value:view()
        )
    end
    if self.varargParam then
        params[#params+1] = string.format('...: %s', self.varargParam:view())
    end

    local returns = {}
    for i, v in ipairs(self.returns) do
        if v.key then
            returns[i] = string.format('(%s: %s)', v.key, v.value:view())
        else
            returns[i] = v.value:view()
        end
    end
    if self.varargReturn then
        returns[#returns+1] = string.format('(...: %s)', self.varargReturn:view())
    end

    if #returns > 0 then
        local returnPart = table.concat(returns, ', ')
        if #returns > 1 then
            returnPart = '(' .. returnPart .. ')'
        end
        return string.format('%sfun%s(%s):%s'
            , self.async and 'async ' or ''
            , self.genericPack and self.genericPack:view(skipLevel) or ''
            , table.concat(params, ', ')
            , returnPart
        )
    else
        return string.format('%sfun%s(%s)'
            , self.async and 'async ' or ''
            , self.genericPack and self.genericPack:view(skipLevel) or ''
            , table.concat(params, ', ')
        )
    end
end

---@param self Node.Function
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    for _, v in ipairs(self.params) do
        if v.value.hasGeneric then
            return true, true
        end
    end
    for _, v in ipairs(self.returns) do
        if v.value.hasGeneric then
            return true, true
        end
    end
    if self.varargParam and self.varargParam.hasGeneric then
        return true, true
    end
    if self.varargReturn and self.varargReturn.hasGeneric then
        return true, true
    end
    return false, true
end

---@param generics Node.Generic[]
---@return Node.Function
function M:bindGenerics(generics)
    self.genericPack = self.scope.node.genericPack(generics)
    return self
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local newFunc = self.scope.node.func()
    if self.genericPack then
        newFunc.genericPack = self.genericPack:resolve(map)
    end
    for i, param in ipairs(self.params) do
        if param.value.hasGeneric then
            local newValue = param.value:resolveGeneric(map)
            newFunc.params[i] = { key = param.key, value = newValue }
            newFunc.paramMap[param.key] = newValue
        else
            newFunc.params[i] = param
            newFunc.paramMap[param.key] = param.value
        end
    end
    for i, ret in ipairs(self.returns) do
        if ret.value.hasGeneric then
            local newValue = ret.value:resolveGeneric(map)
            newFunc.returns[i] = { key = ret.key, value = newValue }
            if ret.key then
                newFunc.returnMap[ret.key] = newValue
            end
        else
            newFunc.returns[i] = ret
            if ret.key then
                newFunc.returnMap[ret.key] = ret.value
            end
        end
    end
    if self.varargParam then
        if self.varargParam.hasGeneric then
            newFunc.varargParam = self.varargParam:resolveGeneric(map)
        else
            newFunc.varargParam = self.varargParam
        end
    end
    if self.varargReturn then
        if self.varargReturn.hasGeneric then
            newFunc.varargReturn = self.varargReturn:resolveGeneric(map)
        else
            newFunc.varargReturn = self.varargReturn
        end
    end
    return newFunc
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    local value = other.value
    if value.kind == 'union' then
        ---@cast value Node.Union
        for _, sub in ipairs(value.values) do
            self:inferGeneric(sub, result)
        end
        return
    end
    if value.kind ~= 'function' then
        return
    end
    ---@cast value Node.Function
    for i, param in ipairs(self.params) do
        if param.value.hasGeneric then
            local otherParam = value:getParam(i)
            if not otherParam then
                break
            end
            param.value:inferGeneric(otherParam, result)
        end
    end
    for i, ret in ipairs(self.returns) do
        if ret.value.hasGeneric then
            local otherReturn = value:getReturn(i)
            if not otherReturn then
                break
            end
            ret.value:inferGeneric(otherReturn, result)
        end
    end
    if self.varargParam and self.varargParam.hasGeneric then
        local otherParam = value:getParamFrom(#self.params + 1)
        if otherParam then
            self.varargParam:inferGeneric(otherParam, result)
        end
    end
    if self.varargReturn and self.varargReturn.hasGeneric then
        local otherReturn = value:getReturnFrom(#self.returns + 1)
        if otherReturn then
            self.varargReturn:inferGeneric(otherReturn, result)
        end
    end
end
