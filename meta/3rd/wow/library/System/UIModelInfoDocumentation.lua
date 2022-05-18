---@meta
C_ModelInfo = {}

---This function does nothing in public clients
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.AddActiveModelScene)
---@param modelSceneFrame table
---@param modelSceneID number
function C_ModelInfo.AddActiveModelScene(modelSceneFrame, modelSceneID) end

---This function does nothing in public clients
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.AddActiveModelSceneActor)
---@param modelSceneFrameActor table
---@param modelSceneActorID number
function C_ModelInfo.AddActiveModelSceneActor(modelSceneFrameActor, modelSceneActorID) end

---This function does nothing in public clients
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.ClearActiveModelScene)
---@param modelSceneFrame table
function C_ModelInfo.ClearActiveModelScene(modelSceneFrame) end

---This function does nothing in public clients
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.ClearActiveModelSceneActor)
---@param modelSceneFrameActor table
function C_ModelInfo.ClearActiveModelSceneActor(modelSceneFrameActor) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.GetModelSceneActorDisplayInfoByID)
---@param modelActorDisplayID number
---@return UIModelSceneActorDisplayInfo actorDisplayInfo
function C_ModelInfo.GetModelSceneActorDisplayInfoByID(modelActorDisplayID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.GetModelSceneActorInfoByID)
---@param modelActorID number
---@return UIModelSceneActorInfo actorInfo
function C_ModelInfo.GetModelSceneActorInfoByID(modelActorID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.GetModelSceneCameraInfoByID)
---@param modelSceneCameraID number
---@return UIModelSceneCameraInfo modelSceneCameraInfo
function C_ModelInfo.GetModelSceneCameraInfoByID(modelSceneCameraID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ModelInfo.GetModelSceneInfoByID)
---@param modelSceneID number
---@return ModelSceneType modelSceneType
---@return number[] modelCameraIDs
---@return number[] modelActorsIDs
function C_ModelInfo.GetModelSceneInfoByID(modelSceneID) end

---@class UIModelSceneActorDisplayInfo
---@field animation number
---@field animationVariation number
---@field animSpeed number
---@field animationKitID number|nil
---@field spellVisualKitID number|nil
---@field alpha number
---@field scale number

---@class UIModelSceneActorInfo
---@field modelActorID number
---@field scriptTag string
---@field position Vector3DMixin
---@field yaw number
---@field pitch number
---@field roll number
---@field normalizeScaleAggressiveness number|nil
---@field useCenterForOriginX boolean
---@field useCenterForOriginY boolean
---@field useCenterForOriginZ boolean
---@field modelActorDisplayID number|nil

---@class UIModelSceneCameraInfo
---@field modelSceneCameraID number
---@field scriptTag string
---@field cameraType string
---@field target Vector3DMixin
---@field yaw number
---@field pitch number
---@field roll number
---@field zoomDistance number
---@field minZoomDistance number
---@field maxZoomDistance number
---@field zoomedTargetOffset Vector3DMixin
---@field zoomedYawOffset number
---@field zoomedPitchOffset number
---@field zoomedRollOffset number
---@field flags ModelSceneSetting
