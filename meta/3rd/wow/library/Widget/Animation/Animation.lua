---@meta
---@class Animation : ParentedObject, ScriptObject
local Animation = {}

---@param scriptType ScriptAnimation
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return function handler
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_GetScript)
function Animation:GetScript(scriptType, bindingType) end

---@param scriptType ScriptAnimation
---@return boolean hasScript
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HasScript)
function Animation:HasScript(scriptType) end

---@param scriptType ScriptAnimation
---@param handler function
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return boolean success
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HookScript)
function Animation:HookScript(scriptType, handler, bindingType) end

---@param scriptType ScriptAnimation
---@param handler function
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_SetScript)
function Animation:SetScript(scriptType, handler) end


---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetDuration)
function Animation:GetDuration() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetElapsed)
function Animation:GetElapsed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetEndDelay)
function Animation:GetEndDelay() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetOrder)
function Animation:GetOrder() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetProgress)
function Animation:GetProgress() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetRegionParent)
function Animation:GetRegionParent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetSmoothProgress)
function Animation:GetSmoothProgress() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetSmoothing)
function Animation:GetSmoothing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetStartDelay)
function Animation:GetStartDelay() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_GetTarget)
function Animation:GetTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_IsDelaying)
function Animation:IsDelaying() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_IsDone)
function Animation:IsDone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_IsPaused)
function Animation:IsPaused() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_IsPlaying)
function Animation:IsPlaying() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_IsStopped)
function Animation:IsStopped() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_Pause)
function Animation:Pause() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_Play)
function Animation:Play(reversed, elapsedOffset) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_Restart)
function Animation:Restart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetChildKey)
function Animation:SetChildKey() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetDuration)
function Animation:SetDuration(durationSec) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetEndDelay)
function Animation:SetEndDelay(delaySec) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetOrder)
function Animation:SetOrder(order) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetParent)
function Animation:SetParent(animGroup_or_animGroupName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetPlaying)
function Animation:SetPlaying(play) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetSmoothProgress)
function Animation:SetSmoothProgress(smoothProgress) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetSmoothing)
function Animation:SetSmoothing(smoothType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetStartDelay)
function Animation:SetStartDelay(delaySec) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetTarget)
function Animation:SetTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_SetTargetKey)
function Animation:SetTargetKey() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Animation_Stop)
function Animation:Stop() end
