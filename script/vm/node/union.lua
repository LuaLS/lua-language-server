local literalMgr = require 'vm.literal-manager'

---@class vm.node.union
local mt = {}
mt.__index = mt
mt.type = 'union'

---@param node   vm.node
function mt:merge(node)
    if not node then
        return
    end
    if node.type == 'union' then
        for _, c in ipairs(node) do
            if not self[c] then
                self[c]       = true
                self[#self+1] = c
            end
        end
    else
        if not self[node] then
            self[node]    = true
            self[#self+1] = node
        end
    end
end

---@param source parser.object
function mt:subscribeLiteral(source)
    for _, c in ipairs(self) do
        literalMgr.subscribeLiteral(source, c)
        if c.type == 'cross' then
            c:subscribeLiteral(source)
        end
    end
end

function mt:eachNode()
    local i = 0
    return function ()
        i = i + 1
        return self[i]
    end
end

---@param me   parser.object
---@param node vm.node
---@return vm.node.union
return function (me, node)
    local union = setmetatable({
        [1] = me,
    }, mt)
    union:merge(node)
    return union
end
