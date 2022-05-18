---@meta
C_Covenants = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Covenants.GetActiveCovenantID)
---@return number covenantID
function C_Covenants.GetActiveCovenantID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Covenants.GetCovenantData)
---@param covenantID number
---@return CovenantData? data
function C_Covenants.GetCovenantData(covenantID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Covenants.GetCovenantIDs)
---@return number[] covenantID
function C_Covenants.GetCovenantIDs() end

---@class CovenantData
---@field ID number
---@field textureKit string
---@field celebrationSoundKit number
---@field animaChannelSelectSoundKit number
---@field animaChannelActiveSoundKit number
---@field animaGemsFullSoundKit number
---@field animaNewGemSoundKit number
---@field animaReinforceSelectSoundKit number
---@field upgradeTabSelectSoundKitID number
---@field reservoirFullSoundKitID number
---@field beginResearchSoundKitID number
---@field renownFanfareSoundKitID number
---@field name string
---@field soulbindIDs number[]
