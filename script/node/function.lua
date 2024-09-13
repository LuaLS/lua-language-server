---@class Node.Function: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node.Function
local M = ls.node.register 'Node.Function'

M.kind = 'function'

---@class Node.Function.Param
---@field key string
---@field value Node

---@class Node.Function.Return
---@field key? string
---@field value Node

function M:__init()
    ---@type Node.Function.Param[]
    self.params = {}
    ---@type Node.Function.Return[]
    self.returns = {}

    ---@type table<string, Node>
    self.paramMap = {}

    ---@type table<string, Node>
    self.returnMap = {}
end

---@param other Node
---@return boolean?
function M:canBeCast(other)
    if other.typeName == 'function' then
        return true
    end
end

---@param other Node
---@return boolean
function M:isMatch(other)
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

function M:view()
    local params = {}
    for i, v in ipairs(self.params) do
        params[i] = string.format('%s: %s'
            , v.key
            , v.value:view()
        )
    end

    local returns = {}
    for i, v in ipairs(self.returns) do
        returns[i] = v.value:view()
    end

    if #returns > 0 then
        return string.format('fun(%s):%s'
            , table.concat(params, ', ')
            , table.concat(returns, ', ')
        )
    else
        return string.format('fun(%s)'
            , table.concat(params, ', ')
        )
    end
end

function ls.node.func()
    return New 'Node.Function' ()
end
