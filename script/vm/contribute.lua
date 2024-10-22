---@class VM.Contribute
local M = Class 'VM.Contribute'

---@class VM.Contribute.Field
---@field typeName string
---@field field Node.Field

---@alias VM.Contribute.Info VM.Contribute.Field

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    ---@type [string, Node.Field][]
    self.typeFields = {}
end

function M:__del()
    local node = self.scope.node
    node:lockCache()
    for _, data in ipairs(self.typeFields) do
        local typeName, field = data[1], data[2]
        local tp = node.type(typeName)
        tp:removeField(field)
    end
    node:unlockCache()
end

---@param typeName string
---@param field Node.Field
function M:addField(typeName, field)
    local tp = self.scope.node.type(typeName)
    tp:addField(field)
    self.typeFields[#self.typeFields+1] = { typeName, field }
end

function M:remove()
    Delete(self)
end

---@param scope Scope
---@return VM.Contribute
function ls.vm.createContribute(scope)
    return New 'VM.Contribute' (scope)
end
