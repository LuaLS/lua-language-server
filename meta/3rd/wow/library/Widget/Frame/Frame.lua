---@meta
---@class Frame : Region, ScriptObject
local Frame = {}

---@param scriptType ScriptFrame
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return function handler
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_GetScript)
function Frame:GetScript(scriptType, bindingType) end

---@param scriptType ScriptFrame
---@return boolean hasScript
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HasScript)
function Frame:HasScript(scriptType) end

---@param scriptType ScriptFrame
---@param handler function
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return boolean success
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HookScript)
function Frame:HookScript(scriptType, handler, bindingType) end

---@param scriptType ScriptFrame
---@param handler function
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_SetScript)
function Frame:SetScript(scriptType, handler) end


---@param event WowEvent
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_RegisterEvent)
function Frame:RegisterEvent(event) end

---@param event WowEvent
---@param unit1 WowUnit
---@param unit2 WowUnit
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_RegisterUnitEvent)
function Frame:RegisterUnitEvent(event, unit1, unit2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_RegisterAllEvents)
function Frame:RegisterAllEvents() end

---@param event WowEvent
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_UnregisterEvent)
function Frame:UnregisterEvent(event) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_UnregisterAllEvents)
function Frame:UnregisterAllEvents() end

---@param event WowEvent
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsEventRegistered)
function Frame:IsEventRegistered(event) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_DesaturateHierarchy)
function Frame:DesaturateHierarchy(desaturation) end

---@param layer DrawLayer
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_DisableDrawLayer)
function Frame:DisableDrawLayer(layer) end

---@param layer DrawLayer
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_EnableDrawLayer)
function Frame:EnableDrawLayer(layer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetBoundsRect)
function Frame:GetBoundsRect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetClampRectInsets)
function Frame:GetClampRectInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetDepth)
function Frame:GetDepth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetDontSavePosition)
function Frame:GetDontSavePosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetEffectiveAlpha)
function Frame:GetEffectiveAlpha() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetEffectiveDepth)
function Frame:GetEffectiveDepth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetEffectivelyFlattensRenderLayers)
function Frame:GetEffectivelyFlattensRenderLayers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetFlattensRenderLayers)
function Frame:GetFlattensRenderLayers() end

---@return number level
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetFrameLevel)
function Frame:GetFrameLevel() end

---@return FrameStrata strata
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetFrameStrata)
function Frame:GetFrameStrata() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetHitRectInsets)
function Frame:GetHitRectInsets(l, r, t, b) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetMaxResize)
function Frame:GetMaxResize(w, h) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetMinResize)
function Frame:GetMinResize(w, h) end

---@return boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_HasFixedFrameLevel)
function Frame:HasFixedFrameLevel() end

---@return boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_HasFixedFrameStrata)
function Frame:HasFixedFrameStrata() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IgnoreDepth)
function Frame:IgnoreDepth(ignoreFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsClampedToScreen)
function Frame:IsClampedToScreen() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsIgnoringDepth)
function Frame:IsIgnoringDepth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsToplevel)
function Frame:IsToplevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_Lower)
function Frame:Lower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_Raise)
function Frame:Raise() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_RotateTextures)
function Frame:RotateTextures(angleRadians, pivotX, pivotY) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetClampedToScreen)
function Frame:SetClampedToScreen(clamped) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetClampRectInsets)
function Frame:SetClampRectInsets(left, right, top, bottom) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetDepth)
function Frame:SetDepth(depth) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetDontSavePosition)
function Frame:SetDontSavePosition() end

---@param layer DrawLayer
---@param mouseOver boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetDrawLayerEnabled)
function Frame:SetDrawLayerEnabled(layer, mouseOver) end

---@param bool boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetFixedFrameLevel)
function Frame:SetFixedFrameLevel(bool) end

---@param bool boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetFixedFrameStrata)
function Frame:SetFixedFrameStrata(bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetFlattensRenderLayers)
function Frame:SetFlattensRenderLayers() end

---@param level number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetFrameLevel)
function Frame:SetFrameLevel(level) end

---@param strata FrameStrata
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetFrameStrata)
function Frame:SetFrameStrata(strata) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetHitRectInsets)
function Frame:SetHitRectInsets(left, right, top, bottom) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetMaxResize)
function Frame:SetMaxResize(maxWidth, maxHeight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetMinResize)
function Frame:SetMinResize(minWidth, minHeight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetToplevel)
function Frame:SetToplevel(isTopLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetChildren)
function Frame:GetChildren() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetNumChildren)
function Frame:GetNumChildren() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_DoesClipChildren)
function Frame:DoesClipChildren() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetClipsChildren)
function Frame:SetClipsChildren(clipped) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetNumRegions)
function Frame:GetNumRegions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetRegions)
function Frame:GetRegions() end

---@param name string
---@param layer string
---@param template string
---@param subLayer number
---@return FontString fontString
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_CreateFontString)
function Frame:CreateFontString(name, layer, template, subLayer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_CreateMaskTexture)
function Frame:CreateMaskTexture() end

---@param name string
---@param layer string
---@param template string
---@param subLayer number
---@return Texture texture
---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_CreateTexture)
function Frame:CreateTexture(name, layer, template, subLayer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_EnableKeyboard)
function Frame:EnableKeyboard(enableFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_EnableMouse)
function Frame:EnableMouse(enableFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_EnableMouseWheel)
function Frame:EnableMouseWheel(enableFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetHyperlinksEnabled)
function Frame:GetHyperlinksEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetPropagateKeyboardInput)
function Frame:GetPropagateKeyboardInput() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsKeyboardEnabled)
function Frame:IsKeyboardEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsMouseClickEnabled)
function Frame:IsMouseClickEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsMouseEnabled)
function Frame:IsMouseEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsMouseMotionEnabled)
function Frame:IsMouseMotionEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsMouseWheelEnabled)
function Frame:IsMouseWheelEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsMovable)
function Frame:IsMovable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsResizable)
function Frame:IsResizable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsUserPlaced)
function Frame:IsUserPlaced() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_RegisterForDrag)
function Frame:RegisterForDrag(buttonType,buttonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetHyperlinksEnabled)
function Frame:SetHyperlinksEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetMouseClickEnabled)
function Frame:SetMouseClickEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetMouseMotionEnabled)
function Frame:SetMouseMotionEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetMovable)
function Frame:SetMovable(isMovable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetPropagateKeyboardInput)
function Frame:SetPropagateKeyboardInput(propagate) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetResizable)
function Frame:SetResizable(isResizable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetUserPlaced)
function Frame:SetUserPlaced(isUserPlaced) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_StartMoving)
function Frame:StartMoving() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_StartSizing)
function Frame:StartSizing(point) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_StopMovingOrSizing)
function Frame:StopMovingOrSizing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_EnableGamePadButton)
function Frame:EnableGamePadButton(enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_EnableGamePadStick)
function Frame:EnableGamePadStick(enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsGamePadButtonEnabled)
function Frame:IsGamePadButtonEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_IsGamePadStickEnabled)
function Frame:IsGamePadStickEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetAttribute)
function Frame:GetAttribute(prefix, name, suffix) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetAttribute)
function Frame:SetAttribute(name, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_ExecuteAttribute)
function Frame:ExecuteAttribute(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_CanChangeAttribute)
function Frame:CanChangeAttribute() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_GetID)
function Frame:GetID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Frame_SetID)
function Frame:SetID(id) end
