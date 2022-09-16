---@meta

---@class luassert_mock
---@generic T
---@param object T
---@param dostub? boolean @will never call original function
---@param func? any
---@param target_objcet? any
---@param key? any
---@return T
local mock = function(object, dostub, func, target_objcet, key)
end

---@generic T
---@param object T
---@param dostub? boolean @will never call original function
---@param func? any
---@param target_objcet? any
---@param key? any
---@return T
function mock.new(object, dostub, func, target_objcet, key)
end


---@param object any
function mock.clear(object)
end


---@param object any
function mock.revert(object)
end

return mock
