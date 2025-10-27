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
---@field optional? boolean

---@class Node.Function.Return
---@field key? string
---@field value Node
---@field optional? boolean

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
        if not other:isMatchedParams(self.paramsDef, self.varargParamDef) then
            return false
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
        return true
    end
    return false
end

---@param params Node[]
---@param varargs Node?
---@return boolean
function M:isMatchedParams(params, varargs)
    for i, oparam in ipairs(params) do
        local param = self:getParam(i)
        if not param then
            break
        end
        if not oparam.value:canCast(param) then
            return false
        end
    end
    for i, param in ipairs(self.paramsDef) do
        local oparam = param
    end
    if varargs then
        for i = #params + 1, #self.paramsDef do
            local param = self:getParam(i)
            if not param then
                break
            end
            if not varargs:canCast(param) then
                return false
            end
        end
        if self.varargParamDef then
            if not varargs:canCast(self.varargParamDef) then
                return false
            end
        end
    else
        local lastOParam = params[#params]
        if lastOParam and lastOParam.kind == 'vararg' then
            ---@cast lastOParam Node.Vararg
            if lastOParam.max then
                -- 第一个上面已经检查过了
                for i = #params + 1, lastOParam.max + #params - 1 do
                    local param = self:getParam(i)
                    if not param then
                        break
                    end
                    local oparam = lastOParam:get(i - #params + 1)
                    if not oparam:canCast(param) then
                        return false
                    end
                end
            else
                for i = #params + 1, math.max(#self.paramsDef, #params + #lastOParam.values - 1) do
                    local param = self:getParam(i)
                    if not param then
                        break
                    end
                    local oparam = lastOParam:get(i - #params + 1)
                    if not oparam:canCast(param) then
                        return false
                    end
                end
                if self.varargParamDef then
                    local oparam = lastOParam:getLastValue()
                    if not oparam:canCast(self.varargParamDef) then
                        return false
                    end
                end
            end
        end
    end
    return true
end

---@param key string
---@param value Node
---@param optional? boolean
---@return Node.Function
function M:addParamDef(key, value, optional)
    if key == '...' then
        self:addVarargParamDef(value)
        return self
    end
    self.paramsDef[#self.paramsDef+1] = { key = key, value = value, optional = optional }
    self.paramDefMap[key] = value
    return self
end

M.returnCount = 0

---@param key? string
---@param value Node
---@param optional? boolean
---@return Node.Function
function M:addReturnDef(key, value, optional)
    self.returnsDef[#self.returnsDef+1] = { key = key, value = value, optional = optional }
    if key then
        self.returnDefMap[key] = value
    end
    if self.returnCount < #self.returnsDef then
        self.returnCount = #self.returnsDef
    end
    return self
end

---@param index integer
---@param node Node
function M:setReturnNode(index, node)
    self.returnNode[index] = self.returnNode[index] | node
    if index > self.returnCount then
        self.returnCount = index
    end
end

---@param value Node
---@return Node.Function
function M:addVarargParamDef(value)
    ---@type Node?
    self.varargParamDef = value
    return self
end

---@param index integer
---@return Node?
function M:getParam(index)
    local paramDef = self.paramsDef[index]
    if paramDef then
        if paramDef.optional then
            return paramDef.value | self.scope.node.NIL
        else
            return paramDef.value
        end
    end
    if self.varargParamDef then
        return self.varargParamDef
    end
    return nil
end

---@param index integer
---@return Node?
function M:getReturn(index)
    local retDef = self.returnsDef[index]
    if retDef then
        if retDef.optional then
            return retDef.value | self.scope.node.NIL
        else
            return retDef.value
        end
    end
    if self.returnNode[index] then
        return self.returnNode[index]
    end
    return nil
end

---@return integer min
---@return integer? max
function M:getReturnCount()
    local count = self.returnCount
    local lastValue = self.returnsDef[count]
                  and self.returnsDef[count].value
                   or self.returnNode[count]
    if not lastValue then
        return 0, 0
    end
    if lastValue.kind == 'vararg' then
        ---@cast lastValue Node.Vararg
        local min = count + lastValue.min
        ---@type integer?
        local max = count
        if lastValue.max then
            max = max + lastValue.max
        else
            max = nil
        end
        return min, max
    end
    return count, count
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
    for i = #self.returnsDef + 1, self.returnCount do
        nodes[#nodes+1] = self.returnNode[i] or self.scope.node.NIL
    end
    if #nodes == 0 then
        return nil
    end
    if #nodes == 1 then
        return nodes[1]
    end
    return self.scope.node.union(nodes)
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
    return false, true
end

---@type Node[]?
M.typeParams = nil

---@param generic Node.Generic
---@return Node.Function
function M:addTypeParam(generic)
    if not self.typeParams then
        self.typeParams = {}
    end
    table.insert(self.typeParams, generic)
    return self
end

---@param args Node[]
---@return table<Node.Generic, Node>
function M:makeGenericMap(args)
    local map = {}
    if not self.typeParams then
        return map
    end
    for i, param in ipairs(self.typeParams) do
        map[param] = args[i] or self.scope.node.UNKNOWN
    end
    return map
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local newFunc = self.scope.node.func()
    if self.typeParams then
        newFunc.typeParams = ls.util.map(self.typeParams, function (v)
            return map[v] or v
        end)
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
    newFunc.returnCount = self.returnCount
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
    if self.typeParams then
        for _, param in ipairs(self.typeParams) do
            if param.kind == 'generic' then
                ---@cast param Node.Generic
                if not result[param] then
                    result[param] = self.scope.node.UNKNOWN
                end
            end
        end
    end
end

function M:onView(viewer, needParentheses)
    if viewer.visited[self] > 1 then
        return 'function'
    end
    local params = {}
    for i, v in ipairs(self.paramsDef) do
        params[i] = string.format('%s%s: %s'
            , v.key
            , v.optional and '?' or ''
            , viewer:view(v.value)
        )
    end
    if self.varargParamDef then
        params[#params+1] = string.format('...: %s', viewer:view(self.varargParamDef))
    end

    local returns = {}
    for i, v in ipairs(self.returnsDef) do
        if v.key then
            returns[i] = string.format('(%s%s: %s)'
                , v.key
                , v.optional and '?' or ''
                , viewer:view(v.value)
            )
        else
            returns[i] = viewer:view(v.value)
        end
    end

    local typeParams = ''
    if self.typeParams and #self.typeParams > 0 then
        typeParams = '<' .. table.concat(ls.util.map(self.typeParams, function (v)
            if v.kind == 'generic' then
                ---@cast v Node.Generic
                return viewer:viewAsParam(v)
            end
            return viewer:view(v)
        end), ', ') .. '>'
    end

    if #returns > 0 then
        local returnPart = table.concat(returns, ', ')
        if #returns > 1 then
            returnPart = '(' .. returnPart .. ')'
        end
        return string.format('%sfun%s(%s):%s'
            , self.async and 'async ' or ''
            , typeParams
            , table.concat(params, ', ')
            , returnPart
        )
    else
        return string.format('%sfun%s(%s)'
            , self.async and 'async ' or ''
            , typeParams
            , table.concat(params, ', ')
        )
    end
end
