---@meta
C_Texture = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Texture.GetAtlasInfo)
---@param atlas string
---@return AtlasInfo info
function C_Texture.GetAtlasInfo(atlas) end

---@class AtlasInfo
---@field width number
---@field height number
---@field leftTexCoord number
---@field rightTexCoord number
---@field topTexCoord number
---@field bottomTexCoord number
---@field tilesHorizontally boolean
---@field tilesVertically boolean
---@field file number|nil
---@field filename string|nil
