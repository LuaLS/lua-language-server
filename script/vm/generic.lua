---@class vm.node.generic
---@field parent vm.node.generic-manager
---@field proto  parser.object
local mt = {}
mt.__index = mt
mt.type = 'generic'

---@param parent vm.node.generic-manager
---@param proto  parser.object
return function (parent, proto)
    local generic = setmetatable({
        parent   = parent,
        proto    = proto,
    }, mt)
    return generic
end
