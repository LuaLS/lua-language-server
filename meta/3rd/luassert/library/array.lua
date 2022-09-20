---@meta

---@class luassert.arrayAssert
local array = {}

array.has = {}

array.has.no = {}

---Assert that an array has holes in it
---@param length? integer The expected length of the array
---@return integer|nil holeIndex The index of the first found hole or `nil` if there was no hole.
function array.has.holes(length) end

---Assert that an array has no holes in it
---@param length? integer The expected length of the array
---@return integer|nil holeIndex The index of the first found hole or `nil` if there was no hole.
function array.has.no.holes(length) end

return array
