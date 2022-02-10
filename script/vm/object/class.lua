---@class vm.object.class
local mt = {}
mt.__index = mt

---@return vm.object.class
return function ()
    local class = setmetatable({
    }, mt)
    return class
end
