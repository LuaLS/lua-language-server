local state = require 'vm.state'

---@class vm.node.union
local mt = {}
mt.__index = mt
mt.type = 'union'

---@param source parser.object
---@param node   vm.node
function mt:merge(source, node)
    if not node then
        return
    end
    if node.type == 'union' then
        for _, c in ipairs(node) do
            self[#self+1] = c
        end
    else
        self[#self+1] = node
    end
end

---@param source parser.object
function mt:subscribeLiteral(source)
    for _, c in ipairs(self) do
        state.subscribeLiteral(source, c)
        if c.type == 'cross' then
            c:subscribeLiteral(source)
        end
    end
end

---@param source parser.object
---@param node vm.node
---@return vm.node.union
return function (source, node)
    local union = setmetatable({
        source,
    }, mt)
    union:merge(source, node)
    return union
end
