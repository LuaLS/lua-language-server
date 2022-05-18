---@meta
---@class ModelScene : Frame
local ModelScene = {}

function ModelScene:ClearFog() end

---@return ModelSceneActor actor
function ModelScene:CreateActor(name, template) end

function ModelScene:GetActorAtIndex(actorIndex) end

function ModelScene:GetCameraFarClip() end

function ModelScene:GetCameraFieldOfView() end

function ModelScene:GetCameraForward() end

function ModelScene:GetCameraNearClip() end

function ModelScene:GetCameraPosition() end

function ModelScene:GetCameraRight() end

function ModelScene:GetCameraUp() end

function ModelScene:GetDrawLayer() end

function ModelScene:GetFogColor() end

function ModelScene:GetFogFar() end

function ModelScene:GetFogNear() end

function ModelScene:GetLightAmbientColor() end

function ModelScene:GetLightDiffuseColor() end

function ModelScene:GetLightDirection() end

function ModelScene:GetLightPosition() end

function ModelScene:GetLightType() end

function ModelScene:GetNumActors() end

function ModelScene:GetViewInsets() end

function ModelScene:GetViewTranslation() end

function ModelScene:IsLightVisible() end

function ModelScene:Project3DPointTo2D(x, y, z) end

function ModelScene:SetCameraFarClip(value) end

function ModelScene:SetCameraFieldOfView(radians) end

function ModelScene:SetCameraNearClip(value) end

function ModelScene:SetCameraOrientationByAxisVectors(forwardX, forwardY, forwardZ, rightX, rightY, rightZ, upX, upY, upZ) end

function ModelScene:SetCameraOrientationByYawPitchRoll(yaw, pitch, roll) end

function ModelScene:SetCameraPosition(x, y, z) end

function ModelScene:SetDrawLayer(layer) end

function ModelScene:SetFogColor(r, g, b) end

function ModelScene:SetFogFar(value) end

function ModelScene:SetFogNear(value) end

function ModelScene:SetLightAmbientColor(r, g, b) end

function ModelScene:SetLightDiffuseColor(r, g, b) end

function ModelScene:SetLightDirection(x, y, z) end

function ModelScene:SetLightPosition(x, y, z) end

function ModelScene:SetLightType(LE_MODEL_LIGHT_TYPE) end

function ModelScene:SetLightVisible() end

function ModelScene:SetPaused(paused, affectsGlobalPause) end

function ModelScene:SetViewInsets(l, r, t, b) end

function ModelScene:SetViewTranslation(x, y) end

function ModelScene:TakeActor() end
