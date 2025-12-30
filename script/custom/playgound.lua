local sandbox = require 'tools.sandbox'

---@class Custom.Playground
local M = Class 'Custom.Playground'

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    local sb = sandbox('playground')
    sb.env.require = nil

    self.env = sb.env

    self:fillAPIs(self.env)
end

function M:fillAPIs(env)
    function env.alias(...)
        return ls.custom.alias(self.scope.rt, ...)
    end
end

---@param scope Scope
---@return Custom.Playground
function ls.custom.playground(scope)
    return New 'Custom.Playground' (scope)
end
