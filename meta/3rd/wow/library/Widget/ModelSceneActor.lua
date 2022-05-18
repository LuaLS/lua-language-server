---@meta
---@class ModelSceneActor : ParentedObject
local ModelSceneActor = {}

function ModelSceneActor:AttachToMount() end

function ModelSceneActor:CalculateMountScale() end

function ModelSceneActor:ClearModel() end

function ModelSceneActor:Dress() end

function ModelSceneActor:GetActiveBoundingBox() end

function ModelSceneActor:GetAlpha() end

function ModelSceneActor:GetAnimation() end

function ModelSceneActor:GetAnimationBlendOperation() end

function ModelSceneActor:GetAnimationVariation() end

function ModelSceneActor:GetAutoDress() end

function ModelSceneActor:GetDesaturation() end

function ModelSceneActor:GetMaxBoundingBox() end

function ModelSceneActor:GetModelFileID() end

function ModelSceneActor:GetModelPath() end

function ModelSceneActor:GetModelUnitGUID() end

function ModelSceneActor:GetParticleOverrideScale() end

function ModelSceneActor:GetPaused() end

function ModelSceneActor:GetPitch() end

function ModelSceneActor:GetPosition() end

function ModelSceneActor:GetRoll() end

function ModelSceneActor:GetScale() end

function ModelSceneActor:GetSheathed() end

function ModelSceneActor:GetSlotTransmogSources() end

function ModelSceneActor:GetSpellVisualKit() end

function ModelSceneActor:GetUseTransmogSkin() end

function ModelSceneActor:GetYaw() end

function ModelSceneActor:Hide() end

function ModelSceneActor:IsLoaded() end

function ModelSceneActor:IsShown() end

function ModelSceneActor:IsUsingCenterForOrigin() end

function ModelSceneActor:IsVisible() end

function ModelSceneActor:PlayAnimationKit(id, loop) end

function ModelSceneActor:SetAlpha(alpha) end

function ModelSceneActor:SetAnimation(animation, variation, animSpeed, timeOffsetSecs) end

function ModelSceneActor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION) end

---@param bool boolean
function ModelSceneActor:SetAutoDress(bool) end

function ModelSceneActor:SetDesaturation(strength) end

function ModelSceneActor:SetModelByCreatureDisplayID(creatureDisplayID) end

function ModelSceneActor:SetModelByFileID(fileID, enableMips) end

function ModelSceneActor:SetModelByPath(filePath, enableMips) end

function ModelSceneActor:SetModelByUnit(unitId, sheatheWeapons, autoDress) end

function ModelSceneActor:SetParticleOverrideScale() end

function ModelSceneActor:SetPaused(paused, affectsGlobalPause) end

function ModelSceneActor:SetPitch(pitch) end

function ModelSceneActor:SetPlayerModelFromGlues() end

function ModelSceneActor:SetPosition(x, y, z) end

function ModelSceneActor:SetRoll(roll) end

function ModelSceneActor:SetScale(scale) end

---@param bool boolean
function ModelSceneActor:SetSheathed(bool) end

---@param bool boolean
function ModelSceneActor:SetShown(bool) end

function ModelSceneActor:SetSpellVisualKit() end

function ModelSceneActor:SetUseCenterForOrigin() end

---@param bool boolean
function ModelSceneActor:SetUseTransmogSkin(bool) end

function ModelSceneActor:SetYaw(facing) end

function ModelSceneActor:Show() end

function ModelSceneActor:StopAnimationKit() end

function ModelSceneActor:TryOn() end

function ModelSceneActor:Undress() end

function ModelSceneActor:UndressSlot(slotIndex) end
