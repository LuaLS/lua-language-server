---@class Node.Narrow: Node
---@field node Node
---@field narrowType? 'value' | 'field' | 'truly' | 'falsy'
---@field nvalue? Node
---@field field? Node.Key
local M = ls.node.register 'Node.Narrow'

M.kind = 'narrow'

---@param scope Scope
---@param node Node
function M:__init(scope, node)
    self.scope = scope
    self.node  = node
end

function M:truly()
    self.narrowType = 'truly'
    return self
end

function M:falsy()
    self.narrowType = 'falsy'
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
        if narrowType == 'falsy' then
            return value.truly, true
        end
        if narrowType == 'value' then
            local _, otherSide = value:narrow(self.nvalue)
            return otherSide, true
        end
        if narrowType == 'field' then
            local _, otherSide = value:narrowByField(self.field, self.nvalue)
            return otherSide, true
        end
        return rt.NEVER, true
    else
        if narrowType == 'truly' then
            return value.truly, true
        end
        if narrowType == 'falsy' then
            return value.falsy, true
        end
        if narrowType == 'value' then
            return value:narrow(self.nvalue), true
        end
        if narrowType == 'field' then
            return value:narrowByField(self.field, self.nvalue), true
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
    new.isOtherSide = true
    return new
end
