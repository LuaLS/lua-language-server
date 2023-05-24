---@class SUnion
---@overload fun(...: SNode): self
---@field [integer] SNode
local Union = Class 'SUnion'

---@param ... SNode
function Union:__call(...)
    return self
end
