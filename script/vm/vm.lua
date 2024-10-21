---@class VM
local M = Class 'VM'

---@param scope Scope
function M:__init(scope)
    self.scope = scope
end

---@param scope Scope
---@return VM
function ls.vm.create(scope)
    return New 'VM' (scope)
end

return M
