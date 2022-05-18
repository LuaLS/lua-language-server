---@meta
---[Documentation](https://www.wowace.com/projects/libstub)
LibStub = {}

---@param major string
---@param minor number
function LibStub:NewLibrary(major, minor) end

---@generic T
---@param major `T`
---@param silent? boolean
---@return T library
function LibStub:GetLibrary(major, silent) end

---@return function iter
---@return table invariant
function LibStub:IterateLibraries() end

-- not sure how to annotate this in emmylua
--setmetatable(LibStub, { __call = LibStub.GetLibrary })

---@generic T
---@param major `T`
---@param silent? boolean
---@return T library
function LibStub(major, silent) end
