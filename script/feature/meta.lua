---@meta _

---@alias Range [integer, integer]

---@class Location
---@field uri Uri
---@field range Range
---@field originRange? Range
---@field selectRange? Range # 必须在 `range` 内部
