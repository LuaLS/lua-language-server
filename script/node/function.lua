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
    self.paramsDef = {}
    ---@type Node.Function.Return[]
    self.returnsDef = {}
    ---@type Node[]
    self.returnNode = {}

    ---@type table<string, Node>
    self.paramDefMap = {}

    ---@type table<string, Node>
    self.returnDefMap = {}
end

function M:setAsync()
    self.async = true
    return self
end

---@param location Node.Location
---@return Node.Function
function M:setLocation(location)
    self.location = location
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
        for i, oparam in ipairs(other.paramsDef) do
            local param = self:getParam(i)
            if not param then
                return false
            end
            if not param:canCast(oparam.value) then
                return false
            end
        end
        if other.varargParamDef then
            for i = #other.paramsDef + 1, #self.paramsDef do
                local param = self:getParam(i)
                if not param then
                    return false
                end
                if not param:canCast(other.varargParamDef) then
                    return false
                end
            end
            if self.varargParamDef then
                if not self.varargParamDef:canCast(other.varargParamDef) then
                    return false
                end
            end
        end
        for i, oreturn in ipairs(other.returnsDef) do
            local ret = self:getReturn(i)
            if not ret then
                return false
            end
            if not ret:canCast(oreturn.value) then
                return false
            end
        end
        if other.varargReturnDef then
            for i = #other.returnsDef + 1, #self.returnsDef do
                local ret = self:getReturn(i)
                if not ret then
                    return false
                end
                if not ret:canCast(other.varargReturnDef) then
                    return false
                end
            end
            if self.varargReturnDef then
                if not self.varargReturnDef:canCast(other.varargReturnDef) then
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
function M:addParamDef(key, value)
    self.paramsDef[#self.paramsDef+1] = { key = key, value = value }
    self.paramDefMap[key] = value
    return self
end

---@param key? string
---@param value Node
---@return Node.Function
function M:addReturnDef(key, value)
    self.returnsDef[#self.returnsDef+1] = { key = key, value = value }
    if key then
        self.returnDefMap[key] = value
    end
    return self
end

M.returnNodeMax = 0

---@param index integer
---@param node Node
function M:setReturnNode(index, node)
    self.returnNode[index] = self.returnNode[index] | node
    if index > self.returnNodeMax then
        self.returnNodeMax = index
    end
end

---@param value Node
---@return Node.Function
function M:addVarargParamDef(value)
    ---@type Node?
    self.varargParamDef = value
    return self
end

---@param value Node
---@return Node.Function
function M:addVarargReturnDef(value)
    ---@type Node?
    self.varargReturnDef = value
    return self
end

---@param node Node
function M:setVarargReturnNode(node)
    ---@type Node?
    self.varargReturnNode = node
end

---@param index integer
---@return Node?
function M:getParam(index)
    if self.paramsDef[index] then
        return self.paramsDef[index].value
    end
    if self.varargParamDef then
        return self.varargParamDef
    end
    return nil
end

---@param index integer
---@return Node?
function M:getReturn(index)
    if self.returnsDef[index] then
        return self.returnsDef[index].value
    end
    if self.returnNode[index] then
        return self.returnNode[index]
    end
    if self.varargReturnDef then
        return self.varargReturnDef
    end
    if self.varargReturnNode then
        return self.varargReturnNode
    end
    return nil
end

---@param index integer
---@return Node?
function M:getParamStartFrom(index)
    local nodes = {}
    for i = index, #self.paramsDef do
        nodes[#nodes+1] = self.paramsDef[i].value
    end
    nodes[#nodes+1] = self.varargParamDef
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
function M:getReturnStartFrom(index)
    local nodes = {}
    for i = index, #self.returnsDef do
        nodes[#nodes+1] = self.returnsDef[i].value
    end
    if self.varargReturnDef then
        nodes[#nodes+1] = self.varargReturnDef
    else
        for i = #self.returnsDef + 1, self.returnNodeMax do
            nodes[#nodes+1] = self.returnNode[i] or self.scope.node.NIL
        end
    end
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
    for i, v in ipairs(self.paramsDef) do
        params[i] = string.format('%s: %s'
            , v.key
            , v.value:view()
        )
    end
    if self.varargParamDef then
        params[#params+1] = string.format('...: %s', self.varargParamDef:view())
    end

    local returns = {}
    for i, v in ipairs(self.returnsDef) do
        if v.key then
            returns[i] = string.format('(%s: %s)', v.key, v.value:view())
        else
            returns[i] = v.value:view()
        end
    end
    if self.varargReturnDef then
        returns[#returns+1] = string.format('(...: %s)', self.varargReturnDef:view())
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
    for _, v in ipairs(self.paramsDef) do
        if v.value.hasGeneric then
            return true, true
        end
    end
    for _, v in ipairs(self.returnsDef) do
        if v.value.hasGeneric then
            return true, true
        end
    end
    if self.varargParamDef and self.varargParamDef.hasGeneric then
        return true, true
    end
    if self.varargReturnDef and self.varargReturnDef.hasGeneric then
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
    for i, param in ipairs(self.paramsDef) do
        if param.value.hasGeneric then
            local newValue = param.value:resolveGeneric(map)
            newFunc.paramsDef[i] = { key = param.key, value = newValue }
            newFunc.paramDefMap[param.key] = newValue
        else
            newFunc.paramsDef[i] = param
            newFunc.paramDefMap[param.key] = param.value
        end
    end
    for i, ret in ipairs(self.returnsDef) do
        if ret.value.hasGeneric then
            local newValue = ret.value:resolveGeneric(map)
            newFunc.returnsDef[i] = { key = ret.key, value = newValue }
            if ret.key then
                newFunc.returnDefMap[ret.key] = newValue
            end
        else
            newFunc.returnsDef[i] = ret
            if ret.key then
                newFunc.returnDefMap[ret.key] = ret.value
            end
        end
    end
    if self.varargParamDef then
        if self.varargParamDef.hasGeneric then
            newFunc.varargParamDef = self.varargParamDef:resolveGeneric(map)
        else
            newFunc.varargParamDef = self.varargParamDef
        end
    end
    if self.varargReturnDef then
        if self.varargReturnDef.hasGeneric then
            newFunc.varargReturnDef = self.varargReturnDef:resolveGeneric(map)
        else
            newFunc.varargReturnDef = self.varargReturnDef
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
    for i, param in ipairs(self.paramsDef) do
        if param.value.hasGeneric then
            local otherParam = value:getParam(i)
            if not otherParam then
                break
            end
            param.value:inferGeneric(otherParam, result)
        end
    end
    for i, ret in ipairs(self.returnsDef) do
        if ret.value.hasGeneric then
            local otherReturn = value:getReturn(i)
            if not otherReturn then
                break
            end
            ret.value:inferGeneric(otherReturn, result)
        end
    end
    if self.varargParamDef and self.varargParamDef.hasGeneric then
        local otherParam = value:getParamStartFrom(#self.paramsDef + 1)
        if otherParam then
            self.varargParamDef:inferGeneric(otherParam, result)
        end
    end
    if self.varargReturnDef and self.varargReturnDef.hasGeneric then
        local otherReturn = value:getReturnStartFrom(#self.returnsDef + 1)
        if otherReturn then
            self.varargReturnDef:inferGeneric(otherReturn, result)
        end
    end
end
