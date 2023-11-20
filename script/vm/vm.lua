---@class VM
---@overload fun(files: FileManager): self
local M = Class 'VM'

M.version = 0
--是否已经过期
M.outdate = false

---@param files FileManager
function M:__init(files)
    self.files = files
end

return M
