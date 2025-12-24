---@class Node.Narrow: Node
---@field node Node
---@field narrowType? 'value' | 'field' | 'truly' | 'falsy' | 'equal' | 'param'
---@field nvalue? Node
---@field field? Node.Key
---@field callParams? Node.Narrow.CallParams
local M = ls.node.register 'Node.Narrow'

M.kind = 'narrow'

---@alias Node.Narrow.CallParams [Node, integer, 'equal' | 'match', Node]

---@param scope Scope
---@param node Node
function M:__init(scope, node)
    self.scope = scope
    self.node  = node
end

function M:matchTruly()
    self.narrowType = 'truly'
    return self
end

function M:matchFalsy()
    self.narrowType = 'truly'
    self.isOtherSide = true
    return self
end

---@param value Node
---@return Node.Narrow
function M:matchValue(value)
    self.narrowType = 'value'
    self.nvalue = value
    return self
end

---@param key Node.Key
---@param value Node
---@return Node.Narrow
function M:matchField(key, value)
    self.narrowType = 'field'
    self.field = key
    self.nvalue = value
    return self
end

---@param value Node
---@return Node.Narrow
function M:equalValue(value)
    self.narrowType = 'equal'
    self.nvalue = value
    return self
end

---@param f Node
---@param index integer
---@param mode 'equal' | 'match'
---@param ret Node
---@return self
function M:matchParam(f, index, mode, ret)
    self.narrowType = 'param'
    self.callParams = { f, index, mode, ret }
    return self
end

---@param self Node.Narrow
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.node:addRef(self)
    if self.nvalue then
        self.nvalue:addRef(self)
    end

    return self.node.hasGeneric
        or (self.nvalue and self.nvalue.hasGeneric)
        or false, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local node = self.node:resolveGeneric(map)
    local new = self.scope.rt.narrow(node)
    new.narrowType = self.narrowType
    new.field = self.field
    if self.nvalue then
        new.nvalue = self.nvalue:resolveGeneric(map)
    end
    return new
end

---@type boolean
M.isOtherSide = false

---@param self Node.Narrow
---@return Node
---@return true
M.__getter.value = function (self)
    self.node:addRef(self)
    if self.nvalue then
        self.nvalue:addRef(self)
    end

    local rt = self.scope.rt
    local narrowType = self.narrowType
    local value = self.node
    if self.isOtherSide then
        if narrowType == 'truly' then
            return value.falsy, true
        end
        if narrowType == 'value' then
            local _, otherSide = value:narrow(self.nvalue)
            return otherSide, true
        end
        if narrowType == 'field' then
            local _, otherSide = value:narrowByField(self.field, self.nvalue)
            return otherSide, true
        end
        if narrowType == 'equal' then
            local _, otherSide = value:narrowEqual(self.nvalue)
            return otherSide, true
        end
        if narrowType == 'param' then
            local _, otherSide = self:narrowParam()
            return otherSide, true
        end
        return rt.NEVER, true
    else
        if narrowType == 'truly' then
            return value.truly, true
        end
        if narrowType == 'value' then
            return value:narrow(self.nvalue), true
        end
        if narrowType == 'field' then
            return value:narrowByField(self.field, self.nvalue), true
        end
        if narrowType == 'equal' then
            return value:narrowEqual(self.nvalue), true
        end
        if narrowType == 'param' then
            return self:narrowParam(), true
        end
        return value, true
    end
end

---@return Node.Narrow
function M:otherSide()
    local new = self.scope.rt.narrow(self.node)
    new.narrowType = self.narrowType
    new.field = self.field
    new.nvalue = self.nvalue
    new.callParams = self.callParams
    new.isOtherSide = not self.isOtherSide
    return new
end

---@return Node
---@return Node
function M:narrowParam()
    local func, index, mode, ret = table.unpack(self.callParams)
    func:addRef(self)
    ret:addRef(self)
    ---@type Node.Function[]
    local defs = {}

    func:each('function', function (f)
        ---@cast f Node.Function
        defs[#defs+1] = f
    end)

    local rt = self.scope.rt

    local matches = {}
    local notMatches = {}
    for _, def in ipairs(defs) do
        local res
        local ret1 = def:getReturn(1) or rt.NIL
        if mode == 'match' then
            res = ret1:canCast(ret)
        end
        if mode == 'equal' then
            res = ret1:narrowEqual(ret) ~= rt.NEVER
        end
        if res then
            matches[#matches+1] = def
        else
            notMatches[#notMatches+1] = def
        end
    end

    local function makeParam(funcs)
        local result = {}

        for _, f in ipairs(funcs) do
            result[#result+1] = f:getParam(index)
        end

        return self.scope.rt.union(result)
    end

    return makeParam(matches), makeParam(notMatches)
end
