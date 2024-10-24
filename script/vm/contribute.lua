---@class VM.Contribute
local M = Class 'VM.Contribute'

---@class VM.Contribute.Global
---@field kind 'global'
---@field field Node.Field
---@field path? (string | number | boolean)[]

---@class VM.Contribute.Field
---@field kind 'field'
---@field typeName string
---@field field Node.Field

---@alias VM.Contribute.Action VM.Contribute.Global | VM.Contribute.Field

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    ---@type VM.Contribute.Action[]
    self.history = {}
end

function M:__del()
    local node = self.scope.node
    node:lockCache()
    for _, commit in ipairs(self.history) do
        self:revert(commit)
    end
    node:unlockCache()
end

---@param action VM.Contribute.Action
function M:commit(action)
    local kind = action.kind
    if kind == 'field' then
        ---@cast action VM.Contribute.Field
        local tp = self.scope.node.type(action.typeName)
        tp:addField(action.field)
    elseif kind == 'global' then
        ---@cast action VM.Contribute.Global
        self.scope.node:globalAdd(action.field, action.path)
    end
    self.history[#self.history+1] = action
end

---@param action VM.Contribute.Action
function M:revert(action)
    local kind = action.kind
    if kind == 'field' then
        ---@cast action VM.Contribute.Field
        local tp = self.scope.node.type(action.typeName)
        tp:removeField(action.field)
    elseif kind == 'global' then
        ---@cast action VM.Contribute.Global
        self.scope.node:globalRemove(action.field, action.path)
    end
end

---@param actions VM.Contribute.Action[]
function M:commitActions(actions)
    local node = self.scope.node
    node:lockCache()
    for _, action in ipairs(actions) do
        self:commit(action)
    end
    node:unlockCache()
end

function M:remove()
    Delete(self)
end

---@param scope Scope
---@return VM.Contribute
function ls.vm.createContribute(scope)
    return New 'VM.Contribute' (scope)
end
