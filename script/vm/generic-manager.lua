local createGeneric = require 'vm.generic'

---@class vm.node.generic-manager
---@field parent   parser.object
---@field signMap  table<string, vm.node>
---@field signList string[]
local mt = {}
mt.__index = mt
mt.type = 'generic-manager'

---@param key string
function mt:addSign(key)
    self.signList[#self.signList+1] = key
end

---@param proto parser.object
function mt:getChild(proto)
    local generic = createGeneric(self, proto)
    return generic
end

---@return vm.node.generic-manager
return function (parent)
    local genericMgr = setmetatable({
        parent   = parent,
        signMap  = {},
        signList = {},
    }, mt)
    return genericMgr
end
