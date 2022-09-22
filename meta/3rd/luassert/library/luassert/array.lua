---@meta

---@class luassert.array
local array = {}


---Assert that an array has holes in it
---@param length? integer The expected length of the array
---@return integer|nil holeIndex The index of the first found hole or `nil` if there was no hole.
function array.holes(length) end

array.has = array

array.no = array

return array
