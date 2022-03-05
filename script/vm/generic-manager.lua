local createGeneric = require 'vm.generic'

---@class vm.node.generic-manager
---@field parent   parser.object
---@field signList parser.object[]
local mt = {}
mt.__index = mt
mt.type = 'generic-manager'

---@param key parser.object
function mt:addSign(key)
    self.signList[#self.signList+1] = key
end

---@param node vm.node
function mt:getChild(node)
    local generic = createGeneric(self, node)
    return generic
end

---@param argNodes vm.node[]
---@return table<string, vm.node>
function mt:resolve(argNodes)
    local resolved = {}
    for i, node in ipairs(argNodes) do
        local sign = self.signList[i]
        if not sign then
            break
        end
        for _, typeUnit in ipairs(sign.types) do
            if typeUnit.type == 'doc.generic.name' then
                local key = typeUnit[1]
                if not resolved[key] then
                    resolved[key] = node
                end
            end
        end
    end
    return resolved
end

---@return vm.node.generic-manager
return function (parent)
    local genericMgr = setmetatable({
        parent   = parent,
        signList = {},
    }, mt)
    return genericMgr
end
