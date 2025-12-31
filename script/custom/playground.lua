local sandbox = require 'tools.sandbox'

local SharedEnv
local function sharedEnv()
    if not SharedEnv then
        local sb = sandbox('playground')
        sb.env.require = nil
        SharedEnv = sb.env
    end
    return SharedEnv
end

---@class Custom.Playground: GCHost
local M = Class 'Custom.Playground'

Extends(M, 'GCHost')

---@param scope Scope
function M:__init(scope)
    self.scope = scope

    self.env = sharedEnv()

    function self.env.alias(...)
        local alias = ls.custom.alias(self.scope.rt, ...)
        self:bindGC(alias)
        return alias
    end
end

function M:dispose()
    Delete(self)
end

---@param scope Scope
---@return Custom.Playground
function ls.custom.playground(scope)
    return New 'Custom.Playground' (scope)
end
