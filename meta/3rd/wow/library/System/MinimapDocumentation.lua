---@meta
C_Minimap = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.GetDrawGroundTextures)
---@return boolean draw
function C_Minimap.GetDrawGroundTextures() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.GetUiMapID)
---@return number? uiMapID
function C_Minimap.GetUiMapID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.GetViewRadius)
---@return number yards
function C_Minimap.GetViewRadius() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.IsRotateMinimapIgnored)
---@return boolean isIgnored
function C_Minimap.IsRotateMinimapIgnored() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.SetDrawGroundTextures)
---@param draw boolean
function C_Minimap.SetDrawGroundTextures(draw) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.SetIgnoreRotateMinimap)
---@param ignore boolean
function C_Minimap.SetIgnoreRotateMinimap(ignore) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Minimap.ShouldUseHybridMinimap)
---@return boolean shouldUse
function C_Minimap.ShouldUseHybridMinimap() end
