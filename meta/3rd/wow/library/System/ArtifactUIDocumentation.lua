---@meta
C_ArtifactUI = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.AddPower)
---@param powerID number
---@return boolean success
function C_ArtifactUI.AddPower(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.ApplyCursorRelicToSlot)
---@param relicSlotIndex number
function C_ArtifactUI.ApplyCursorRelicToSlot(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.CanApplyArtifactRelic)
---@param relicItemID number
---@param onlyUnlocked boolean
---@return boolean canApply
function C_ArtifactUI.CanApplyArtifactRelic(relicItemID, onlyUnlocked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.CanApplyCursorRelicToSlot)
---@param relicSlotIndex number
---@return boolean canApply
function C_ArtifactUI.CanApplyCursorRelicToSlot(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.CanApplyRelicItemIDToEquippedArtifactSlot)
---@param relicItemID number
---@param relicSlotIndex number
---@return boolean canApply
function C_ArtifactUI.CanApplyRelicItemIDToEquippedArtifactSlot(relicItemID, relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.CanApplyRelicItemIDToSlot)
---@param relicItemID number
---@param relicSlotIndex number
---@return boolean canApply
function C_ArtifactUI.CanApplyRelicItemIDToSlot(relicItemID, relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.CheckRespecNPC)
---@return boolean canRespec
function C_ArtifactUI.CheckRespecNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.Clear)
function C_ArtifactUI.Clear() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.ClearForgeCamera)
function C_ArtifactUI.ClearForgeCamera() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.ConfirmRespec)
function C_ArtifactUI.ConfirmRespec() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.DoesEquippedArtifactHaveAnyRelicsSlotted)
---@return boolean hasAnyRelicsSlotted
function C_ArtifactUI.DoesEquippedArtifactHaveAnyRelicsSlotted() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetAppearanceInfo)
---@param appearanceSetIndex number
---@param appearanceIndex number
---@return number artifactAppearanceID
---@return string appearanceName
---@return number displayIndex
---@return boolean unlocked
---@return string? failureDescription
---@return number uiCameraID
---@return number? altHandCameraID
---@return number swatchColorR
---@return number swatchColorG
---@return number swatchColorB
---@return number modelOpacity
---@return number modelSaturation
---@return boolean obtainable
function C_ArtifactUI.GetAppearanceInfo(appearanceSetIndex, appearanceIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetAppearanceInfoByID)
---@param artifactAppearanceID number
---@return number artifactAppearanceSetID
---@return number artifactAppearanceID
---@return string appearanceName
---@return number displayIndex
---@return boolean unlocked
---@return string? failureDescription
---@return number uiCameraID
---@return number? altHandCameraID
---@return number swatchColorR
---@return number swatchColorG
---@return number swatchColorB
---@return number modelOpacity
---@return number modelSaturation
---@return boolean obtainable
function C_ArtifactUI.GetAppearanceInfoByID(artifactAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetAppearanceSetInfo)
---@param appearanceSetIndex number
---@return number artifactAppearanceSetID
---@return string appearanceSetName
---@return string appearanceSetDescription
---@return number numAppearances
function C_ArtifactUI.GetAppearanceSetInfo(appearanceSetIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetArtifactArtInfo)
---@return ArtifactArtInfo artifactArtInfo
function C_ArtifactUI.GetArtifactArtInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetArtifactInfo)
---@return number itemID
---@return number? altItemID
---@return string name
---@return number icon
---@return number xp
---@return number pointsSpent
---@return number quality
---@return number artifactAppearanceID
---@return number appearanceModID
---@return number? itemAppearanceID
---@return number? altItemAppearanceID
---@return boolean altOnTop
---@return number tier
function C_ArtifactUI.GetArtifactInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetArtifactItemID)
---@return number itemID
function C_ArtifactUI.GetArtifactItemID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetArtifactTier)
---@return number? tier
function C_ArtifactUI.GetArtifactTier() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetArtifactXPRewardTargetInfo)
---@param artifactCategoryID number
---@return string name
---@return number icon
function C_ArtifactUI.GetArtifactXPRewardTargetInfo(artifactCategoryID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetCostForPointAtRank)
---@param rank number
---@param tier number
---@return number cost
function C_ArtifactUI.GetCostForPointAtRank(rank, tier) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetEquippedArtifactArtInfo)
---@return ArtifactArtInfo artifactArtInfo
function C_ArtifactUI.GetEquippedArtifactArtInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetEquippedArtifactInfo)
---@return number itemID
---@return number? altItemID
---@return string name
---@return number icon
---@return number xp
---@return number pointsSpent
---@return number quality
---@return number artifactAppearanceID
---@return number appearanceModID
---@return number? itemAppearanceID
---@return number? altItemAppearanceID
---@return boolean altOnTop
---@return number tier
function C_ArtifactUI.GetEquippedArtifactInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetEquippedArtifactItemID)
---@return number itemID
function C_ArtifactUI.GetEquippedArtifactItemID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetEquippedArtifactNumRelicSlots)
---@param onlyUnlocked boolean
---@return number numRelicSlots
function C_ArtifactUI.GetEquippedArtifactNumRelicSlots(onlyUnlocked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetEquippedArtifactRelicInfo)
---@param relicSlotIndex number
---@return string name
---@return number icon
---@return string slotTypeName
---@return string link
function C_ArtifactUI.GetEquippedArtifactRelicInfo(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetEquippedRelicLockedReason)
---@param relicSlotIndex number
---@return string? lockedReason
function C_ArtifactUI.GetEquippedRelicLockedReason(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetForgeRotation)
---@return number forgeRotationX
---@return number forgeRotationY
---@return number forgeRotationZ
function C_ArtifactUI.GetForgeRotation() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic)
---@param itemLinkOrID string
---@return number itemIevelIncrease
function C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic(itemLinkOrID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetMetaPowerInfo)
---@return number spellID
---@return number powerCost
---@return number currentRank
function C_ArtifactUI.GetMetaPowerInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetNumAppearanceSets)
---@return number numAppearanceSets
function C_ArtifactUI.GetNumAppearanceSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetNumObtainedArtifacts)
---@return number numObtainedArtifacts
function C_ArtifactUI.GetNumObtainedArtifacts() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetNumRelicSlots)
---@param onlyUnlocked boolean
---@return number numRelicSlots
function C_ArtifactUI.GetNumRelicSlots(onlyUnlocked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPointsRemaining)
---@return number pointsRemaining
function C_ArtifactUI.GetPointsRemaining() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPowerHyperlink)
---@param powerID number
---@return string link
function C_ArtifactUI.GetPowerHyperlink(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPowerInfo)
---@param powerID number
---@return ArtifactPowerInfo powerInfo
function C_ArtifactUI.GetPowerInfo(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPowerLinks)
---@param powerID number
---@return number[] linkingPowerID
function C_ArtifactUI.GetPowerLinks(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPowers)
---@return number[] powerID
function C_ArtifactUI.GetPowers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPowersAffectedByRelic)
---@param relicSlotIndex number
---@return number powerIDs
function C_ArtifactUI.GetPowersAffectedByRelic(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPowersAffectedByRelicItemLink)
---@param relicItemInfo string
---@return number powerIDs
function C_ArtifactUI.GetPowersAffectedByRelicItemLink(relicItemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetPreviewAppearance)
---@return number? artifactAppearanceID
function C_ArtifactUI.GetPreviewAppearance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRelicInfo)
---@param relicSlotIndex number
---@return string name
---@return number icon
---@return string slotTypeName
---@return string link
function C_ArtifactUI.GetRelicInfo(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRelicInfoByItemID)
---@param itemID number
---@return string name
---@return number icon
---@return string slotTypeName
---@return string link
function C_ArtifactUI.GetRelicInfoByItemID(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRelicLockedReason)
---@param relicSlotIndex number
---@return string? lockedReason
function C_ArtifactUI.GetRelicLockedReason(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRelicSlotType)
---@param relicSlotIndex number
---@return string slotTypeName
function C_ArtifactUI.GetRelicSlotType(relicSlotIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRespecArtifactArtInfo)
---@return ArtifactArtInfo artifactArtInfo
function C_ArtifactUI.GetRespecArtifactArtInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRespecArtifactInfo)
---@return number itemID
---@return number? altItemID
---@return string name
---@return number icon
---@return number xp
---@return number pointsSpent
---@return number quality
---@return number artifactAppearanceID
---@return number appearanceModID
---@return number? itemAppearanceID
---@return number? altItemAppearanceID
---@return boolean altOnTop
---@return number tier
function C_ArtifactUI.GetRespecArtifactInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetRespecCost)
---@return number cost
function C_ArtifactUI.GetRespecCost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetTotalPowerCost)
---@param startingTrait number
---@param numTraits number
---@param artifactTier number
---@return number totalArtifactPowerCost
function C_ArtifactUI.GetTotalPowerCost(startingTrait, numTraits, artifactTier) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.GetTotalPurchasedRanks)
---@return number totalPurchasedRanks
function C_ArtifactUI.GetTotalPurchasedRanks() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsArtifactDisabled)
---@return boolean artifactDisabled
function C_ArtifactUI.IsArtifactDisabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsAtForge)
---@return boolean isAtForge
function C_ArtifactUI.IsAtForge() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsEquippedArtifactDisabled)
---@return boolean artifactDisabled
function C_ArtifactUI.IsEquippedArtifactDisabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsEquippedArtifactMaxed)
---@return boolean artifactMaxed
function C_ArtifactUI.IsEquippedArtifactMaxed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsMaxedByRulesOrEffect)
---@return boolean isEffectivelyMaxed
function C_ArtifactUI.IsMaxedByRulesOrEffect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsPowerKnown)
---@param powerID number
---@return boolean known
function C_ArtifactUI.IsPowerKnown(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.IsViewedArtifactEquipped)
---@return boolean isViewedArtifactEquipped
function C_ArtifactUI.IsViewedArtifactEquipped() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.SetAppearance)
---@param artifactAppearanceID number
function C_ArtifactUI.SetAppearance(artifactAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.SetForgeCamera)
function C_ArtifactUI.SetForgeCamera() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.SetForgeRotation)
---@param forgeRotationX number
---@param forgeRotationY number
---@param forgeRotationZ number
function C_ArtifactUI.SetForgeRotation(forgeRotationX, forgeRotationY, forgeRotationZ) end

---Call without an argument to clear the preview.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.SetPreviewAppearance)
---@param artifactAppearanceID number
function C_ArtifactUI.SetPreviewAppearance(artifactAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArtifactUI.ShouldSuppressForgeRotation)
---@return boolean shouldSuppressForgeRotation
function C_ArtifactUI.ShouldSuppressForgeRotation() end

---@class ArtifactArtInfo
---@field textureKit string
---@field titleName string
---@field titleColor ColorMixin
---@field barConnectedColor ColorMixin
---@field barDisconnectedColor ColorMixin
---@field uiModelSceneID number
---@field spellVisualKitID number

---@class ArtifactPowerInfo
---@field spellID number
---@field cost number
---@field currentRank number
---@field maxRank number
---@field bonusRanks number
---@field numMaxRankBonusFromTier number
---@field prereqsMet boolean
---@field isStart boolean
---@field isGoldMedal boolean
---@field isFinal boolean
---@field tier number
---@field position Vector2DMixin
---@field offset Vector2DMixin|nil
---@field linearIndex number|nil
