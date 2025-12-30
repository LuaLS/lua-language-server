---@class Custom.Alias
local M = Class 'Custom.Alias'

---@param rt Node.Runtime
---@param name string
function M:__init(rt, name)
    self.rt = rt
    self.name  = name

    self.alias = rt.alias(name)
end

---@param name string
function M:param(name)
    local p = self.rt.generic(name)
    self.alias:addTypeParam(p)
end

---@param callback fun(c: Custom.Context): Node
function M:onValue(callback)
    self.alias:setCustomValue(function (_, args)
        local cargs = {}
        for i, param in ipairs(self.alias.params) do
            cargs[i] = args[i] or self.rt.NEVER
            cargs[param.name] = cargs[i]
        end
        local master = ls.custom.contextMaster(self.rt, {
            args = args,
        })
        local node = master:call(callback)
        return node
    end)
end

---@param rt Node.Runtime
---@param name string
---@return Custom.Alias
function ls.custom.alias(rt, name)
    return New 'Custom.Alias' (rt, name)
end
