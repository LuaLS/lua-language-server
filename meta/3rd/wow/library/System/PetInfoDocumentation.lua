---@meta
C_PetInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetInfo.GetPetTamersForMap)
---@param uiMapID number
---@return PetTamerMapInfo[] petTamers
function C_PetInfo.GetPetTamersForMap(uiMapID) end

---@class PetTamerMapInfo
---@field areaPoiID number
---@field position Vector2DMixin
---@field name string
---@field atlasName string|nil
---@field textureIndex number|nil
