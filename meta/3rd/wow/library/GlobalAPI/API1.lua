---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/API_AbandonSkill)
---@param skillLineID number
function AbandonSkill(skillLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptAreaSpiritHeal)
function AcceptAreaSpiritHeal() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptBattlefieldPort)
---@param index number
---@param accept boolean
function AcceptBattlefieldPort(index, accept) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptDuel)
function AcceptDuel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptGroup)
function AcceptGroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptGuild)
function AcceptGuild() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptProposal)
function AcceptProposal() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptQuest)
function AcceptQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptResurrect)
function AcceptResurrect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptSockets)
function AcceptSockets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptSpellConfirmationPrompt)
---@param spellID number
function AcceptSpellConfirmationPrompt(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptTrade)
function AcceptTrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcceptXPLoss)
function AcceptXPLoss() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcknowledgeAutoAcceptQuest)
function AcknowledgeAutoAcceptQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AcknowledgeSurvey)
function AcknowledgeSurvey(caseIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ActionBindsItem)
function ActionBindsItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ActionHasRange)
---@param slotID number
---@return boolean hasRange
function ActionHasRange(slotID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AddAutoQuestPopUp)
---@param questID number
---@param type string
function AddAutoQuestPopUp(questID, type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AddChatWindowChannel)
---@param windowId number
---@param channelName string
function AddChatWindowChannel(windowId, channelName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AddChatWindowMessages)
---@param index number
---@param messageGroup string
function AddChatWindowMessages(index, messageGroup) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AddTrackedAchievement)
---@param achievementID number
function AddTrackedAchievement(achievementID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AddTradeMoney)
function AddTradeMoney() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Ambiguate)
---@param fullName string
---@param context string
---@return string name
function Ambiguate(fullName, context) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AntiAliasingSupported)
function AntiAliasingSupported() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ArchaeologyGetIconInfo)
function ArchaeologyGetIconInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ArchaeologyMapUpdateAll)
---@param uiMapID number
---@return number numSites
function ArchaeologyMapUpdateAll(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ArcheologyGetVisibleBlobID)
function ArcheologyGetVisibleBlobID(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AreAccountAchievementsHidden)
---@return boolean hidden
function AreAccountAchievementsHidden() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AreDangerousScriptsAllowed)
function AreDangerousScriptsAllowed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AreTalentsLocked)
function AreTalentsLocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AscendStop)
function AscendStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AssistUnit)
---@param unit string
function AssistUnit(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AttachGlyphToSpell)
function AttachGlyphToSpell(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AttackTarget)
function AttackTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AutoChooseCurrentGraphicsSetting)
function AutoChooseCurrentGraphicsSetting() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AutoEquipCursorItem)
function AutoEquipCursorItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AutoLootMailItem)
function AutoLootMailItem(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_AutoStoreGuildBankItem)
---@param tab number
---@param slot number
function AutoStoreGuildBankItem(tab, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNAcceptFriendInvite)
function BNAcceptFriendInvite(ID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNCheckBattleTagInviteToGuildMember)
function BNCheckBattleTagInviteToGuildMember(fullname) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNCheckBattleTagInviteToUnit)
function BNCheckBattleTagInviteToUnit(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNConnected)
---@return boolean connected
function BNConnected() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNDeclineFriendInvite)
function BNDeclineFriendInvite(ID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNFeaturesEnabled)
function BNFeaturesEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNFeaturesEnabledAndConnected)
function BNFeaturesEnabledAndConnected() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetBlockedInfo)
function BNGetBlockedInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetDisplayName)
function BNGetDisplayName(bnetIdAccount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetFOFInfo)
---@param mutual boolean
---@param nonMutual boolean
---@param index number
---@return number friendID
---@return string accountName
---@return boolean isMutual
function BNGetFOFInfo(mutual, nonMutual, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetFriendIndex)
---@param presenceID number
---@return number index
function BNGetFriendIndex(presenceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetFriendInviteInfo)
---@param inviteIndex number
---@return number inviteID
---@return number accountName
---@return boolean isBattleTag
---@return unknown unknown
---@return number sentTime
function BNGetFriendInviteInfo(inviteIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetInfo)
---@return number? presenceID
---@return string battleTag
---@return number toonID
---@return string currentBroadcast
---@return boolean bnetAFK
---@return boolean bnetDND
---@return boolean isRIDEnabled
function BNGetInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetNumBlocked)
function BNGetNumBlocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetNumFOF)
function BNGetNumFOF(ID, mutual, non) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetNumFriendInvites)
function BNGetNumFriendInvites() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetNumFriends)
---@return number numBNetTotal
---@return number numBNetOnline
---@return number numBNetFavorite
---@return number numBNetFavoriteOnline
function BNGetNumFriends() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetSelectedBlock)
function BNGetSelectedBlock() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNGetSelectedFriend)
function BNGetSelectedFriend() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNInviteFriend)
function BNInviteFriend(bnetIDGameAccount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNIsBlocked)
function BNIsBlocked(ID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNIsFriend)
function BNIsFriend(presenceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNIsSelf)
function BNIsSelf(presenceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNRemoveFriend)
function BNRemoveFriend(ID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNRequestFOFInfo)
function BNRequestFOFInfo(bnetIDAccount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNRequestInviteFriend)
function BNRequestInviteFriend(presenceID, tank, heal, dps) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSendFriendInvite)
function BNSendFriendInvite(text, noteText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSendFriendInviteByID)
function BNSendFriendInviteByID(ID, noteText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSendGameData)
---@param presenceID number
---@param addonPrefix string
---@param message string
function BNSendGameData(presenceID, addonPrefix, message) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSendSoR)
function BNSendSoR(target, comment) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSendVerifiedBattleTagInvite)
function BNSendVerifiedBattleTagInvite() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSendWhisper)
---@param bnetAccountID number
---@param message string
function BNSendWhisper(bnetAccountID, message) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetAFK)
---@param bool boolean
function BNSetAFK(bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetBlocked)
function BNSetBlocked(ID, bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetCustomMessage)
---@param text string
function BNSetCustomMessage(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetDND)
---@param bool boolean
function BNSetDND(bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetFriendFavoriteFlag)
---@param id number
---@param isFavorite boolean
function BNSetFriendFavoriteFlag(id, isFavorite) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetFriendNote)
---@param bnetIDAccount number
---@param noteText string
function BNSetFriendNote(bnetIDAccount, noteText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetSelectedBlock)
function BNSetSelectedBlock(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSetSelectedFriend)
function BNSetSelectedFriend(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNSummonFriendByIndex)
function BNSummonFriendByIndex(id) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BNTokenFindName)
function BNTokenFindName(target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BankButtonIDToInvSlotID)
function BankButtonIDToInvSlotID(buttonID, isBag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BattlefieldMgrEntryInviteResponse)
function BattlefieldMgrEntryInviteResponse(queueId, accept) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BattlefieldMgrExitRequest)
function BattlefieldMgrExitRequest(queueId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BattlefieldMgrQueueInviteResponse)
function BattlefieldMgrQueueInviteResponse(queueId, accept) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BattlefieldMgrQueueRequest)
function BattlefieldMgrQueueRequest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BattlefieldSetPendingReportTarget)
function BattlefieldSetPendingReportTarget(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BeginTrade)
function BeginTrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BindEnchant)
function BindEnchant() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BreakUpLargeNumbers)
---@param value number
---@return string valueString
function BreakUpLargeNumbers(value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BuyGuildBankTab)
function BuyGuildBankTab() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BuyGuildCharter)
---@param guildName string
function BuyGuildCharter(guildName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BuyMerchantItem)
---@param index number
---@param quantity? number
function BuyMerchantItem(index, quantity) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BuyReagentBank)
function BuyReagentBank() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BuyTrainerService)
---@param index number
function BuyTrainerService(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_BuybackItem)
---@param slot number
function BuybackItem(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.ActivateEntry)
function C_AdventureJournal.ActivateEntry(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.CanBeShown)
function C_AdventureJournal.CanBeShown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.GetNumAvailableSuggestions)
function C_AdventureJournal.GetNumAvailableSuggestions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.GetPrimaryOffset)
function C_AdventureJournal.GetPrimaryOffset() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.GetReward)
function C_AdventureJournal.GetReward() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.GetSuggestions)
function C_AdventureJournal.GetSuggestions(suggestions) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.SetPrimaryOffset)
function C_AdventureJournal.SetPrimaryOffset(offset) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureJournal.UpdateSuggestions)
function C_AdventureJournal.UpdateSuggestions(levelUp) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.Close)
function C_AdventureMap.Close() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetMapID)
function C_AdventureMap.GetMapID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetMapInsetDetailTileInfo)
function C_AdventureMap.GetMapInsetDetailTileInfo(insetIndex, tileIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetMapInsetInfo)
function C_AdventureMap.GetMapInsetInfo(insetIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetNumMapInsets)
function C_AdventureMap.GetNumMapInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetNumQuestOffers)
function C_AdventureMap.GetNumQuestOffers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetNumZoneChoices)
function C_AdventureMap.GetNumZoneChoices() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetQuestInfo)
function C_AdventureMap.GetQuestInfo(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetQuestOfferInfo)
function C_AdventureMap.GetQuestOfferInfo(offerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.GetZoneChoiceInfo)
function C_AdventureMap.GetZoneChoiceInfo(choiceIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AdventureMap.StartQuest)
function C_AdventureMap.StartQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.Close)
function C_BlackMarket.Close() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.GetHotItem)
function C_BlackMarket.GetHotItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.GetItemInfoByID)
function C_BlackMarket.GetItemInfoByID(marketID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.GetItemInfoByIndex)
function C_BlackMarket.GetItemInfoByIndex(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.GetNumItems)
---@return number numItems
function C_BlackMarket.GetNumItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.IsViewOnly)
---@return boolean viewOnly
function C_BlackMarket.IsViewOnly() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.ItemPlaceBid)
---@param marketID number
---@param bid number
function C_BlackMarket.ItemPlaceBid(marketID, bid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BlackMarket.RequestItems)
function C_BlackMarket.RequestItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.AssignPCTDistribution)
function C_CharacterServices.AssignPCTDistribution() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.AssignUpgradeDistribution)
function C_CharacterServices.AssignUpgradeDistribution() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetActiveCharacterUpgradeBoostType)
function C_CharacterServices.GetActiveCharacterUpgradeBoostType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetActiveClassTrialBoostType)
function C_CharacterServices.GetActiveClassTrialBoostType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetAutomaticBoost)
function C_CharacterServices.GetAutomaticBoost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetAutomaticBoostCharacter)
function C_CharacterServices.GetAutomaticBoostCharacter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetCharacterServiceDisplayData)
function C_CharacterServices.GetCharacterServiceDisplayData() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetCharacterServiceDisplayDataByVASType)
function C_CharacterServices.GetCharacterServiceDisplayDataByVASType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetCharacterServiceDisplayInfo)
function C_CharacterServices.GetCharacterServiceDisplayInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.GetVASDistributions)
function C_CharacterServices.GetVASDistributions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.HasRequiredBoostForClassTrial)
function C_CharacterServices.HasRequiredBoostForClassTrial() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.HasRequiredBoostForUnrevoke)
function C_CharacterServices.HasRequiredBoostForUnrevoke() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.SetAutomaticBoost)
function C_CharacterServices.SetAutomaticBoost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServices.SetAutomaticBoostCharacter)
function C_CharacterServices.SetAutomaticBoostCharacter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CharacterServicesPublic.ShouldSeeControlPopup)
function C_CharacterServicesPublic.ShouldSeeControlPopup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClassTrial.GetClassTrialLogoutTimeSeconds)
function C_ClassTrial.GetClassTrialLogoutTimeSeconds() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClassTrial.IsClassTrialCharacter)
function C_ClassTrial.IsClassTrialCharacter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Debug.DashboardIsEnabled)
function C_Debug.DashboardIsEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Debug.GetAllPortLocsForMap)
function C_Debug.GetAllPortLocsForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Debug.GetMapDebugObjects)
function C_Debug.GetMapDebugObjects(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Debug.TeleportToMapDebugObject)
function C_Debug.TeleportToMapDebugObject(pinIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Debug.TeleportToMapLocation)
function C_Debug.TeleportToMapLocation(uiMapID, mapX, mapY) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.AllowMissionStartAboveSoftCap)
function C_Garrison.AllowMissionStartAboveSoftCap(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.AreMissionFollowerRequirementsMet)
function C_Garrison.AreMissionFollowerRequirementsMet(missionRecID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.AssignFollowerToBuilding)
function C_Garrison.AssignFollowerToBuilding(plotInstanceID, followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CanGenerateRecruits)
function C_Garrison.CanGenerateRecruits() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CanOpenMissionChest)
function C_Garrison.CanOpenMissionChest(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CanSetRecruitmentPreference)
function C_Garrison.CanSetRecruitmentPreference() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CanSpellTargetFollowerIDWithAddAbility)
function C_Garrison.CanSpellTargetFollowerIDWithAddAbility(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CanUpgradeGarrison)
function C_Garrison.CanUpgradeGarrison() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CancelConstruction)
function C_Garrison.CancelConstruction(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CastItemSpellOnFollowerAbility)
function C_Garrison.CastItemSpellOnFollowerAbility(followerID, abilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CastSpellOnFollower)
function C_Garrison.CastSpellOnFollower(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CastSpellOnFollowerAbility)
function C_Garrison.CastSpellOnFollowerAbility(followerID, abilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CastSpellOnMission)
function C_Garrison.CastSpellOnMission(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.ClearCompleteTalent)
function C_Garrison.ClearCompleteTalent(garrisonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CloseArchitect)
function C_Garrison.CloseArchitect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CloseGarrisonTradeskillNPC)
function C_Garrison.CloseGarrisonTradeskillNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CloseMissionNPC)
function C_Garrison.CloseMissionNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CloseRecruitmentNPC)
function C_Garrison.CloseRecruitmentNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CloseTalentNPC)
function C_Garrison.CloseTalentNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.CloseTradeskillCrafter)
function C_Garrison.CloseTradeskillCrafter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GenerateRecruits)
function C_Garrison.GenerateRecruits(mechanicTypeID, traitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAllBonusAbilityEffects)
function C_Garrison.GetAllBonusAbilityEffects() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAllEncounterThreats)
function C_Garrison.GetAllEncounterThreats(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAvailableMissions)
function C_Garrison.GetAvailableMissions(missionList, garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAvailableRecruits)
function C_Garrison.GetAvailableRecruits() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBasicMissionInfo)
function C_Garrison.GetBasicMissionInfo(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuffedFollowersForMission)
function C_Garrison.GetBuffedFollowersForMission(missionID, displayingAbilities) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingInfo)
function C_Garrison.GetBuildingInfo(buildingID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingLockInfo)
function C_Garrison.GetBuildingLockInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingSizes)
function C_Garrison.GetBuildingSizes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingSpecInfo)
function C_Garrison.GetBuildingSpecInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingTimeRemaining)
function C_Garrison.GetBuildingTimeRemaining(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingTooltip)
function C_Garrison.GetBuildingTooltip(buildingID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingUpgradeInfo)
function C_Garrison.GetBuildingUpgradeInfo(buildingID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildings)
function C_Garrison.GetBuildings(garrisonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingsForPlot)
function C_Garrison.GetBuildingsForPlot(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetBuildingsForSize)
function C_Garrison.GetBuildingsForSize(garrisonType, uiCategoryID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetClassSpecCategoryInfo)
function C_Garrison.GetClassSpecCategoryInfo(garrFollowerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCombatAllyMission)
function C_Garrison.GetCombatAllyMission(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCompleteMissions)
function C_Garrison.GetCompleteMissions(missionList, garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCompleteTalent)
function C_Garrison.GetCompleteTalent(garrisonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCurrencyTypes)
function C_Garrison.GetCurrencyTypes(garrType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilities)
---@param followerID number
---@return table abilities
function C_Garrison.GetFollowerAbilities(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityAtIndex)
function C_Garrison.GetFollowerAbilityAtIndex(followerID, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityAtIndexByID)
function C_Garrison.GetFollowerAbilityAtIndexByID(garrFollowerID, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityCounterMechanicInfo)
function C_Garrison.GetFollowerAbilityCounterMechanicInfo(garrAbilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityCountersForMechanicTypes)
function C_Garrison.GetFollowerAbilityCountersForMechanicTypes(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityDescription)
function C_Garrison.GetFollowerAbilityDescription(garrAbilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityIcon)
function C_Garrison.GetFollowerAbilityIcon(garrAbilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityInfo)
function C_Garrison.GetFollowerAbilityInfo(garrAbilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityIsTrait)
function C_Garrison.GetFollowerAbilityIsTrait(garrAbilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityLink)
function C_Garrison.GetFollowerAbilityLink(abilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAbilityName)
function C_Garrison.GetFollowerAbilityName(garrAbilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerActivationCost)
function C_Garrison.GetFollowerActivationCost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerBiasForMission)
function C_Garrison.GetFollowerBiasForMission(missionID, followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerClassSpec)
function C_Garrison.GetFollowerClassSpec(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerClassSpecAtlas)
function C_Garrison.GetFollowerClassSpecAtlas(garrSpecID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerClassSpecByID)
function C_Garrison.GetFollowerClassSpecByID(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerClassSpecName)
function C_Garrison.GetFollowerClassSpecName(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerDisplayID)
function C_Garrison.GetFollowerDisplayID(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerInfo)
function C_Garrison.GetFollowerInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerInfoForBuilding)
function C_Garrison.GetFollowerInfoForBuilding() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerIsTroop)
function C_Garrison.GetFollowerIsTroop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerItemLevelAverage)
function C_Garrison.GetFollowerItemLevelAverage(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerItems)
function C_Garrison.GetFollowerItems(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerLevel)
function C_Garrison.GetFollowerLevel(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerLevelXP)
function C_Garrison.GetFollowerLevelXP(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerLink)
function C_Garrison.GetFollowerLink(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerLinkByID)
function C_Garrison.GetFollowerLinkByID(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerMissionTimeLeft)
function C_Garrison.GetFollowerMissionTimeLeft(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerMissionTimeLeftSeconds)
function C_Garrison.GetFollowerMissionTimeLeftSeconds(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerModelItems)
function C_Garrison.GetFollowerModelItems(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerName)
function C_Garrison.GetFollowerName(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerNameByID)
function C_Garrison.GetFollowerNameByID(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerPortraitIconID)
function C_Garrison.GetFollowerPortraitIconID(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerPortraitIconIDByID)
function C_Garrison.GetFollowerPortraitIconIDByID(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerQuality)
function C_Garrison.GetFollowerQuality(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerQualityTable)
function C_Garrison.GetFollowerQualityTable(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerRecentlyGainedAbilityIDs)
function C_Garrison.GetFollowerRecentlyGainedAbilityIDs(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerRecentlyGainedTraitIDs)
function C_Garrison.GetFollowerRecentlyGainedTraitIDs(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerShipments)
function C_Garrison.GetFollowerShipments(garrTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerSoftCap)
function C_Garrison.GetFollowerSoftCap(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerSourceTextByID)
function C_Garrison.GetFollowerSourceTextByID(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerSpecializationAtIndex)
function C_Garrison.GetFollowerSpecializationAtIndex(followerID, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerStatus)
function C_Garrison.GetFollowerStatus(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerTraitAtIndex)
function C_Garrison.GetFollowerTraitAtIndex(followerID, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerTraitAtIndexByID)
function C_Garrison.GetFollowerTraitAtIndexByID(garrFollowerID, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerTypeByID)
function C_Garrison.GetFollowerTypeByID(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerTypeByMissionID)
function C_Garrison.GetFollowerTypeByMissionID(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerUnderBiasReason)
function C_Garrison.GetFollowerUnderBiasReason(missionID, followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerXP)
function C_Garrison.GetFollowerXP(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerXPTable)
function C_Garrison.GetFollowerXPTable(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerZoneSupportAbilities)
function C_Garrison.GetFollowerZoneSupportAbilities() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowers)
function C_Garrison.GetFollowers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowersSpellsForMission)
function C_Garrison.GetFollowersSpellsForMission(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowersTraitsForMission)
function C_Garrison.GetFollowersTraitsForMission(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetGarrisonInfo)
function C_Garrison.GetGarrisonInfo(garrisonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetGarrisonUpgradeCost)
function C_Garrison.GetGarrisonUpgradeCost(followerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetInProgressMissions)
function C_Garrison.GetInProgressMissions(missionList, garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetLandingPageGarrisonType)
function C_Garrison.GetLandingPageGarrisonType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetLandingPageItems)
function C_Garrison.GetLandingPageItems(garrTypeID, noSort) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetLandingPageShipmentCount)
function C_Garrison.GetLandingPageShipmentCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetLandingPageShipmentInfo)
function C_Garrison.GetLandingPageShipmentInfo(buildingID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetLandingPageShipmentInfoByContainerID)
function C_Garrison.GetLandingPageShipmentInfoByContainerID(shipmentContainerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetLooseShipments)
---@param garrisonType number
---@return table looseShipments
function C_Garrison.GetLooseShipments(garrisonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionBonusAbilityEffects)
function C_Garrison.GetMissionBonusAbilityEffects(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionCost)
function C_Garrison.GetMissionCost(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionDisplayIDs)
function C_Garrison.GetMissionDisplayIDs(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionLink)
function C_Garrison.GetMissionLink(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionMaxFollowers)
function C_Garrison.GetMissionMaxFollowers(garrMissionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionName)
function C_Garrison.GetMissionName(garrMissionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionRewardInfo)
function C_Garrison.GetMissionRewardInfo(garrMissionID, missionDBID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionSuccessChance)
function C_Garrison.GetMissionSuccessChance(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionTexture)
function C_Garrison.GetMissionTexture(offeredGarrMissionTextureID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionTimes)
function C_Garrison.GetMissionTimes(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionUncounteredMechanics)
function C_Garrison.GetMissionUncounteredMechanics(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumActiveFollowers)
function C_Garrison.GetNumActiveFollowers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumFollowerActivationsRemaining)
function C_Garrison.GetNumFollowerActivationsRemaining(garrTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumFollowerDailyActivations)
function C_Garrison.GetNumFollowerDailyActivations() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumFollowers)
function C_Garrison.GetNumFollowers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumFollowersForMechanic)
function C_Garrison.GetNumFollowersForMechanic(followerType, mechanicID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumFollowersOnMission)
function C_Garrison.GetNumFollowersOnMission(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumPendingShipments)
function C_Garrison.GetNumPendingShipments() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumShipmentCurrencies)
function C_Garrison.GetNumShipmentCurrencies() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetNumShipmentReagents)
function C_Garrison.GetNumShipmentReagents() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetOwnedBuildingInfo)
function C_Garrison.GetOwnedBuildingInfo(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetOwnedBuildingInfoAbbrev)
---@param plotID number
---@return number id
---@return string name
---@return string textureKit
---@return number icon
---@return number rank
---@return boolean isBuilding
---@return number timeStart
---@return number buildTime
---@return boolean canActivate
---@return boolean canUpgrade
---@return boolean isPrebuilt
function C_Garrison.GetOwnedBuildingInfoAbbrev(plotID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPartyBuffs)
function C_Garrison.GetPartyBuffs(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPartyMentorLevels)
function C_Garrison.GetPartyMentorLevels(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPartyMissionInfo)
function C_Garrison.GetPartyMissionInfo(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPendingShipmentInfo)
function C_Garrison.GetPendingShipmentInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPlots)
function C_Garrison.GetPlots(followerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPlotsForBuilding)
function C_Garrison.GetPlotsForBuilding(buildingID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetPossibleFollowersForBuilding)
function C_Garrison.GetPossibleFollowersForBuilding(followerType, plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetRecruitAbilities)
function C_Garrison.GetRecruitAbilities(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetRecruiterAbilityCategories)
function C_Garrison.GetRecruiterAbilityCategories() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetRecruiterAbilityList)
function C_Garrison.GetRecruiterAbilityList(traits) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetRecruitmentPreferences)
function C_Garrison.GetRecruitmentPreferences() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetShipDeathAnimInfo)
function C_Garrison.GetShipDeathAnimInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetShipmentContainerInfo)
function C_Garrison.GetShipmentContainerInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetShipmentItemInfo)
function C_Garrison.GetShipmentItemInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetShipmentReagentCurrencyInfo)
function C_Garrison.GetShipmentReagentCurrencyInfo(currencyIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetShipmentReagentInfo)
function C_Garrison.GetShipmentReagentInfo(reagentIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetShipmentReagentItemLink)
function C_Garrison.GetShipmentReagentItemLink(reagentIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetSpecChangeCost)
function C_Garrison.GetSpecChangeCost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTabForPlot)
function C_Garrison.GetTabForPlot(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.HasGarrison)
function C_Garrison.HasGarrison(garrisonType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.HasShipyard)
function C_Garrison.HasShipyard() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsAboveFollowerSoftCap)
function C_Garrison.IsAboveFollowerSoftCap(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsFollowerCollected)
function C_Garrison.IsFollowerCollected(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsInvasionAvailable)
function C_Garrison.IsInvasionAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsMechanicFullyCountered)
function C_Garrison.IsMechanicFullyCountered(missionID, followerID, mechanicID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsOnGarrisonMap)
function C_Garrison.IsOnGarrisonMap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsOnShipmentQuestForNPC)
function C_Garrison.IsOnShipmentQuestForNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsOnShipyardMap)
function C_Garrison.IsOnShipyardMap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsPlayerInGarrison)
function C_Garrison.IsPlayerInGarrison(garrType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsUsingPartyGarrison)
function C_Garrison.IsUsingPartyGarrison() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsVisitGarrisonAvailable)
function C_Garrison.IsVisitGarrisonAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.MarkMissionComplete)
---@param missionID number
function C_Garrison.MarkMissionComplete(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.MissionBonusRoll)
---@param missionID number
function C_Garrison.MissionBonusRoll(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.PlaceBuilding)
function C_Garrison.PlaceBuilding(plotInstanceID, buildingID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RecruitFollower)
function C_Garrison.RecruitFollower(followerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RemoveFollower)
function C_Garrison.RemoveFollower(dbID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RemoveFollowerFromBuilding)
function C_Garrison.RemoveFollowerFromBuilding() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RenameFollower)
function C_Garrison.RenameFollower(followerID, name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RequestClassSpecCategoryInfo)
function C_Garrison.RequestClassSpecCategoryInfo(garrFollowerTypeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RequestGarrisonUpgradeable)
function C_Garrison.RequestGarrisonUpgradeable(followerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RequestLandingPageShipmentInfo)
function C_Garrison.RequestLandingPageShipmentInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RequestShipmentCreation)
function C_Garrison.RequestShipmentCreation() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RequestShipmentInfo)
function C_Garrison.RequestShipmentInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.ResearchTalent)
function C_Garrison.ResearchTalent(garrTalentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SearchForFollower)
function C_Garrison.SearchForFollower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetBuildingActive)
function C_Garrison.SetBuildingActive(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetBuildingSpecialization)
function C_Garrison.SetBuildingSpecialization() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetFollowerFavorite)
function C_Garrison.SetFollowerFavorite() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetFollowerInactive)
function C_Garrison.SetFollowerInactive(followerID, inactive) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetRecruitmentPreferences)
function C_Garrison.SetRecruitmentPreferences(mechanicTypeID, traitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetUsingPartyGarrison)
---@param enabled boolean
function C_Garrison.SetUsingPartyGarrison(enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.ShouldShowMapTab)
function C_Garrison.ShouldShowMapTab(garrType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.ShowFollowerNameInErrorMessage)
function C_Garrison.ShowFollowerNameInErrorMessage(missionRecID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.StartMission)
---@param missionID number
function C_Garrison.StartMission(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SwapBuildings)
function C_Garrison.SwapBuildings(plotInstanceID1, plotInstanceID2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.TargetSpellHasFollowerItemLevelUpgrade)
function C_Garrison.TargetSpellHasFollowerItemLevelUpgrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.TargetSpellHasFollowerReroll)
function C_Garrison.TargetSpellHasFollowerReroll() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.TargetSpellHasFollowerTemporaryAbility)
function C_Garrison.TargetSpellHasFollowerTemporaryAbility() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.UpgradeBuilding)
function C_Garrison.UpgradeBuilding(plotInstanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.UpgradeGarrison)
function C_Garrison.UpgradeGarrison(followerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.CanHeirloomUpgradeFromPending)
function C_Heirloom.CanHeirloomUpgradeFromPending(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.CreateHeirloom)
function C_Heirloom.CreateHeirloom(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetClassAndSpecFilters)
function C_Heirloom.GetClassAndSpecFilters() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetCollectedHeirloomFilter)
function C_Heirloom.GetCollectedHeirloomFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetHeirloomInfo)
---@param itemID number
---@return string name
---@return string itemEquipLoc
---@return boolean isPvP
---@return string itemTexture
---@return number upgradeLevel
---@return number source
---@return boolean searchFiltered
---@return number effectiveLevel
---@return number minLevel
---@return number maxLevel
function C_Heirloom.GetHeirloomInfo(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetHeirloomItemIDFromDisplayedIndex)
function C_Heirloom.GetHeirloomItemIDFromDisplayedIndex(heirloomIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetHeirloomItemIDs)
function C_Heirloom.GetHeirloomItemIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetHeirloomLink)
function C_Heirloom.GetHeirloomLink(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetHeirloomMaxUpgradeLevel)
function C_Heirloom.GetHeirloomMaxUpgradeLevel(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetHeirloomSourceFilter)
function C_Heirloom.GetHeirloomSourceFilter(source) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetNumDisplayedHeirlooms)
function C_Heirloom.GetNumDisplayedHeirlooms() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetNumHeirlooms)
function C_Heirloom.GetNumHeirlooms() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetNumKnownHeirlooms)
function C_Heirloom.GetNumKnownHeirlooms() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.GetUncollectedHeirloomFilter)
function C_Heirloom.GetUncollectedHeirloomFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.IsHeirloomSourceValid)
function C_Heirloom.IsHeirloomSourceValid(source) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.IsItemHeirloom)
function C_Heirloom.IsItemHeirloom(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.IsPendingHeirloomUpgrade)
function C_Heirloom.IsPendingHeirloomUpgrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.PlayerHasHeirloom)
function C_Heirloom.PlayerHasHeirloom(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.SetClassAndSpecFilters)
function C_Heirloom.SetClassAndSpecFilters(classID, specID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.SetCollectedHeirloomFilter)
function C_Heirloom.SetCollectedHeirloomFilter(boolean) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.SetHeirloomSourceFilter)
function C_Heirloom.SetHeirloomSourceFilter(source, filtered) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.SetSearch)
function C_Heirloom.SetSearch(searchValue) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.SetUncollectedHeirloomFilter)
function C_Heirloom.SetUncollectedHeirloomFilter(boolean) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.ShouldShowHeirloomHelp)
function C_Heirloom.ShouldShowHeirloomHelp() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Heirloom.UpgradeHeirloom)
function C_Heirloom.UpgradeHeirloom(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.AcceptInvite)
function C_LFGList.AcceptInvite(resultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.ApplyToGroup)
---@param resultID number
---@param tankOK? boolean
---@param healerOK? boolean
---@param damageOK? boolean
function C_LFGList.ApplyToGroup(resultID, tankOK, healerOK, damageOK) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.CancelApplication)
function C_LFGList.CancelApplication(resultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.ClearSearchResults)
function C_LFGList.ClearSearchResults() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.CreateListing)
---@param activityID number
---@param itemLevel number
---@param honorLevel number
---@param autoAccept? boolean
---@param privateGroup? boolean
---@param questID? number
---@return boolean success
function C_LFGList.CreateListing(activityID, itemLevel, honorLevel, autoAccept, privateGroup, questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.DeclineApplicant)
function C_LFGList.DeclineApplicant(applicantID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.DeclineInvite)
function C_LFGList.DeclineInvite(searchResultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetActivityIDForQuestID)
function C_LFGList.GetActivityIDForQuestID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetActivityInfoExpensive)
---@param activityID number
---@return boolean currentArea
function C_LFGList.GetActivityInfoExpensive(activityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetApplicantMemberInfo)
---@param applicantID number
---@param memberIndex number
---@return string name
---@return string class
---@return string localizedClass
---@return number level
---@return number itemLevel
---@return number honorLevel
---@return boolean tank
---@return boolean healer
---@return boolean damage
---@return string assignedRole
---@return boolean? relationship
---@return number dungeonScore
---@return number pvpItemLevel
function C_LFGList.GetApplicantMemberInfo(applicantID, memberIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetApplicantMemberStats)
---@param applicantID number
---@param memberIndex number
---@return table stats
function C_LFGList.GetApplicantMemberStats(applicantID, memberIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetApplicants)
---@return table applicants
function C_LFGList.GetApplicants() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetApplicationInfo)
function C_LFGList.GetApplicationInfo(searchResultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetApplications)
function C_LFGList.GetApplications() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetAvailableActivities)
---@param categoryID? number
---@param groupID? number
---@param filter? number
---@return table activities
function C_LFGList.GetAvailableActivities(categoryID, groupID, filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetAvailableActivityGroups)
---@param categoryID number
---@param filter? number
---@return table groups
function C_LFGList.GetAvailableActivityGroups(categoryID, filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetAvailableCategories)
---@param filter? number
---@return table categories
function C_LFGList.GetAvailableCategories(filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetAvailableLanguageSearchFilter)
function C_LFGList.GetAvailableLanguageSearchFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetAvailableRoles)
function C_LFGList.GetAvailableRoles() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetDefaultLanguageSearchFilter)
function C_LFGList.GetDefaultLanguageSearchFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetLanguageSearchFilter)
function C_LFGList.GetLanguageSearchFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetNumApplicants)
function C_LFGList.GetNumApplicants() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetNumApplications)
function C_LFGList.GetNumApplications() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetNumInvitedApplicantMembers)
function C_LFGList.GetNumInvitedApplicantMembers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetNumPendingApplicantMembers)
function C_LFGList.GetNumPendingApplicantMembers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetRoleCheckInfo)
function C_LFGList.GetRoleCheckInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetSearchResultEncounterInfo)
function C_LFGList.GetSearchResultEncounterInfo(searchResultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetSearchResultFriends)
function C_LFGList.GetSearchResultFriends(searchResultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetSearchResultMemberCounts)
function C_LFGList.GetSearchResultMemberCounts(searchResultID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.GetSearchResultMemberInfo)
function C_LFGList.GetSearchResultMemberInfo(searchResultID, memberIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.HasActivityList)
function C_LFGList.HasActivityList() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.InviteApplicant)
---@param applicantID number
function C_LFGList.InviteApplicant(applicantID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.IsCurrentlyApplying)
function C_LFGList.IsCurrentlyApplying() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.RefreshApplicants)
function C_LFGList.RefreshApplicants() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.RemoveApplicant)
function C_LFGList.RemoveApplicant(applicantID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.RemoveListing)
function C_LFGList.RemoveListing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.ReportApplicant)
function C_LFGList.ReportApplicant(applicantID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.ReportSearchResult)
function C_LFGList.ReportSearchResult(resultID, complaintType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.RequestAvailableActivities)
function C_LFGList.RequestAvailableActivities() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.SaveLanguageSearchFilter)
function C_LFGList.SaveLanguageSearchFilter(enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.SetApplicantMemberRole)
function C_LFGList.SetApplicantMemberRole(applicantID, memberIndex, role) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGList.UpdateListing)
function C_LFGList.UpdateListing(lfgID, itemLevel, honorLevel, autoAccept, private, questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.CanMasterLoot)
function C_LootHistory.CanMasterLoot(itemIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.GetExpiration)
function C_LootHistory.GetExpiration() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.GetItem)
function C_LootHistory.GetItem(itemIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.GetNumItems)
function C_LootHistory.GetNumItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.GetPlayerInfo)
function C_LootHistory.GetPlayerInfo(itemIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.GiveMasterLoot)
function C_LootHistory.GiveMasterLoot(itemIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootHistory.SetExpiration)
function C_LootHistory.SetExpiration(numItemsToSave, secondsToSave) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootJournal.GetItemSetItems)
function C_LootJournal.GetItemSetItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LootJournal.GetItemSets)
function C_LootJournal.GetItemSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateEnemyClickThrough)
function C_NamePlate.GetNamePlateEnemyClickThrough() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateEnemyPreferredClickInsets)
function C_NamePlate.GetNamePlateEnemyPreferredClickInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateEnemySize)
function C_NamePlate.GetNamePlateEnemySize() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateForUnit)
function C_NamePlate.GetNamePlateForUnit(unitToken, includeForbidden) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateFriendlyClickThrough)
function C_NamePlate.GetNamePlateFriendlyClickThrough() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateFriendlyPreferredClickInsets)
function C_NamePlate.GetNamePlateFriendlyPreferredClickInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateFriendlySize)
function C_NamePlate.GetNamePlateFriendlySize() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateSelfClickThrough)
function C_NamePlate.GetNamePlateSelfClickThrough() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateSelfPreferredClickInsets)
function C_NamePlate.GetNamePlateSelfPreferredClickInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlateSelfSize)
function C_NamePlate.GetNamePlateSelfSize() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNamePlates)
function C_NamePlate.GetNamePlates(includeForbidden) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetNumNamePlateMotionTypes)
function C_NamePlate.GetNumNamePlateMotionTypes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.GetTargetClampingInsets)
function C_NamePlate.GetTargetClampingInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateEnemyClickThrough)
function C_NamePlate.SetNamePlateEnemyClickThrough(clickthrough) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateEnemyPreferredClickInsets)
function C_NamePlate.SetNamePlateEnemyPreferredClickInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateEnemySize)
function C_NamePlate.SetNamePlateEnemySize(width, height) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateFriendlyClickThrough)
function C_NamePlate.SetNamePlateFriendlyClickThrough() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateFriendlyPreferredClickInsets)
function C_NamePlate.SetNamePlateFriendlyPreferredClickInsets(left, right, top, bottom) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateFriendlySize)
function C_NamePlate.SetNamePlateFriendlySize(width, height) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateSelfClickThrough)
function C_NamePlate.SetNamePlateSelfClickThrough(clickthrough) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateSelfPreferredClickInsets)
function C_NamePlate.SetNamePlateSelfPreferredClickInsets(left, right, top, bottom) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetNamePlateSelfSize)
function C_NamePlate.SetNamePlateSelfSize(width, height) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NamePlate.SetTargetClampingInsets)
function C_NamePlate.SetTargetClampingInsets(clickthrough) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NewItems.ClearAll)
function C_NewItems.ClearAll() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NewItems.IsNewItem)
---@param bag number
---@param slot number
---@return boolean isNewItem
function C_NewItems.IsNewItem(bag, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_NewItems.RemoveNewItem)
function C_NewItems.RemoveNewItem(bag, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.AcceptPVPDuel)
function C_PetBattles.AcceptPVPDuel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.AcceptQueuedPVPMatch)
function C_PetBattles.AcceptQueuedPVPMatch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.CanAcceptQueuedPVPMatch)
---@return boolean canAccept
function C_PetBattles.CanAcceptQueuedPVPMatch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.CanActivePetSwapOut)
---@return boolean usable
function C_PetBattles.CanActivePetSwapOut() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.CanPetSwapIn)
---@param petIndex number
---@return boolean usable
function C_PetBattles.CanPetSwapIn(petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.CancelPVPDuel)
function C_PetBattles.CancelPVPDuel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.ChangePet)
---@param petIndex number
function C_PetBattles.ChangePet(petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.DeclineQueuedPVPMatch)
function C_PetBattles.DeclineQueuedPVPMatch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.ForfeitGame)
function C_PetBattles.ForfeitGame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAbilityEffectInfo)
---@param abilityID number
---@param turnIndex number
---@param effectIndex number
---@param effectName string
---@return number value
function C_PetBattles.GetAbilityEffectInfo(abilityID, turnIndex, effectIndex, effectName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAbilityInfo)
---@param petOwner number
---@param petIndex number
---@param abilityIndex number
---@return number id
---@return string name
---@return string icon
---@return number maxCooldown
---@return string unparsedDescription
---@return number numTurns
---@return number petType
---@return boolean noStrongWeakHints
function C_PetBattles.GetAbilityInfo(petOwner, petIndex, abilityIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAbilityInfoByID)
function C_PetBattles.GetAbilityInfoByID(abilityID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAbilityProcTurnIndex)
---@param abilityID number
---@param procType number
---@return number turnIndex
function C_PetBattles.GetAbilityProcTurnIndex(abilityID, procType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAbilityState)
---@param petOwner number
---@param petIndex number
---@param actionIndex number
---@return boolean isUsable
---@return number currentCooldown
---@return number currentLockdown
function C_PetBattles.GetAbilityState(petOwner, petIndex, actionIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAbilityStateModification)
---@param abilityID number
---@param stateID number
---@return number abilityStateMod
function C_PetBattles.GetAbilityStateModification(abilityID, stateID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetActivePet)
---@param petOwner number
---@return number petIndex
function C_PetBattles.GetActivePet(petOwner) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAllEffectNames)
function C_PetBattles.GetAllEffectNames() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAllStates)
function C_PetBattles.GetAllStates() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAttackModifier)
---@param petType number
---@param enemyPetType number
---@return number modifier
function C_PetBattles.GetAttackModifier(petType, enemyPetType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetAuraInfo)
---@param petOwner number
---@param petIndex number
---@param auraIndex number
---@return number auraID
---@return number instanceID
---@return number turnsRemaining
---@return boolean isBuff
function C_PetBattles.GetAuraInfo(petOwner, petIndex, auraIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetBattleState)
---@return number battleState
function C_PetBattles.GetBattleState() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetDisplayID)
---@param petOwner number
---@param petIndex number
---@return number displayID
function C_PetBattles.GetDisplayID(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetForfeitPenalty)
---@return number forfeitPenalty
function C_PetBattles.GetForfeitPenalty() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetHealth)
---@param petOwner number
---@param petIndex number
---@return number health
function C_PetBattles.GetHealth(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetLevel)
---@param petOwner number
---@param petIndex number
---@return number level
function C_PetBattles.GetLevel(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetMaxHealth)
---@param petOwner number
---@param petIndex number
---@return number maxHealth
function C_PetBattles.GetMaxHealth(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetNumAuras)
---@param petOwner number
---@param petIndex number
---@return number numAuras
function C_PetBattles.GetNumAuras(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetNumPets)
---@param petOwner number
---@return number numPets
function C_PetBattles.GetNumPets(petOwner) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetPVPMatchmakingInfo)
---@return string queueState
---@return number estimatedTime
---@return number queuedTime
function C_PetBattles.GetPVPMatchmakingInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetPetSpeciesID)
---@param petOwner number
---@param petIndex number
---@return number speciesID
function C_PetBattles.GetPetSpeciesID(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetPetType)
---@param petOwner number
---@param petIndex number
---@return number petType
function C_PetBattles.GetPetType(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetPlayerTrapAbility)
---@return number trapAbilityID
function C_PetBattles.GetPlayerTrapAbility() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetPower)
---@param petOwner number
---@param petIndex number
---@return number power
function C_PetBattles.GetPower(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetSelectedAction)
---@return number selectedActionType
---@return number selectedActionIndex
function C_PetBattles.GetSelectedAction() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetSpeed)
---@param petOwner number
---@param petIndex number
---@return number speed
function C_PetBattles.GetSpeed(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetStateValue)
---@param petOwner number
---@param petIndex number
---@param stateID number
---@return number stateValue
function C_PetBattles.GetStateValue(petOwner, petIndex, stateID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetTurnTimeInfo)
---@return number timeRemaining
---@return number turnTime
function C_PetBattles.GetTurnTimeInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetXP)
---@param petOwner number
---@param petIndex number
---@return number xp
---@return number maxXp
function C_PetBattles.GetXP(petOwner, petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.IsInBattle)
---@return boolean inBattle
function C_PetBattles.IsInBattle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.IsSkipAvailable)
---@return boolean usable
function C_PetBattles.IsSkipAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.IsTrapAvailable)
---@return boolean usable
function C_PetBattles.IsTrapAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.IsWaitingOnOpponent)
---@return boolean isWaiting
function C_PetBattles.IsWaitingOnOpponent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.SetPendingReportBattlePetTarget)
---@param petIndex number
function C_PetBattles.SetPendingReportBattlePetTarget(petIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.SetPendingReportTargetFromUnit)
---@param unit string
function C_PetBattles.SetPendingReportTargetFromUnit(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.ShouldShowPetSelect)
---@return boolean shouldShow
function C_PetBattles.ShouldShowPetSelect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.SkipTurn)
function C_PetBattles.SkipTurn() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.StartPVPDuel)
function C_PetBattles.StartPVPDuel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.StartPVPMatchmaking)
function C_PetBattles.StartPVPMatchmaking() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.StopPVPMatchmaking)
function C_PetBattles.StopPVPMatchmaking() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.UseAbility)
---@param actionIndex number
function C_PetBattles.UseAbility(actionIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.UseTrap)
function C_PetBattles.UseTrap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.CagePetByID)
---@param petID string
function C_PetJournal.CagePetByID(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.ClearFanfare)
function C_PetJournal.ClearFanfare() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.ClearRecentFanfares)
function C_PetJournal.ClearRecentFanfares() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.ClearSearchFilter)
function C_PetJournal.ClearSearchFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.FindPetIDByName)
---@param petName string
---@return number speciesId
---@return string petGUID
function C_PetJournal.FindPetIDByName(petName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetBattlePetLink)
---@param petID string
---@return string link
function C_PetJournal.GetBattlePetLink(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetNumCollectedInfo)
---@param speciesId number
---@return number numCollected
---@return number limit
function C_PetJournal.GetNumCollectedInfo(speciesId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetNumPetSources)
---@return number numSources
function C_PetJournal.GetNumPetSources() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetNumPetTypes)
---@return number numTypes
function C_PetJournal.GetNumPetTypes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetNumPets)
---@return number numPets
---@return number numOwned
function C_PetJournal.GetNumPets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetNumPetsNeedingFanfare)
function C_PetJournal.GetNumPetsNeedingFanfare() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetOwnedBattlePetString)
---@param speciesId number
---@return string ownedString
function C_PetJournal.GetOwnedBattlePetString(speciesId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetAbilityList)
function C_PetJournal.GetPetAbilityList(speciesID, idTable, levelTable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetCooldownByGUID)
---@param GUID string
---@return number start
---@return number duration
---@return number isEnabled
function C_PetJournal.GetPetCooldownByGUID(GUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetInfoByIndex)
function C_PetJournal.GetPetInfoByIndex(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetInfoByItemID)
function C_PetJournal.GetPetInfoByItemID(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetInfoByPetID)
function C_PetJournal.GetPetInfoByPetID(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetInfoBySpeciesID)
function C_PetJournal.GetPetInfoBySpeciesID(speciesID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetModelSceneInfoBySpeciesID)
function C_PetJournal.GetPetModelSceneInfoBySpeciesID(speciesID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetSortParameter)
---@return number sortParameter
function C_PetJournal.GetPetSortParameter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetStats)
---@param petID string
---@return number health
---@return number maxHealth
---@return number power
---@return number speed
---@return number rarity
function C_PetJournal.GetPetStats(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetPetTeamAverageLevel)
---@return number avgLevel
function C_PetJournal.GetPetTeamAverageLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetSummonBattlePetCooldown)
function C_PetJournal.GetSummonBattlePetCooldown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetSummonRandomFavoritePetGUID)
function C_PetJournal.GetSummonRandomFavoritePetGUID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.GetSummonedPetGUID)
---@return string summonedPetGUID
function C_PetJournal.GetSummonedPetGUID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.IsFilterChecked)
---@param filter number
---@return boolean isFiltered
function C_PetJournal.IsFilterChecked(filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.IsFindBattleEnabled)
---@return boolean isEnabled
function C_PetJournal.IsFindBattleEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.IsJournalReadOnly)
function C_PetJournal.IsJournalReadOnly() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.IsJournalUnlocked)
function C_PetJournal.IsJournalUnlocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.IsPetSourceChecked)
---@param index number
---@return boolean isChecked
function C_PetJournal.IsPetSourceChecked(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.IsPetTypeChecked)
---@param index number
---@return boolean isChecked
function C_PetJournal.IsPetTypeChecked(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetCanBeReleased)
---@param petID string
---@return boolean canRelease
function C_PetJournal.PetCanBeReleased(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsCapturable)
---@param petID string
---@return boolean isCapturable
function C_PetJournal.PetIsCapturable(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsFavorite)
---@param petGUID string
---@return boolean isFavorite
function C_PetJournal.PetIsFavorite(petGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsHurt)
---@param petID string
---@return boolean isHurt
function C_PetJournal.PetIsHurt(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsLockedForConvert)
function C_PetJournal.PetIsLockedForConvert(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsRevoked)
---@param petID string
---@return boolean isRevoked
function C_PetJournal.PetIsRevoked(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsSlotted)
---@param petID string
---@return boolean isSlotted
function C_PetJournal.PetIsSlotted(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsTradable)
---@param petID string
---@return boolean isTradable
function C_PetJournal.PetIsTradable(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetIsUsable)
function C_PetJournal.PetIsUsable(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PetNeedsFanfare)
function C_PetJournal.PetNeedsFanfare() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PickupPet)
---@param petID string
function C_PetJournal.PickupPet(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.PickupSummonRandomPet)
function C_PetJournal.PickupSummonRandomPet() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.ReleasePetByID)
---@param petID string
function C_PetJournal.ReleasePetByID(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetAbility)
---@param slotIndex number
---@param spellIndex number
---@param petSpellID number
function C_PetJournal.SetAbility(slotIndex, spellIndex, petSpellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetAllPetSourcesChecked)
---@param value boolean
function C_PetJournal.SetAllPetSourcesChecked(value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetAllPetTypesChecked)
---@param value boolean
function C_PetJournal.SetAllPetTypesChecked(value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetCustomName)
---@param petID string
---@param customName string
function C_PetJournal.SetCustomName(petID, customName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetFavorite)
---@param petID string
---@param value number
function C_PetJournal.SetFavorite(petID, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetFilterChecked)
---@param filter number
---@param value boolean
function C_PetJournal.SetFilterChecked(filter, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetPetLoadOutInfo)
---@param slotIndex number
---@param petID string
function C_PetJournal.SetPetLoadOutInfo(slotIndex, petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetPetSortParameter)
function C_PetJournal.SetPetSortParameter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetPetSourceChecked)
---@param index number
---@param value boolean
function C_PetJournal.SetPetSourceChecked(index, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetPetTypeFilter)
---@param index number
---@param value boolean
function C_PetJournal.SetPetTypeFilter(index, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SetSearchFilter)
---@param text string
function C_PetJournal.SetSearchFilter(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SummonPetByGUID)
---@param petID string
function C_PetJournal.SummonPetByGUID(petID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetJournal.SummonRandomPet)
---@param favoritePets boolean
function C_PetJournal.SummonRandomPet(favoritePets) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PrototypeDialog.EnsureRemoved)
---@param instanceID number
function C_PrototypeDialog.EnsureRemoved(instanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PrototypeDialog.SelectOption)
---@param instanceID number
---@param optionIndex number
function C_PrototypeDialog.SelectOption(instanceID, optionIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetBonusStepRewardQuestID)
function C_Scenario.GetBonusStepRewardQuestID(stepIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetBonusSteps)
function C_Scenario.GetBonusSteps() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetCriteriaInfo)
function C_Scenario.GetCriteriaInfo(criteriaIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetCriteriaInfoByStep)
function C_Scenario.GetCriteriaInfoByStep(stepID, criteriaIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetInfo)
function C_Scenario.GetInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetProvingGroundsInfo)
---@return number difficulty
---@return number curWave
---@return number maxWave
---@return number duration
function C_Scenario.GetProvingGroundsInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetScenarioIconInfo)
function C_Scenario.GetScenarioIconInfo(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetStepInfo)
function C_Scenario.GetStepInfo(bonusStepIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.GetSupersededObjectives)
function C_Scenario.GetSupersededObjectives() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.IsInScenario)
function C_Scenario.IsInScenario() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.ShouldShowCriteria)
function C_Scenario.ShouldShowCriteria() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Scenario.TreatScenarioAsDungeon)
function C_Scenario.TreatScenarioAsDungeon() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.GetLastSeenCharacterUpgradePopup)
function C_SharedCharacterServices.GetLastSeenCharacterUpgradePopup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.GetLastSeenExpansionTrialPopup)
function C_SharedCharacterServices.GetLastSeenExpansionTrialPopup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.GetUpgradeDistributions)
function C_SharedCharacterServices.GetUpgradeDistributions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.HasFreePromotionalUpgrade)
function C_SharedCharacterServices.HasFreePromotionalUpgrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.HasSeenFreePromotionalUpgradePopup)
function C_SharedCharacterServices.HasSeenFreePromotionalUpgradePopup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.IsPurchaseIDPendingUpgrade)
function C_SharedCharacterServices.IsPurchaseIDPendingUpgrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.QueryClassTrialBoostResult)
function C_SharedCharacterServices.QueryClassTrialBoostResult() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.SetCharacterUpgradePopupSeen)
function C_SharedCharacterServices.SetCharacterUpgradePopupSeen(expansion_id) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.SetExpansionTrialPopupSeen)
function C_SharedCharacterServices.SetExpansionTrialPopupSeen(expansion_id) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SharedCharacterServices.SetPromotionalPopupSeen)
function C_SharedCharacterServices.SetPromotionalPopupSeen(seen) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.RegisterSocialBrowser)
function C_Social.RegisterSocialBrowser() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.SetTextureToScreenshot)
function C_Social.SetTextureToScreenshot(texture, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterPostAchievement)
function C_Social.TwitterPostAchievement(text, width, height, snapshotId, offScreenFrame, lastAchievementID, usedCustomText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterPostItem)
function C_Social.TwitterPostItem(text, width, height, snapshotId, offScreenFrame, lastItemID, usedCustomText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterPostScreenshot)
function C_Social.TwitterPostScreenshot(text, screenshotIndex, texture, usedCustomText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TalkingHead.GetConversationsDeferred)
function C_TalkingHead.GetConversationsDeferred() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TalkingHead.GetCurrentLineAnimationInfo)
function C_TalkingHead.GetCurrentLineAnimationInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TalkingHead.GetCurrentLineInfo)
function C_TalkingHead.GetCurrentLineInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TalkingHead.IgnoreCurrentTalkingHead)
function C_TalkingHead.IgnoreCurrentTalkingHead() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TalkingHead.IsCurrentTalkingHeadIgnored)
function C_TalkingHead.IsCurrentTalkingHeadIgnored() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TalkingHead.SetConversationsDeferred)
function C_TalkingHead.SetConversationsDeferred(deferred) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Timer.After)
---@param duration number
---@param callback function
function C_Timer.After(duration, callback) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.ForceToyRefilter)
function C_ToyBox.ForceToyRefilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.GetCollectedShown)
function C_ToyBox.GetCollectedShown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.GetIsFavorite)
function C_ToyBox.GetIsFavorite(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.GetNumFilteredToys)
function C_ToyBox.GetNumFilteredToys() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.GetNumLearnedDisplayedToys)
function C_ToyBox.GetNumLearnedDisplayedToys() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.GetNumTotalDisplayedToys)
function C_ToyBox.GetNumTotalDisplayedToys() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ToyBox.GetNumToys)
function C_ToyBox.GetNumToys() end

