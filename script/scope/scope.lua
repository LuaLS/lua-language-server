---@class Scope
local M = Class 'Scope'

function M:__init()
    self.node = ls.node.createAPIs(self)
    self.node:fillPresets()
end

---@return Scope
function ls.scope.create()
    return New 'Scope' ()
end
