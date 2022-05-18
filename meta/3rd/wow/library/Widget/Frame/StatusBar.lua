---@meta
---@class StatusBar : Frame
local StatusBar = {}

---@param scriptType ScriptStatusBar
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return function handler
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_GetScript)
function StatusBar:GetScript(scriptType, bindingType) end

---@param scriptType ScriptStatusBar
---@return boolean hasScript
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HasScript)
function StatusBar:HasScript(scriptType) end

---@param scriptType ScriptStatusBar
---@param handler function
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return boolean success
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HookScript)
function StatusBar:HookScript(scriptType, handler, bindingType) end

---@param scriptType ScriptStatusBar
---@param handler function
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_SetScript)
function StatusBar:SetScript(scriptType, handler) end


---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetFillStyle)
function StatusBar:GetFillStyle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetMinMaxValues)
function StatusBar:GetMinMaxValues() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetOrientation)
function StatusBar:GetOrientation() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetReverseFill)
function StatusBar:GetReverseFill() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetRotatesTexture)
function StatusBar:GetRotatesTexture() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetStatusBarAtlas)
function StatusBar:GetStatusBarAtlas() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetStatusBarColor)
function StatusBar:GetStatusBarColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetStatusBarTexture)
function StatusBar:GetStatusBarTexture() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_GetValue)
function StatusBar:GetValue() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetFillStyle)
function StatusBar:SetFillStyle(style) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetMinMaxValues)
function StatusBar:SetMinMaxValues(min, max) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetOrientation)
function StatusBar:SetOrientation(orientation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetReverseFill)
function StatusBar:SetReverseFill(state) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetRotatesTexture)
function StatusBar:SetRotatesTexture() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetStatusBarAtlas)
function StatusBar:SetStatusBarAtlas(atlasName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetStatusBarColor)
function StatusBar:SetStatusBarColor(r, g, b, alpha) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetStatusBarTexture)
function StatusBar:SetStatusBarTexture(texture_or_fileDataIDbool, layer, subLayer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StatusBar_SetValue)
function StatusBar:SetValue(value) end