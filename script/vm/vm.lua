---@class VM
---@overload fun(): self
local M = Class 'VM'

---版本
M.version = 0
---是否已经过期
M.outdate = false

function M:__init()
end

---@return VM
function ls.vm.create()
    return New 'VM' ()
end

return M
