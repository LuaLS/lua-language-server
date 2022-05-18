---@meta
C_PartyPose = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyPose.GetPartyPoseInfoByMapID)
---@param mapID number
---@return PartyPoseInfo info
function C_PartyPose.GetPartyPoseInfoByMapID(mapID) end

---@class PartyPoseInfo
---@field partyPoseID number
---@field mapID number
---@field widgetSetID number|nil
---@field victoryModelSceneID number
---@field defeatModelSceneID number
---@field victorySoundKitID number
---@field defeatSoundKitID number
