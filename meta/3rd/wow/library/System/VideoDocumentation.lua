---@meta
C_VideoOptions = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_VideoOptions.GetGxAdapterInfo)
---@return GxAdapterInfoDetails[] adapters
function C_VideoOptions.GetGxAdapterInfo() end

---@class GxAdapterInfoDetails
---@field name string
---@field isLowPower boolean
---@field isExternal boolean
