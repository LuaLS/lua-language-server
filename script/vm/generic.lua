---@class vm.node.generic
---@field parent vm.node.generic-manager
---@field node   vm.node
local mt = {}
mt.__index = mt
mt.type = 'generic'

---@param node     vm.node
---@param resolved table<string, vm.node>
---@return vm.node
local function cloneObject(node, resolved)
    if node.type == 'doc.generic.name' then
        local key = node[1]
        return resolved[key]
    end
    return nil
end

---@param argNodes vm.node[]
---@return parser.object
function mt:resolve(argNodes)
    local resolved = self.parent:resolve(argNodes)
    local newProto = cloneObject(self.node, resolved)
    return newProto
end

---@param parent vm.node.generic-manager
---@param node   vm.node
return function (parent, node)
    local generic = setmetatable({
        parent = parent,
        node   = node,
    }, mt)
    return generic
end
