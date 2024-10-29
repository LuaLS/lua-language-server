---@class VM.Contribute
local M = Class 'VM.Contribute'

---@class VM.Contribute.Global
---@field kind 'global'
---@field field Node.Field
---@field path? Node.Key[]

---@class VM.Contribute.Class
---@field kind 'class'
---@field name string
---@field location? Node.Location

---@class VM.Contribute.ClassField
---@field kind 'classfield'
---@field className string
---@field field Node.Field

---@class VM.Contribute.Alias
---@field kind 'alias'
---@field name string
---@field value Node
---@field location? Node.Location


---@alias VM.Contribute.Action
---| VM.Contribute.Global
---| VM.Contribute.Class
---| VM.Contribute.ClassField
---| VM.Contribute.Alias

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
    if kind == 'classfield' then
        ---@cast action VM.Contribute.ClassField
        local tp = self.scope.node.type(action.className)
        tp:addField(action.field)
    elseif kind == 'global' then
        ---@cast action VM.Contribute.Global
        self.scope.node:globalAdd(action.field, action.path)
    elseif kind == 'class' then
        ---@cast action VM.Contribute.Class
        self.scope.node.type(action.name):addClass(action.location)
    elseif kind == 'alias' then
        ---@cast action VM.Contribute.Alias
        self.scope.node.type(action.name):addAlias(action.value, action.location)
    end
    self.history[#self.history+1] = action
end

---@param action VM.Contribute.Action
function M:revert(action)
    local kind = action.kind
    if kind == 'classfield' then
        ---@cast action VM.Contribute.ClassField
        local tp = self.scope.node.type(action.className)
        tp:removeField(action.field)
    elseif kind == 'global' then
        ---@cast action VM.Contribute.Global
        self.scope.node:globalRemove(action.field, action.path)
    elseif kind == 'class' then
        ---@cast action VM.Contribute.Class
        self.scope.node.type(action.name):removeClass(action.location)
    elseif kind == 'alias' then
        ---@cast action VM.Contribute.Alias
        self.scope.node.type(action.name):removeAlias(action.value, action.location)
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
