---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/API_InCombatLockdown)
function InCombatLockdown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_InGuildParty)
---@return boolean inGroup
---@return number numGuildPresent
---@return number numGuildRequired
---@return number xpMultiplier
function InGuildParty() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_InRepairMode)
function InRepairMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_InboxItemCanDelete)
function InboxItemCanDelete(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_InitiateRolePoll)
function InitiateRolePoll() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_InitiateTrade)
---@param unit string
function InitiateTrade(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_InteractUnit)
function InteractUnit(unitToken, exactMatch) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Is64BitClient)
function Is64BitClient() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAccountSecured)
---@return boolean accountSecured
function IsAccountSecured() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAchievementEligible)
---@param achievementID number
---@return boolean eligible
function IsAchievementEligible(achievementID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsActionInRange)
---@param actionSlot number
---@return boolean inRange
function IsActionInRange(actionSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsActiveBattlefieldArena)
---@return boolean isArena
---@return boolean isRegistered
function IsActiveBattlefieldArena() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsActiveQuestLegendary)
function IsActiveQuestLegendary(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsActiveQuestTrivial)
function IsActiveQuestTrivial(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAddOnLoadOnDemand)
function IsAddOnLoadOnDemand() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAddOnLoaded)
---@param addon number|string index or name
---@return boolean loaded
---@return boolean finished
function IsAddOnLoaded(addon) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAddonVersionCheckEnabled)
function IsAddonVersionCheckEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAllowedToUserTeleport)
---@return boolean allowedToTeleport
function IsAllowedToUserTeleport() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAltKeyDown)
function IsAltKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsArenaSkirmish)
function IsArenaSkirmish() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsArenaTeamCaptain)
function IsArenaTeamCaptain(teamIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsArtifactCompletionHistoryAvailable)
function IsArtifactCompletionHistoryAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsArtifactPowerItem)
function IsArtifactPowerItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsArtifactRelicItem)
function IsArtifactRelicItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAtStableMaster)
function IsAtStableMaster() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAttackAction)
function IsAttackAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAttackSpell)
function IsAttackSpell(spell) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAutoRepeatAction)
function IsAutoRepeatAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAutoRepeatSpell)
function IsAutoRepeatSpell(spell) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsAvailableQuestTrivial)
function IsAvailableQuestTrivial(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsBNLogin)
function IsBNLogin() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsBagSlotFlagEnabledOnOtherBags)
function IsBagSlotFlagEnabledOnOtherBags(index, flagIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsBagSlotFlagEnabledOnOtherBankBags)
function IsBagSlotFlagEnabledOnOtherBankBags() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsBattlePayItem)
function IsBattlePayItem(bag, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsBindingForGamePad)
function IsBindingForGamePad(KEY) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsBreadcrumbQuest)
function IsBreadcrumbQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCastingGlyph)
function IsCastingGlyph() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCemeterySelectionAvailable)
function IsCemeterySelectionAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCharacterNewlyBoosted)
function IsCharacterNewlyBoosted() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsChatAFK)
function IsChatAFK() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsChatChannelRaid)
function IsChatChannelRaid() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsChatDND)
function IsChatDND() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCompetitiveModeEnabled)
function IsCompetitiveModeEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsConsumableAction)
function IsConsumableAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsConsumableItem)
function IsConsumableItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsConsumableSpell)
function IsConsumableSpell() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsContainerFiltered)
function IsContainerFiltered(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsContainerItemAnUpgrade)
function IsContainerItemAnUpgrade(index, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsControlKeyDown)
function IsControlKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCorruptedItem)
function IsCorruptedItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCosmeticItem)
function IsCosmeticItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCurrentAction)
---@param actionSlot number
---@return boolean isCurrent
function IsCurrentAction(actionSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCurrentItem)
function IsCurrentItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCurrentQuestFailed)
function IsCurrentQuestFailed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsCurrentSpell)
---@param spellID boolean
---@return boolean isCurrent
function IsCurrentSpell(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsDebugBuild)
function IsDebugBuild() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsDemonHunterAvailable)
function IsDemonHunterAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsDesaturateSupported)
function IsDesaturateSupported() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsDisplayChannelModerator)
function IsDisplayChannelModerator() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsDisplayChannelOwner)
function IsDisplayChannelOwner() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsDualWielding)
---@return boolean isDualWield
function IsDualWielding() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEncounterInProgress)
function IsEncounterInProgress() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEncounterLimitingResurrections)
function IsEncounterLimitingResurrections() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEncounterSuppressingRelease)
function IsEncounterSuppressingRelease() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEquippableItem)
function IsEquippableItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEquippedAction)
function IsEquippedAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEquippedItem)
function IsEquippedItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEquippedItemType)
---@param type string
---@return boolean isEquipped
function IsEquippedItemType(type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEuropeanNumbers)
function IsEuropeanNumbers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsEveryoneAssistant)
function IsEveryoneAssistant() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsFactionInactive)
---@param index number
---@return boolean inactive
function IsFactionInactive(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsFalling)
function IsFalling() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsFishingLoot)
function IsFishingLoot() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsFlyableArea)
function IsFlyableArea() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsFlying)
function IsFlying() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGMClient)
function IsGMClient() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGUIDInGroup)
function IsGUIDInGroup(guid, groupType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGamePadCursorControlEnabled)
function IsGamePadCursorControlEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGamePadFreelookEnabled)
function IsGamePadFreelookEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGuildLeader)
---@return boolean isGuildLeader
function IsGuildLeader() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGuildMember)
function IsGuildMember() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsGuildRankAssignmentAllowed)
function IsGuildRankAssignmentAllowed(playerIndex, rankIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsHarmfulItem)
function IsHarmfulItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsHarmfulSpell)
function IsHarmfulSpell(spellSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsHelpfulItem)
function IsHelpfulItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsHelpfulSpell)
function IsHelpfulSpell(spellSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInActiveWorldPVP)
function IsInActiveWorldPVP() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInArenaTeam)
function IsInArenaTeam() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInAuthenticatedRank)
function IsInAuthenticatedRank() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInCinematicScene)
---@return boolean inCinematicScene
function IsInCinematicScene() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInGroup)
---@param groupType? number
---@return boolean inGroup
function IsInGroup(groupType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInGuild)
function IsInGuild() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInGuildGroup)
function IsInGuildGroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInInstance)
---@return boolean inInstance
---@return string instanceType
function IsInInstance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInJailersTower)
function IsInJailersTower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInLFGDungeon)
function IsInLFGDungeon() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInRaid)
---@param groupType? number
---@return boolean isInRaid
function IsInRaid(groupType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInScenarioGroup)
function IsInScenarioGroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsIndoors)
function IsIndoors() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInsane)
function IsInsane() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInventoryItemAnUpgrade)
function IsInventoryItemAnUpgrade(unit, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInventoryItemLocked)
function IsInventoryItemLocked(id) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsInventoryItemProfessionBag)
function IsInventoryItemProfessionBag(unit, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsItemAction)
function IsItemAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsItemInRange)
---@param item string
---@param unit? string
---@return boolean inRange
function IsItemInRange(item, unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsJailersTowerLayerTimeLocked)
function IsJailersTowerLayerTimeLocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsKeyDown)
function IsKeyDown(keyOrMouseName, excludeCurrentBindingState) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLFGComplete)
---@return boolean isComplete
function IsLFGComplete() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLFGDungeonJoinable)
function IsLFGDungeonJoinable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLeftAltKeyDown)
function IsLeftAltKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLeftControlKeyDown)
function IsLeftControlKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLeftMetaKeyDown)
function IsLeftMetaKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLeftShiftKeyDown)
function IsLeftShiftKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLegacyDifficulty)
function IsLegacyDifficulty(difficultyID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLinuxClient)
function IsLinuxClient() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsLoggedIn)
function IsLoggedIn() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMacClient)
function IsMacClient() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMasterLooter)
function IsMasterLooter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMetaKeyDown)
function IsMetaKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsModifiedClick)
---@param action string
---@return boolean isHeld
function IsModifiedClick(action) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown)
function IsModifierKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMounted)
function IsMounted() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMouseButtonDown)
---@param button? string
---@return boolean isDown
function IsMouseButtonDown(button) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMouselooking)
function IsMouselooking() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMovieLocal)
function IsMovieLocal(movieId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsMoviePlayable)
---@param movieID number
---@return boolean playable
function IsMoviePlayable(movieID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsOnGlueScreen)
---@return boolean isOnGlueScreen
function IsOnGlueScreen() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsOnGroundFloorInJailersTower)
function IsOnGroundFloorInJailersTower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsOnTournamentRealm)
function IsOnTournamentRealm() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsOutOfBounds)
---@return boolean oob
function IsOutOfBounds() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsOutdoors)
function IsOutdoors() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsOutlineModeSupported)
function IsOutlineModeSupported() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPVPTimerRunning)
function IsPVPTimerRunning() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPartyLFG)
function IsPartyLFG() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPartyWorldPVP)
function IsPartyWorldPVP() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPassiveSpell)
function IsPassiveSpell(spellID, bookType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPendingGlyphRemoval)
function IsPendingGlyphRemoval() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPetActive)
function IsPetActive() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPetAttackAction)
function IsPetAttackAction(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPetAttackActive)
---@return boolean isActive
function IsPetAttackActive() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPlayerInWorld)
function IsPlayerInWorld() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPlayerMoving)
function IsPlayerMoving() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPlayerNeutral)
---@return boolean isNeutral
function IsPlayerNeutral() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPlayerSpell)
---@param spellID number
---@return boolean isKnown
function IsPlayerSpell(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPossessBarVisible)
function IsPossessBarVisible() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPublicBuild)
function IsPublicBuild() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsPvpTalentSpell)
function IsPvpTalentSpell() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsQuestCompletable)
---@return boolean isQuestCompletable
function IsQuestCompletable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsQuestIDValidSpellTarget)
function IsQuestIDValidSpellTarget(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsQuestItemHidden)
function IsQuestItemHidden(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsQuestLogSpecialItemInRange)
function IsQuestLogSpecialItemInRange(index, target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsQuestSequenced)
function IsQuestSequenced(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRaidMarkerActive)
function IsRaidMarkerActive(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRangedWeapon)
function IsRangedWeapon() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsReagentBankUnlocked)
function IsReagentBankUnlocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRecognizedName)
---@param text string
---@param includeBitfield number
---@param excludeBitfield number
---@return boolean isRecognized
function IsRecognizedName(text, includeBitfield, excludeBitfield) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRecruitAFriendLinked)
---@return boolean isRafLinked
function IsRecruitAFriendLinked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsReplacingUnit)
function IsReplacingUnit() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsResting)
---@return boolean resting
function IsResting() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRestrictedAccount)
function IsRestrictedAccount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRightAltKeyDown)
function IsRightAltKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRightControlKeyDown)
function IsRightControlKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRightMetaKeyDown)
function IsRightMetaKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsRightShiftKeyDown)
function IsRightShiftKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSelectedSpellBookItem)
function IsSelectedSpellBookItem(spellSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsServerControlledBackfill)
function IsServerControlledBackfill() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsShiftKeyDown)
function IsShiftKeyDown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSpellClassOrSpec)
function IsSpellClassOrSpec() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSpellInRange)
function IsSpellInRange(spellName, unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSpellKnown)
function IsSpellKnown(spellID, isPetSpell) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSpellKnownOrOverridesKnown)
function IsSpellKnownOrOverridesKnown(spellID, isPet) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSpellOverlayed)
---@param spellID number
---@return boolean isTrue
function IsSpellOverlayed(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSpellValidForPendingGlyph)
function IsSpellValidForPendingGlyph(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSplashFramePrimaryFeatureUnlocked)
function IsSplashFramePrimaryFeatureUnlocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsStackableAction)
function IsStackableAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsStealthed)
---@return boolean stealthed
function IsStealthed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsStoryQuest)
function IsStoryQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSubZonePVPPOI)
function IsSubZonePVPPOI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSubmerged)
function IsSubmerged() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsSwimming)
---@return boolean isSwimming
function IsSwimming() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTalentSpell)
function IsTalentSpell(slot, bookType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTestBuild)
function IsTestBuild() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsThreatWarningEnabled)
function IsThreatWarningEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTitleKnown)
---@param titleId number
---@return boolean isKnown
function IsTitleKnown(titleId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTrackedAchievement)
function IsTrackedAchievement(achievementID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTrackingBattlePets)
---@return boolean isTracking
function IsTrackingBattlePets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTrackingHiddenQuests)
function IsTrackingHiddenQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTradeskillTrainer)
function IsTradeskillTrainer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTutorialFlagged)
function IsTutorialFlagged(tutorial) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsUsableAction)
---@param slot number
---@return boolean isUsable
---@return boolean notEnoughMana
function IsUsableAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsUsableItem)
function IsUsableItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsUsableSpell)
function IsUsableSpell() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsUsingFixedTimeStep)
function IsUsingFixedTimeStep() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsUsingVehicleControls)
function IsUsingVehicleControls() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsVehicleAimAngleAdjustable)
function IsVehicleAimAngleAdjustable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsVehicleAimPowerAdjustable)
function IsVehicleAimPowerAdjustable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsVoidStorageReady)
function IsVoidStorageReady() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsWargame)
---@return boolean isWargame
function IsWargame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsWindowsClient)
function IsWindowsClient() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsXPUserDisabled)
function IsXPUserDisabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemAddedToArtifact)
function ItemAddedToArtifact(keystoneindex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemCanTargetGarrisonFollowerAbility)
function ItemCanTargetGarrisonFollowerAbility() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemHasRange)
function ItemHasRange(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextGetCreator)
function ItemTextGetCreator() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextGetItem)
function ItemTextGetItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextGetMaterial)
function ItemTextGetMaterial() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextGetPage)
function ItemTextGetPage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextGetText)
function ItemTextGetText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextHasNextPage)
function ItemTextHasNextPage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextIsFullPage)
function ItemTextIsFullPage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextNextPage)
function ItemTextNextPage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ItemTextPrevPage)
function ItemTextPrevPage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinArena)
function JoinArena() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinBattlefield)
---@param index number
---@param asGroup boolean
---@param isRated boolean
function JoinBattlefield(index, asGroup, isRated) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinChannelByName)
---@param channelName string
---@param password? string
---@param frameID? number
---@param hasVoice boolean
---@return number type
---@return string? name
function JoinChannelByName(channelName, password, frameID, hasVoice) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinLFG)
function JoinLFG(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinPermanentChannel)
function JoinPermanentChannel(channelName, password, frameID, hasVoice) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinRatedBattlefield)
function JoinRatedBattlefield() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinSingleLFG)
function JoinSingleLFG(category, lfgID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinSkirmish)
---@param arenaID number
---@param joinAsGroup boolean
function JoinSkirmish(arenaID, joinAsGroup) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JoinTemporaryChannel)
function JoinTemporaryChannel(channelName, password, frameID, hasVoice) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_JumpOrAscendStart)
function JumpOrAscendStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBArticle_BeginLoading)
function KBArticle_BeginLoading(articleId, searchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBArticle_GetData)
function KBArticle_GetData() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBArticle_IsLoaded)
---@return boolean loaded
function KBArticle_IsLoaded() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBQuery_BeginLoading)
function KBQuery_BeginLoading(searchText, categoryIndex, subcategoryIndex, articlesPerPage, curPage) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBQuery_GetArticleHeaderCount)
function KBQuery_GetArticleHeaderCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBQuery_GetArticleHeaderData)
function KBQuery_GetArticleHeaderData(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBQuery_GetTotalArticleCount)
function KBQuery_GetTotalArticleCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBQuery_IsLoaded)
function KBQuery_IsLoaded() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_BeginLoading)
function KBSetup_BeginLoading(articlesPerPage, curPage) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetArticleHeaderCount)
function KBSetup_GetArticleHeaderCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetArticleHeaderData)
function KBSetup_GetArticleHeaderData(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetCategoryCount)
function KBSetup_GetCategoryCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetCategoryData)
function KBSetup_GetCategoryData(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetLanguageCount)
function KBSetup_GetLanguageCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetLanguageData)
function KBSetup_GetLanguageData(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetSubCategoryCount)
function KBSetup_GetSubCategoryCount(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetSubCategoryData)
function KBSetup_GetSubCategoryData(category, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_GetTotalArticleCount)
function KBSetup_GetTotalArticleCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSetup_IsLoaded)
function KBSetup_IsLoaded() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSystem_GetMOTD)
function KBSystem_GetMOTD() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSystem_GetServerNotice)
---@return string? notice
function KBSystem_GetServerNotice() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_KBSystem_GetServerStatus)
function KBSystem_GetServerStatus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LFGTeleport)
---@param toSafety boolean
function LFGTeleport(toSafety) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LearnPvpTalent)
function LearnPvpTalent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LearnPvpTalents)
function LearnPvpTalents() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LearnTalent)
---@param talentID number
---@return boolean success
function LearnTalent(talentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LearnTalents)
function LearnTalents() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LeaveBattlefield)
function LeaveBattlefield() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LeaveChannelByLocalID)
function LeaveChannelByLocalID(localID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LeaveChannelByName)
---@param channelName string
function LeaveChannelByName(channelName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LeaveLFG)
function LeaveLFG(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LeaveSingleLFG)
function LeaveSingleLFG(category, lfgID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ListChannelByName)
function ListChannelByName(channelMatch) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ListChannels)
function ListChannels() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LoadAddOn)
---@param addonInfo number|string index or name
---@return boolean loaded
---@return string? reason
function LoadAddOn(addonInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LoadBindings)
---@param bindingSet number
function LoadBindings(bindingSet) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LoadURLIndex)
function LoadURLIndex(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LoggingChat)
function LoggingChat(newState) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LoggingCombat)
function LoggingCombat(newState) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Logout)
function Logout() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LootMoneyNotify)
function LootMoneyNotify(money, soleLooter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LootSlot)
function LootSlot(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LootSlotHasItem)
---@param lootSlot number
---@return boolean isLootItem
function LootSlotHasItem(lootSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MouseOverrideCinematicDisable)
function MouseOverrideCinematicDisable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MouselookStart)
function MouselookStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MouselookStop)
function MouselookStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveAndSteerStart)
function MoveAndSteerStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveAndSteerStop)
function MoveAndSteerStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveBackwardStart)
---@param startTime number
function MoveBackwardStart(startTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveBackwardStop)
function MoveBackwardStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveForwardStart)
---@param startTime number
function MoveForwardStart(startTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveForwardStop)
function MoveForwardStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewDownStart)
---@param speed number
function MoveViewDownStart(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewDownStop)
function MoveViewDownStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewInStart)
---@param speed number
function MoveViewInStart(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewInStop)
function MoveViewInStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewLeftStart)
---@param speed number
function MoveViewLeftStart(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewLeftStop)
function MoveViewLeftStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewOutStart)
---@param speed number
function MoveViewOutStart(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewOutStop)
function MoveViewOutStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewRightStart)
---@param speed number
function MoveViewRightStart(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewRightStop)
function MoveViewRightStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewUpStart)
---@param speed number
function MoveViewUpStart(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MoveViewUpStop)
function MoveViewUpStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MultiSampleAntiAliasingSupported)
function MultiSampleAntiAliasingSupported() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_MuteSoundFile)
---@param sound number|string FileID of a game sound or file path to an addon sound
function MuteSoundFile(sound) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_NeutralPlayerSelectFaction)
---@param factionIndex number
function NeutralPlayerSelectFaction(factionIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_NextView)
function NextView() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_NoPlayTime)
---@return boolean isUnhealthy
function NoPlayTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_NotWhileDeadError)
function NotWhileDeadError() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_NotifyInspect)
---@param unit string
function NotifyInspect(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_NumTaxiNodes)
---@return number numNodes
function NumTaxiNodes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_OfferPetition)
function OfferPetition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_OpenTrainer)
function OpenTrainer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_OpeningCinematic)
function OpeningCinematic() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PartialPlayTime)
function PartialPlayTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PartyLFGStartBackfill)
function PartyLFGStartBackfill() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetAbandon)
function PetAbandon() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetAggressiveMode)
function PetAggressiveMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetAssistMode)
function PetAssistMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetAttack)
function PetAttack() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetCanBeAbandoned)
---@return boolean canAbandon
function PetCanBeAbandoned() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetCanBeDismissed)
function PetCanBeDismissed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetCanBeRenamed)
---@return boolean canRename
function PetCanBeRenamed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetDefensiveAssistMode)
function PetDefensiveAssistMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetDefensiveMode)
function PetDefensiveMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetDismiss)
function PetDismiss() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetFollow)
function PetFollow() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetHasActionBar)
function PetHasActionBar() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetHasSpellbook)
function PetHasSpellbook() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetMoveTo)
function PetMoveTo(target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetPassiveMode)
function PetPassiveMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetRename)
---@param name string
function PetRename(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetStopAttack)
function PetStopAttack() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetUsesPetFrame)
function PetUsesPetFrame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PetWait)
function PetWait() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupAction)
function PickupAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupBagFromSlot)
function PickupBagFromSlot(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupCompanion)
---@param type string
---@param index number
function PickupCompanion(type, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupContainerItem)
---@param bagID number
---@param slot number
function PickupContainerItem(bagID, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupGuildBankItem)
function PickupGuildBankItem(tab, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupGuildBankMoney)
function PickupGuildBankMoney(money) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupInventoryItem)
function PickupInventoryItem(invSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupItem)
function PickupItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupMacro)
function PickupMacro() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupMerchantItem)
function PickupMerchantItem(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupPetAction)
function PickupPetAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupPetSpell)
---@param spellID number
function PickupPetSpell(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupPlayerMoney)
---@param copper number
function PickupPlayerMoney(copper) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupPvpTalent)
function PickupPvpTalent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupSpell)
---@param spellID number
function PickupSpell(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupSpellBookItem)
function PickupSpellBookItem(spellSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupStablePet)
function PickupStablePet(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupTalent)
function PickupTalent(talentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PickupTradeMoney)
---@param copper number
function PickupTradeMoney(copper) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PitchDownStart)
function PitchDownStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PitchDownStop)
function PitchDownStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PitchUpStart)
function PitchUpStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PitchUpStop)
function PitchUpStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlaceAction)
function PlaceAction(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlaceRaidMarker)
function PlaceRaidMarker(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayAutoAcceptQuestSound)
function PlayAutoAcceptQuestSound() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayMusic)
function PlayMusic() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlaySound)
function PlaySound(soundKitID, channel, forceNoDuplicates, runFinishCallback) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlaySoundFile)
function PlaySoundFile() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayVocalErrorSoundID)
function PlayVocalErrorSoundID(vocalErrorSoundID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayerCanTeleport)
function PlayerCanTeleport() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayerEffectiveAttackPower)
function PlayerEffectiveAttackPower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayerHasHearthstone)
function PlayerHasHearthstone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayerHasToy)
function PlayerHasToy(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayerIsPVPInactive)
function PlayerIsPVPInactive(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PortGraveyard)
function PortGraveyard() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PreloadMovie)
function PreloadMovie(movieId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PrevView)
function PrevView() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ProcessExceptionClient)
function ProcessExceptionClient() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ProcessQuestLogRewardFactions)
function ProcessQuestLogRewardFactions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PromoteToAssistant)
function PromoteToAssistant(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PromoteToLeader)
function PromoteToLeader(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PurchaseSlot)
function PurchaseSlot() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PutItemInBackpack)
function PutItemInBackpack() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PutItemInBag)
---@param slotId number
function PutItemInBag(slotId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QueryGuildBankLog)
function QueryGuildBankLog(tab) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QueryGuildBankTab)
function QueryGuildBankTab(tab) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QueryGuildBankText)
function QueryGuildBankText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QueryGuildEventLog)
function QueryGuildEventLog() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QueryGuildNews)
function QueryGuildNews() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QueryGuildRecipes)
function QueryGuildRecipes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestChooseRewardError)
function QuestChooseRewardError() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestFlagsPVP)
function QuestFlagsPVP() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestGetAutoAccept)
function QuestGetAutoAccept() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestGetAutoLaunched)
function QuestGetAutoLaunched() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestHasPOIInfo)
function QuestHasPOIInfo(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestIsDaily)
---@return boolean isDaily
function QuestIsDaily() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestIsFromAdventureMap)
function QuestIsFromAdventureMap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestIsFromAreaTrigger)
function QuestIsFromAreaTrigger() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestIsWeekly)
---@return boolean isWeekly
function QuestIsWeekly() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestLogPushQuest)
function QuestLogPushQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestLogRewardHasTreasurePicker)
function QuestLogRewardHasTreasurePicker() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestLogShouldShowPortrait)
function QuestLogShouldShowPortrait() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestMapUpdateAllQuests)
function QuestMapUpdateAllQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestPOIGetIconInfo)
function QuestPOIGetIconInfo(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestPOIGetSecondaryLocations)
function QuestPOIGetSecondaryLocations(questID, table) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_QuestPOIUpdateIcons)
function QuestPOIUpdateIcons() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Quit)
function Quit() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RaidProfileExists)
function RaidProfileExists(profile) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RaidProfileHasUnsavedChanges)
function RaidProfileHasUnsavedChanges() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RandomRoll)
function RandomRoll(min, max) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReagentBankButtonIDToInvSlotID)
function ReagentBankButtonIDToInvSlotID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RedockChatWindows)
function RedockChatWindows() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RefreshLFGList)
function RefreshLFGList() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RegisterStaticConstants)
function RegisterStaticConstants(table) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RejectProposal)
function RejectProposal() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemoveAutoQuestPopUp)
function RemoveAutoQuestPopUp() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemoveChatWindowChannel)
---@param windowId number
---@param channelName string
function RemoveChatWindowChannel(windowId, channelName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemoveChatWindowMessages)
---@param index number
---@param messageGroup string
function RemoveChatWindowMessages(index, messageGroup) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemoveItemFromArtifact)
function RemoveItemFromArtifact() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemovePvpTalent)
function RemovePvpTalent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemoveTalent)
function RemoveTalent(talentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RemoveTrackedAchievement)
function RemoveTrackedAchievement(achievementID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RenamePetition)
---@param name string
function RenamePetition(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReopenInteraction)
function ReopenInteraction() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RepairAllItems)
function RepairAllItems(guildBankRepair) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReplaceEnchant)
function ReplaceEnchant() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReplaceGuildMaster)
function ReplaceGuildMaster() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReplaceTradeEnchant)
function ReplaceTradeEnchant() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RepopMe)
function RepopMe() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReportBug)
function ReportBug(description) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReportPlayerIsPVPAFK)
function ReportPlayerIsPVPAFK(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReportSuggestion)
function ReportSuggestion(description) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestArtifactCompletionHistory)
function RequestArtifactCompletionHistory() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestBattlefieldScoreData)
function RequestBattlefieldScoreData() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestBattlegroundInstanceInfo)
---@param index number
function RequestBattlegroundInstanceInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestBottomLeftActionBar)
function RequestBottomLeftActionBar() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestGuildChallengeInfo)
function RequestGuildChallengeInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestGuildPartyState)
function RequestGuildPartyState() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestGuildRewards)
function RequestGuildRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestLFDPartyLockInfo)
function RequestLFDPartyLockInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestLFDPlayerLockInfo)
function RequestLFDPlayerLockInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestPVPOptionsEnabled)
function RequestPVPOptionsEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestPVPRewards)
function RequestPVPRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestRaidInfo)
function RequestRaidInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestRandomBattlegroundInstanceInfo)
function RequestRandomBattlegroundInstanceInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestRatedInfo)
function RequestRatedInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequestTimePlayed)
function RequestTimePlayed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RequeueSkirmish)
function RequeueSkirmish() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetAddOns)
function ResetAddOns() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetCPUUsage)
function ResetCPUUsage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetChatColors)
function ResetChatColors() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetChatWindows)
function ResetChatWindows() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetCursor)
function ResetCursor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetDisabledAddOns)
function ResetDisabledAddOns() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetInstances)
function ResetInstances() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetSetMerchantFilter)
function ResetSetMerchantFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetTutorials)
function ResetTutorials() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResetView)
function ResetView(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResistancePercent)
function ResistancePercent(resistance, casterLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RespondInstanceLock)
function RespondInstanceLock() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RespondMailLockSendItem)
function RespondMailLockSendItem(slot, keepItem) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RespondToInviteConfirmation)
function RespondToInviteConfirmation(guid, accept) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RestartGx)
function RestartGx() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RestoreRaidProfileFromCopy)
function RestoreRaidProfileFromCopy() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResurrectGetOfferer)
function ResurrectGetOfferer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResurrectHasSickness)
function ResurrectHasSickness() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ResurrectHasTimer)
function ResurrectHasTimer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RetrieveCorpse)
function RetrieveCorpse() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ReturnInboxItem)
function ReturnInboxItem(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RollOnLoot)
function RollOnLoot(rollId, roll) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RunBinding)
---@param command string
---@param up string
function RunBinding(command, up) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RunMacro)
function RunMacro() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RunMacroText)
---@param macro string
function RunMacroText(macro) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_RunScript)
function RunScript(script) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SaveAddOns)
function SaveAddOns() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SaveBindings)
---@param which number
function SaveBindings(which) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SaveRaidProfileCopy)
function SaveRaidProfileCopy(profile) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SaveView)
---@param viewIndex number
function SaveView(viewIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Screenshot)
function Screenshot() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptsDisallowedForBeta)
function ScriptsDisallowedForBeta() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGGetEncounterResults)
function SearchLFGGetEncounterResults(index, encounterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGGetJoinedID)
function SearchLFGGetJoinedID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGGetNumResults)
---@return number numResults
---@return number totalResults
function SearchLFGGetNumResults() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGGetPartyResults)
function SearchLFGGetPartyResults(index, memberIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGGetResults)
function SearchLFGGetResults(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGJoin)
---@param typeID number
---@param lfgID number
function SearchLFGJoin(typeID, lfgID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGLeave)
function SearchLFGLeave() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SearchLFGSort)
function SearchLFGSort(type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SecureCmdOptionParse)
---@param options string
---@return string result
---@return string target
function SecureCmdOptionParse(options) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SelectActiveQuest)
function SelectActiveQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SelectAvailableQuest)
function SelectAvailableQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SelectTrainerService)
---@param index number
function SelectTrainerService(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SelectedRealmName)
---@return string realmName
function SelectedRealmName() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SellCursorItem)
function SellCursorItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SendChatMessage)
---@param msg string
---@param chatType? string
---@param languageID? number
---@param target? string
function SendChatMessage(msg, chatType, languageID, target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SendMail)
---@param recipient string
---@param subject string
---@param body? string
function SendMail(recipient, subject, body) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SendSystemMessage)
---@param msg string
function SendSystemMessage(msg) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetAchievementComparisonUnit)
function SetAchievementComparisonUnit(unitId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetAchievementSearchString)
---@param searchText string
---@return boolean searchFinished
function SetAchievementSearchString(searchText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetActionBarToggles)
function SetActionBarToggles(show1, show2, show3, show4, alwaysShow) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetActionUIButton)
function SetActionUIButton(checkboxFrame, actionSlot, cooldownFrame) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetAddonVersionCheck)
function SetAddonVersionCheck(boolean) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetAllowDangerousScripts)
function SetAllowDangerousScripts() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetAllowLowLevelRaid)
function SetAllowLowLevelRaid(allowed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetAutoDeclineGuildInvites)
function SetAutoDeclineGuildInvites(checked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBackpackAutosortDisabled)
function SetBackpackAutosortDisabled(disable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBagPortraitTexture)
function SetBagPortraitTexture(texture, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBagSlotFlag)
function SetBagSlotFlag(index, flagIndex, checked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBankAutosortDisabled)
function SetBankAutosortDisabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBankBagSlotFlag)
function SetBankBagSlotFlag() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBarSlotFromIntro)
function SetBarSlotFromIntro(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBattlefieldScoreFaction)
function SetBattlefieldScoreFaction(faction) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBinding)
function SetBinding(key, command, mode) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBindingClick)
---@param key string
---@param buttonName string
---@param button string
---@return boolean ok
function SetBindingClick(key, buttonName, button) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBindingItem)
---@param key string
---@param item string
---@return boolean ok
function SetBindingItem(key, item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBindingMacro)
function SetBindingMacro() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetBindingSpell)
---@param key string
---@param spell string
---@return boolean ok
function SetBindingSpell(key, spell) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetCemeteryPreference)
function SetCemeteryPreference(cemeteryID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChannelOwner)
function SetChannelOwner(channel, name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChannelPassword)
function SetChannelPassword(channel, password) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatColorNameByClass)
function SetChatColorNameByClass(chatType, colorNameByClass) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowAlpha)
function SetChatWindowAlpha(index, alpha) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowColor)
function SetChatWindowColor(index, r, g, b) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowDocked)
function SetChatWindowDocked(index, docked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowLocked)
function SetChatWindowLocked(index, locked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowName)
function SetChatWindowName(index, name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowSavedDimensions)
function SetChatWindowSavedDimensions(index, width, height) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowSavedPosition)
function SetChatWindowSavedPosition(index, point, xOffsetRatio, yOffsetRatio) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowShown)
function SetChatWindowShown(index, shown) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowSize)
function SetChatWindowSize(index, size) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetChatWindowUninteractable)
function SetChatWindowUninteractable(id, isUninteractable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetConsoleKey)
---@param key string
function SetConsoleKey(key) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetCurrentGraphicsSetting)
function SetCurrentGraphicsSetting() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetCurrentGuildBankTab)
function SetCurrentGuildBankTab(tab) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetCurrentTitle)
---@param titleId number
function SetCurrentTitle(titleId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetCursor)
---@param cursor string
---@return boolean changed
function SetCursor(cursor) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetCursorVirtualItem)
function SetCursorVirtualItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetDefaultVideoOptions)
function SetDefaultVideoOptions(value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetDungeonDifficultyID)
---@param difficultyIndex number
function SetDungeonDifficultyID(difficultyIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetEuropeanNumbers)
function SetEuropeanNumbers(flag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetEveryoneIsAssistant)
function SetEveryoneIsAssistant() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetFactionActive)
---@param index number
function SetFactionActive(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetFactionInactive)
---@param index number
function SetFactionInactive(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetFocusedAchievement)
function SetFocusedAchievement(achievementID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGamePadCursorControl)
function SetGamePadCursorControl() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGamePadFreeLook)
function SetGamePadFreeLook() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildBankTabInfo)
---@param tab number
---@param name string
---@param icon number
function SetGuildBankTabInfo(tab, name, icon) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildBankTabItemWithdraw)
function SetGuildBankTabItemWithdraw() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildBankTabPermissions)
---@param tab number
---@param index number
---@param enabled boolean
function SetGuildBankTabPermissions(tab, index, enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildBankText)
---@param tab number
---@param infoText string
function SetGuildBankText(tab, infoText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildBankWithdrawGoldLimit)
function SetGuildBankWithdrawGoldLimit(amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildInfoText)
function SetGuildInfoText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildMemberRank)
function SetGuildMemberRank(playerIndex, rankIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildNewsFilter)
function SetGuildNewsFilter(index, bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildRosterSelection)
function SetGuildRosterSelection(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildRosterShowOffline)
function SetGuildRosterShowOffline(enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildTradeSkillCategoryFilter)
function SetGuildTradeSkillCategoryFilter(tradeSkillID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetGuildTradeSkillItemNameFilter)
function SetGuildTradeSkillItemNameFilter(itemName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetInWorldUIVisibility)
function SetInWorldUIVisibility(visible) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetInsertItemsLeftToRight)
function SetInsertItemsLeftToRight(disable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetInventoryPortraitTexture)
function SetInventoryPortraitTexture(texture, unit, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetItemSearch)
function SetItemSearch(search) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLFGBootVote)
function SetLFGBootVote(shouldKick) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLFGComment)
function SetLFGComment(comment) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLFGDungeon)
function SetLFGDungeon(LE_LFG_CATEGORY, type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLFGDungeonEnabled)
function SetLFGDungeonEnabled(dungeonID, isEnabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLFGHeaderCollapsed)
function SetLFGHeaderCollapsed(headerID, isCollapsed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLFGRoles)
function SetLFGRoles(leader, tank, healer, dps) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLegacyRaidDifficultyID)
function SetLegacyRaidDifficultyID(difficultyID, force) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLootMethod)
function SetLootMethod() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLootPortrait)
function SetLootPortrait() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLootSpecialization)
---@param specID number
function SetLootSpecialization(specID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetLootThreshold)
---@param threshold number
function SetLootThreshold(threshold) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetMacroItem)
function SetMacroItem(macro, item, target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetMacroSpell)
function SetMacroSpell(macro, spell, target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetMerchantFilter)
function SetMerchantFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetModifiedClick)
---@param action string
---@param key string
function SetModifiedClick(action, key) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetMouselookOverrideBinding)
function SetMouselookOverrideBinding(key, command) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetMoveEnabled)
function SetMoveEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetMultiCastSpell)
function SetMultiCastSpell(actionID, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetOptOutOfLoot)
---@param optOut boolean
function SetOptOutOfLoot(optOut) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetOverrideBinding)
function SetOverrideBinding(owner, isPriority, key, command) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetOverrideBindingClick)
function SetOverrideBindingClick(owner, isPriority, key, buttonName, mouseClick) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetOverrideBindingItem)
function SetOverrideBindingItem(owner, isPriority, key, itemname) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetOverrideBindingMacro)
function SetOverrideBindingMacro() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetOverrideBindingSpell)
function SetOverrideBindingSpell(owner, isPriority, key, spellname) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPOIIconOverlapDistance)
function SetPOIIconOverlapDistance(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPOIIconOverlapPushDistance)
function SetPOIIconOverlapPushDistance(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPVP)
function SetPVP(enable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPVPRoles)
---@param tank boolean
---@param healer boolean
---@param dps boolean
function SetPVPRoles(tank, healer, dps) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPartyAssignment)
function SetPartyAssignment(assignment, player) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPetSlot)
function SetPetSlot(index, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPetStablePaperdoll)
function SetPetStablePaperdoll(modelObject) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPortraitToTexture)
function SetPortraitToTexture(textureObject, texturePath) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetRaidDifficultyID)
---@param difficultyIndex number
function SetRaidDifficultyID(difficultyIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetRaidProfileOption)
function SetRaidProfileOption(profile, optionName, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetRaidProfileSavedPosition)
function SetRaidProfileSavedPosition(profile, isDynamic, topPoint, topOffset, bottomPoint, bottomOffset, leftPoint, leftOffset) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetRaidSubgroup)
function SetRaidSubgroup(index, subgroup) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetRaidTarget)
---@param unit string
---@param index number
function SetRaidTarget(unit, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetRaidTargetProtected)
function SetRaidTargetProtected(unit, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSavedInstanceExtend)
function SetSavedInstanceExtend(index, extend) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetScreenResolution)
function SetScreenResolution(width, height, fullscreen) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSelectedArtifact)
function SetSelectedArtifact(raceIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSelectedDisplayChannel)
function SetSelectedDisplayChannel(channelID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSelectedFaction)
function SetSelectedFaction(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSelectedScreenResolutionIndex)
function SetSelectedScreenResolutionIndex(integerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSelectedWarGameType)
function SetSelectedWarGameType(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSendMailCOD)
function SetSendMailCOD(amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSendMailMoney)
function SetSendMailMoney(amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSendMailShowing)
function SetSendMailShowing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSortBagsRightToLeft)
function SetSortBagsRightToLeft(disable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSpecialization)
---@param specIndex number
---@param isPet boolean
function SetSpecialization(specIndex, isPet) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetSpellbookPetAction)
function SetSpellbookPetAction(slot, target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTaxiBenchmarkMode)
function SetTaxiBenchmarkMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTaxiMap)
---@param texture string
function SetTaxiMap(texture) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTracking)
function SetTracking(id, enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTradeCurrency)
function SetTradeCurrency(type, amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTradeMoney)
function SetTradeMoney(copper) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTrainerServiceTypeFilter)
function SetTrainerServiceTypeFilter(filter, state) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetTurnEnabled)
function SetTurnEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetUIVisibility)
function SetUIVisibility(visible) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetView)
---@param viewIndex number
function SetView(viewIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetWatchedFactionIndex)
---@param index number
function SetWatchedFactionIndex(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetupFullscreenScale)
function SetupFullscreenScale(frame) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShouldShowIslandsWeeklyPOI)
---@return boolean show
function ShouldShowIslandsWeeklyPOI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShouldShowSpecialSplashScreen)
---@return boolean show
function ShouldShowSpecialSplashScreen() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowAccountAchievements)
---@param show boolean
function ShowAccountAchievements(show) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowBossFrameWhenUninteractable)
function ShowBossFrameWhenUninteractable(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowBuybackSellCursor)
function ShowBuybackSellCursor(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowContainerSellCursor)
function ShowContainerSellCursor(index, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowInventorySellCursor)
function ShowInventorySellCursor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowQuestComplete)
---@param questLogIndex number
function ShowQuestComplete(questLogIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowQuestOffer)
function ShowQuestOffer(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ShowRepairCursor)
function ShowRepairCursor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SignPetition)
function SignPetition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SitStandOrDescendStart)
function SitStandOrDescendStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SocketContainerItem)
function SocketContainerItem(bag, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SocketInventoryItem)
function SocketInventoryItem(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SocketItemToArtifact)
function SocketItemToArtifact() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SolveArtifact)
function SolveArtifact() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortBGList)
function SortBGList() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortBags)
function SortBags() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortBankBags)
function SortBankBags() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortBattlefieldScoreData)
function SortBattlefieldScoreData(type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortGuildRoster)
function SortGuildRoster(sort) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortGuildTradeSkill)
function SortGuildTradeSkill(type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortQuestSortTypes)
function SortQuestSortTypes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortQuests)
function SortQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SortReagentBankBags)
function SortReagentBankBags() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_ChatSystem_GetInputDriverNameByIndex)
function Sound_ChatSystem_GetInputDriverNameByIndex(InputDriverIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_ChatSystem_GetNumInputDrivers)
function Sound_ChatSystem_GetNumInputDrivers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_ChatSystem_GetNumOutputDrivers)
function Sound_ChatSystem_GetNumOutputDrivers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_ChatSystem_GetOutputDriverNameByIndex)
function Sound_ChatSystem_GetOutputDriverNameByIndex(OutputDriverIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_GameSystem_GetInputDriverNameByIndex)
function Sound_GameSystem_GetInputDriverNameByIndex(InputDriverIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_GameSystem_GetNumInputDrivers)
function Sound_GameSystem_GetNumInputDrivers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_GameSystem_GetNumOutputDrivers)
function Sound_GameSystem_GetNumOutputDrivers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_GameSystem_GetOutputDriverNameByIndex)
function Sound_GameSystem_GetOutputDriverNameByIndex(OutputDriverIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Sound_GameSystem_RestartSoundSystem)
function Sound_GameSystem_RestartSoundSystem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetGarrisonFollower)
function SpellCanTargetGarrisonFollower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetGarrisonFollowerAbility)
function SpellCanTargetGarrisonFollowerAbility() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetGarrisonMission)
function SpellCanTargetGarrisonMission() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetItem)
function SpellCanTargetItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetItemID)
function SpellCanTargetItemID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetQuest)
function SpellCanTargetQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCanTargetUnit)
function SpellCanTargetUnit(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellCancelQueuedSpell)
function SpellCancelQueuedSpell() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellGetVisibilityInfo)
---@param spellId number
---@param visType string
---@return boolean hasCustom
---@return boolean alwaysShowMine
---@return boolean showForMySpec
function SpellGetVisibilityInfo(spellId, visType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellHasRange)
function SpellHasRange(spell) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellIsAlwaysShown)
function SpellIsAlwaysShown(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellIsPriorityAura)
function SpellIsPriorityAura(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellIsSelfBuff)
function SpellIsSelfBuff(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellIsTargeting)
---@return boolean isTargeting
function SpellIsTargeting() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellStopCasting)
---@return boolean stopped
function SpellStopCasting() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellStopTargeting)
function SpellStopTargeting() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellTargetItem)
function SpellTargetItem(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SpellTargetUnit)
---@param unitId string
function SpellTargetUnit(unitId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SplashFrameCanBeShown)
function SplashFrameCanBeShown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SplitContainerItem)
function SplitContainerItem(bagID, slot, amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SplitGuildBankItem)
function SplitGuildBankItem(tab, slot, amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartAttack)
function StartAttack() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartAutoRun)
function StartAutoRun() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartDuel)
function StartDuel(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartSoloShuffleWarGameByName)
function StartSoloShuffleWarGameByName() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartSpectatorSoloShuffleWarGame)
function StartSpectatorSoloShuffleWarGame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartSpectatorWarGame)
function StartSpectatorWarGame(target1, target2, size, area, isTournamentMode) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartWarGame)
function StartWarGame(target, name, isTournament) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StartWarGameByName)
function StartWarGameByName(msg) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StopAttack)
function StopAttack() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StopAutoRun)
function StopAutoRun() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StopCinematic)
function StopCinematic() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StopMacro)
function StopMacro() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StopMusic)
function StopMusic() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StopSound)
---@param soundHandle number
---@param fadeoutTime number
function StopSound(soundHandle, fadeoutTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StoreSecureReference)
function StoreSecureReference(name, obj) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StrafeLeftStart)
function StrafeLeftStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StrafeLeftStop)
function StrafeLeftStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StrafeRightStart)
---@param startTime number
function StrafeRightStart(startTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_StrafeRightStop)
function StrafeRightStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Stuck)
function Stuck() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SubmitRequiredGuildRename)
function SubmitRequiredGuildRename() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SummonFriend)
function SummonFriend(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SummonRandomCritter)
function SummonRandomCritter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SupportsClipCursor)
function SupportsClipCursor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SurrenderArena)
function SurrenderArena() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SwapRaidSubgroup)
---@param index1 number
---@param index2 number
function SwapRaidSubgroup(index1, index2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SwitchAchievementSearchTab)
function SwitchAchievementSearchTab(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TakeInboxItem)
function TakeInboxItem(index, itemIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TakeInboxMoney)
function TakeInboxMoney(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TakeInboxTextItem)
function TakeInboxTextItem(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TakeTaxiNode)
---@param index number
function TakeTaxiNode(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetDirectionEnemy)
function TargetDirectionEnemy(facing) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetDirectionFinished)
function TargetDirectionFinished() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetDirectionFriend)
function TargetDirectionFriend(facing) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetLastEnemy)
function TargetLastEnemy() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetLastFriend)
function TargetLastFriend() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetLastTarget)
function TargetLastTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearest)
function TargetNearest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearestEnemy)
---@param reverse boolean
function TargetNearestEnemy(reverse) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearestEnemyPlayer)
function TargetNearestEnemyPlayer(reverseFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearestFriend)
function TargetNearestFriend(reverseFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearestFriendPlayer)
function TargetNearestFriendPlayer(reverseFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearestPartyMember)
function TargetNearestPartyMember() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetNearestRaidMember)
function TargetNearestRaidMember() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetPriorityHighlightEnd)
function TargetPriorityHighlightEnd() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetPriorityHighlightStart)
function TargetPriorityHighlightStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetSpellReplacesBonusTree)
function TargetSpellReplacesBonusTree() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetTotem)
function TargetTotem(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TargetUnit)
function TargetUnit(unit, exactMatch) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiGetDestX)
function TaxiGetDestX(slot, hop) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiGetDestY)
function TaxiGetDestY(slot, hop) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiGetNodeSlot)
function TaxiGetNodeSlot() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiGetSrcX)
function TaxiGetSrcX(slot, hop) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiGetSrcY)
function TaxiGetSrcY(slot, hop) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiIsDirectFlight)
function TaxiIsDirectFlight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiNodeCost)
---@param slot number
---@return number cost
function TaxiNodeCost(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiNodeGetType)
---@param index number
---@return string type
function TaxiNodeGetType(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiNodeName)
---@param index number
---@return string name
function TaxiNodeName(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiNodePosition)
function TaxiNodePosition(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TaxiRequestEarlyLanding)
function TaxiRequestEarlyLanding() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TimeoutResurrect)
function TimeoutResurrect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleAnimKitDisplay)
function ToggleAnimKitDisplay() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleAutoRun)
function ToggleAutoRun() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleDebugAIDisplay)
function ToggleDebugAIDisplay() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TogglePVP)
function TogglePVP() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TogglePetAutocast)
function TogglePetAutocast(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleRun)
function ToggleRun() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleSelfHighlight)
function ToggleSelfHighlight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleSheath)
function ToggleSheath() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleSpellAutocast)
function ToggleSpellAutocast() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ToggleWindowed)
function ToggleWindowed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TriggerTutorial)
function TriggerTutorial(tutorial) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnInGuildCharter)
function TurnInGuildCharter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnLeftStart)
---@param startTime number
function TurnLeftStart(startTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnLeftStop)
function TurnLeftStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnOrActionStart)
function TurnOrActionStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnOrActionStop)
function TurnOrActionStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnRightStart)
---@param startTime number
function TurnRightStart(startTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_TurnRightStop)
function TurnRightStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UninviteUnit)
---@param name string
---@param reason? string
function UninviteUnit(name, reason) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAffectingCombat)
---@param unit string
---@return boolean affectingCombat
function UnitAffectingCombat(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitArmor)
function UnitArmor(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAttackPower)
function UnitAttackPower(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAttackSpeed)
function UnitAttackSpeed(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAura)
---@param unit number
---@param index number
---@param filter? number
---@return string name
---@return number icon
---@return number count
---@return string? dispelType
---@return number duration
---@return number expirationTime
---@return string source
---@return boolean isStealable
---@return boolean nameplateShowPersonal
---@return number spellId
---@return boolean canApplyAura
---@return boolean isBossDebuff
---@return boolean castByPlayer
---@return boolean nameplateShowAll
---@return number timeMod
---@return ...
function UnitAura(unit, index, filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAura)
---@param unit number
---@param index number
---@param filter? number
---@return string name
---@return number icon
---@return number count
---@return string? dispelType
---@return number duration
---@return number expirationTime
---@return string source
---@return boolean isStealable
---@return boolean nameplateShowPersonal
---@return number spellId
---@return boolean canApplyAura
---@return boolean isBossDebuff
---@return boolean castByPlayer
---@return boolean nameplateShowAll
---@return number timeMod
---@return ...
function UnitBuff(unit, index, filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAura)
---@param unit number
---@param index number
---@param filter? number
---@return string name
---@return number icon
---@return number count
---@return string? dispelType
---@return number duration
---@return number expirationTime
---@return string source
---@return boolean isStealable
---@return boolean nameplateShowPersonal
---@return number spellId
---@return boolean canApplyAura
---@return boolean isBossDebuff
---@return boolean castByPlayer
---@return boolean nameplateShowAll
---@return number timeMod
---@return ...
function UnitDebuff(unit, index, filter) end

