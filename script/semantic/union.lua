---@class SUnion
---@overload fun(a: SNode, b: SNode): self
---@field package sub1 SNode
---@field package sub2 SNode
local Union = Class 'SUnion'

---@param a SNode
---@param b SNode
function Union:__call(a, b)
    self.sub1 = a
    self.sub2 = b
    return self
end
