---@meta _

---@class Range
---@field [1] integer # start offset
---@field [2] integer # end offset

---@class Location
---@field uri Uri
---@field range Range
---@field originRange? Range
---@field selectRange? Range # 必须在 `range` 内部
