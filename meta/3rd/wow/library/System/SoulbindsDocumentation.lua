---@meta
C_Soulbinds = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.ActivateSoulbind)
---@param soulbindID number
function C_Soulbinds.ActivateSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.CanActivateSoulbind)
---@param soulbindID number
---@return boolean result
---@return string? errorDescription
function C_Soulbinds.CanActivateSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.CanModifySoulbind)
---@return boolean result
function C_Soulbinds.CanModifySoulbind() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.CanResetConduitsInSoulbind)
---@param soulbindID number
---@return boolean result
---@return string? errorDescription
function C_Soulbinds.CanResetConduitsInSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.CanSwitchActiveSoulbindTreeBranch)
---@return boolean result
function C_Soulbinds.CanSwitchActiveSoulbindTreeBranch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.CloseUI)
function C_Soulbinds.CloseUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.CommitPendingConduitsInSoulbind)
---@param soulbindID number
function C_Soulbinds.CommitPendingConduitsInSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.FindNodeIDActuallyInstalled)
---@param soulbindID number
---@param conduitID number
---@return number nodeID
function C_Soulbinds.FindNodeIDActuallyInstalled(soulbindID, conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.FindNodeIDAppearingInstalled)
---@param soulbindID number
---@param conduitID number
---@return number nodeID
function C_Soulbinds.FindNodeIDAppearingInstalled(soulbindID, conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.FindNodeIDPendingInstall)
---@param soulbindID number
---@param conduitID number
---@return number nodeID
function C_Soulbinds.FindNodeIDPendingInstall(soulbindID, conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.FindNodeIDPendingUninstall)
---@param soulbindID number
---@param conduitID number
---@return number nodeID
function C_Soulbinds.FindNodeIDPendingUninstall(soulbindID, conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetActiveSoulbindID)
---@return number soulbindID
function C_Soulbinds.GetActiveSoulbindID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitCollection)
---@param conduitType SoulbindConduitType
---@return ConduitCollectionData[] collectionData
function C_Soulbinds.GetConduitCollection(conduitType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitCollectionCount)
---@return number count
function C_Soulbinds.GetConduitCollectionCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitCollectionData)
---@param conduitID number
---@return ConduitCollectionData? collectionData
function C_Soulbinds.GetConduitCollectionData(conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitCollectionDataAtCursor)
---@return ConduitCollectionData? collectionData
function C_Soulbinds.GetConduitCollectionDataAtCursor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitCollectionDataByVirtualID)
---@param virtualID number
---@return ConduitCollectionData? collectionData
function C_Soulbinds.GetConduitCollectionDataByVirtualID(virtualID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitDisplayed)
---@param nodeID number
---@return number conduitID
function C_Soulbinds.GetConduitDisplayed(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitHyperlink)
---@param conduitID number
---@param rank number
---@return string link
function C_Soulbinds.GetConduitHyperlink(conduitID, rank) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitIDPendingInstall)
---@param nodeID number
---@return number conduitID
function C_Soulbinds.GetConduitIDPendingInstall(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitQuality)
---@param conduitID number
---@param rank number
---@return number quality
function C_Soulbinds.GetConduitQuality(conduitID, rank) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitRank)
---@param conduitID number
---@return number conduitRank
function C_Soulbinds.GetConduitRank(conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetConduitSpellID)
---@param conduitID number
---@param conduitRank number
---@return number spellID
function C_Soulbinds.GetConduitSpellID(conduitID, conduitRank) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetInstalledConduitID)
---@param nodeID number
---@return number conduitID
function C_Soulbinds.GetInstalledConduitID(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetNode)
---@param nodeID number
---@return SoulbindNode node
function C_Soulbinds.GetNode(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetSoulbindData)
---@param soulbindID number
---@return SoulbindData data
function C_Soulbinds.GetSoulbindData(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetSpecsAssignedToSoulbind)
---@param soulbindID number
---@return number[] specIDs
function C_Soulbinds.GetSpecsAssignedToSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.GetTree)
---@param treeID number
---@return SoulbindTree tree
function C_Soulbinds.GetTree(treeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.HasAnyInstalledConduitInSoulbind)
---@param soulbindID number
---@return boolean result
function C_Soulbinds.HasAnyInstalledConduitInSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.HasAnyPendingConduits)
---@return boolean result
function C_Soulbinds.HasAnyPendingConduits() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.HasPendingConduitsInSoulbind)
---@param soulbindID number
---@return boolean result
function C_Soulbinds.HasPendingConduitsInSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.IsConduitInstalled)
---@param nodeID number
---@return boolean result
function C_Soulbinds.IsConduitInstalled(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.IsConduitInstalledInSoulbind)
---@param soulbindID number
---@param conduitID number
---@return boolean result
function C_Soulbinds.IsConduitInstalledInSoulbind(soulbindID, conduitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.IsItemConduitByItemInfo)
---@param itemInfo string
---@return boolean result
function C_Soulbinds.IsItemConduitByItemInfo(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.IsNodePendingModify)
---@param nodeID number
---@return boolean result
function C_Soulbinds.IsNodePendingModify(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.IsUnselectedConduitPendingInSoulbind)
---@param soulbindID number
---@return boolean result
function C_Soulbinds.IsUnselectedConduitPendingInSoulbind(soulbindID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.ModifyNode)
---@param nodeID number
---@param conduitID number
---@param type SoulbindConduitTransactionType
function C_Soulbinds.ModifyNode(nodeID, conduitID, type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.SelectNode)
---@param nodeID number
function C_Soulbinds.SelectNode(nodeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Soulbinds.UnmodifyNode)
---@param nodeID number
function C_Soulbinds.UnmodifyNode(nodeID) end

---@class ConduitCollectionData
---@field conduitID number
---@field conduitRank number
---@field conduitItemLevel number
---@field conduitType SoulbindConduitType
---@field conduitSpecSetID number
---@field conduitSpecIDs number[]
---@field conduitSpecName string|nil
---@field covenantID number|nil
---@field conduitItemID number

---@class SoulbindConduitData
---@field conduitID number
---@field conduitRank number

---@class SoulbindData
---@field ID number
---@field covenantID number
---@field name string
---@field description string
---@field textureKit string
---@field unlocked boolean
---@field cvarIndex number
---@field tree SoulbindTree
---@field modelSceneData SoulbindModelSceneData
---@field activationSoundKitID number
---@field playerConditionReason string|nil

---@class SoulbindModelSceneData
---@field creatureDisplayInfoID number
---@field modelSceneActorID number

---@class SoulbindNode
---@field ID number
---@field row number
---@field column number
---@field icon number
---@field spellID number
---@field playerConditionReason string|nil
---@field conduitID number
---@field conduitRank number
---@field state SoulbindNodeState
---@field conduitType SoulbindConduitType|nil
---@field parentNodeIDs number[]
---@field failureRenownRequirement number|nil
---@field socketEnhanced boolean|nil

---@class SoulbindTree
---@field editable boolean
---@field nodes SoulbindNode[]
