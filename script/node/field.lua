---@class Node.Field: Node
local M = ls.node.register 'Node.Field'

M.kind = 'field'

---@param scope Scope
---@param key Node.Key
---@param value? Node
function M:__init(scope, key, value)
    self.scope = scope
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = scope.rt.value(key)
    end
    ---@type Node
    self.key = key
    ---@type Node
    self.value = value or scope.rt.UNKNOWN
end

---@param location Node.Location
---@return Node.Field
function M:setLocation(location)
    ---@type Node.Location?
    self.location = location
    return self
end

---@return Node.Field
function M:setHideInView()
    ---@type boolean?
    self.hideInView = true
    return self
end

---@param self Node.Field
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.key:addRef(self)
    self.value:addRef(self)
    return self.key.hasGeneric or self.value.hasGeneric, true
end

function M:inferGeneric(other, result)
    if self.key.hasGeneric then
        -- 仅支持 [K] 这种形式的推导，不支持 [K[]] 等嵌套形式
        if  self.key.kind == 'generic'
        and other.typeOfKey ~= self.scope.rt.NEVER then
            self.key:inferGeneric(other.typeOfKey, result)
            if self.value.hasGeneric then
                self.value:inferGeneric(other:get(self.scope.rt.ANY), result)
            end
        end
    elseif self.value.hasGeneric then
        self.value:inferGeneric(other:get(self.key), result)
    end
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local key = self.key:resolveGeneric(map)
    local value = self.value:resolveGeneric(map)
    local newField = self.scope.rt.field(key, value)
    newField.location = self.location
    newField.hideInView = self.hideInView
    return newField
end
