---@meta
---@class Model : Frame
local Model = {}

---@param scriptType ScriptModel
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return function handler
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_GetScript)
function Model:GetScript(scriptType, bindingType) end

---@param scriptType ScriptModel
---@return boolean hasScript
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HasScript)
function Model:HasScript(scriptType) end

---@param scriptType ScriptModel
---@param handler function
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return boolean success
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HookScript)
function Model:HookScript(scriptType, handler, bindingType) end

---@param scriptType ScriptModel
---@param handler function
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_SetScript)
function Model:SetScript(scriptType, handler) end


---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_AdvanceTime)
function Model:AdvanceTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_ClearFog)
function Model:ClearFog() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_ClearModel)
function Model:ClearModel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_ClearTransform)
function Model:ClearTransform() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetCameraDistance)
function Model:GetCameraDistance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetCameraFacing)
function Model:GetCameraFacing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetCameraPosition)
function Model:GetCameraPosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetCameraRoll)
function Model:GetCameraRoll() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetCameraTarget)
function Model:GetCameraTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetDesaturation)
function Model:GetDesaturation() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetFacing)
function Model:GetFacing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetFogColor)
function Model:GetFogColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetFogFar)
function Model:GetFogFar() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetFogNear)
function Model:GetFogNear() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetLight)
function Model:GetLight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetModelAlpha)
function Model:GetModelAlpha() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetModelDrawLayer)
function Model:GetModelDrawLayer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetModelFileID)
function Model:GetModelFileID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetModelScale)
function Model:GetModelScale() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetPaused)
function Model:GetPaused() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetPitch)
function Model:GetPitch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetPosition)
function Model:GetPosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetRoll)
function Model:GetRoll() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetShadowEffect)
function Model:GetShadowEffect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetViewInsets)
function Model:GetViewInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetViewTranslation)
function Model:GetViewTranslation() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_GetWorldScale)
function Model:GetWorldScale() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_HasAttachmentPoints)
function Model:HasAttachmentPoints() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_HasCustomCamera)
function Model:HasCustomCamera() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_IsUsingModelCenterToTransform)
function Model:IsUsingModelCenterToTransform() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_MakeCurrentCameraCustom)
function Model:MakeCurrentCameraCustom() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_ReplaceIconTexture)
function Model:ReplaceIconTexture(texture_or_fileDataID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCamera)
function Model:SetCamera(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCameraDistance)
function Model:SetCameraDistance(distance) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCameraFacing)
function Model:SetCameraFacing(radians) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCameraPosition)
function Model:SetCameraPosition(x, y, z) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCameraRoll)
function Model:SetCameraRoll(radians) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCameraTarget)
function Model:SetCameraTarget(x, y, z) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetCustomCamera)
function Model:SetCustomCamera(defaultIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetDesaturation)
function Model:SetDesaturation(strength) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetFacing)
function Model:SetFacing(facing) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetFogColor)
function Model:SetFogColor(r, g, b, a) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetFogFar)
function Model:SetFogFar(value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetFogNear)
function Model:SetFogNear(value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetGlow)
function Model:SetGlow() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetLight)
function Model:SetLight(enabled, omni, dirX, dirY, dirZ, ambIntensity, ambR, ambG, ambB, dirIntensity, dirR, dirG, dirB) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetModel)
function Model:SetModel(file) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetModelAlpha)
function Model:SetModelAlpha(alpha) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetModelDrawLayer)
function Model:SetModelDrawLayer(layer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetModelScale)
function Model:SetModelScale(scale) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetParticlesEnabled)
function Model:SetParticlesEnabled(bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetPaused)
function Model:SetPaused(bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetPitch)
function Model:SetPitch(pitch) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetPosition)
function Model:SetPosition(x, y, z) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetRoll)
function Model:SetRoll(roll) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetSequence)
function Model:SetSequence(sequence) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetSequenceTime)
function Model:SetSequenceTime(sequence, time) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetShadowEffect)
function Model:SetShadowEffect(strength) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetTransform)
function Model:SetTransform() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetViewInsets)
function Model:SetViewInsets(l, r, t, b) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_SetViewTranslation)
function Model:SetViewTranslation(x, y) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_TransformCameraSpaceToModelSpace)
function Model:TransformCameraSpaceToModelSpace(positionX, positionY, positionZ) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Model_UseModelCenterToTransform)
function Model:UseModelCenterToTransform() end
