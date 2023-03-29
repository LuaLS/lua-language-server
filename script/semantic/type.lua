---@class Type
---@overload fun(name: string):Type
---@field package name string
local Type = C.class 'Type'

---@param name string
function Type:__call(name)
    self.name = name
    return self
end

---@return string
function Type:getName()
    return self.name
end
