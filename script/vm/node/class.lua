---@class vm.node.class
local mt = {}
mt.__index = mt
mt.type = 'class'

---@return vm.node.class
return function ()
    local class = setmetatable({
    }, mt)
    return class
end
