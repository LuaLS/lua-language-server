---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAuraBySlot)
function UnitAuraBySlot(unit, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAuraSlots)
function UnitAuraSlots(unit, filter, maxSlots, continuationToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitBattlePetLevel)
function UnitBattlePetLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitBattlePetSpeciesID)
function UnitBattlePetSpeciesID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitBattlePetType)
function UnitBattlePetType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCanAssist)
function UnitCanAssist(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCanAttack)
function UnitCanAttack(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCanCooperate)
function UnitCanCooperate(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCanPetBattle)
function UnitCanPetBattle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCastingInfo)
---@param unit string
---@return string name
---@return string text
---@return string texture
---@return number startTimeMS
---@return number endTimeMS
---@return boolean isTradeSkill
---@return string castID
---@return boolean notInterruptible
---@return number spellId
function UnitCastingInfo(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitChannelInfo)
---@param unit string
---@return string name
---@return string text
---@return string texture
---@return number startTimeMS
---@return number endTimeMS
---@return boolean isTradeSkill
---@return boolean notInterruptible
---@return number spellId
function UnitChannelInfo(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitClassification)
---@param unit string
---@return string classification
function UnitClassification(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitControllingVehicle)
function UnitControllingVehicle(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCreatureFamily)
function UnitCreatureFamily(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitCreatureType)
---@param unit string
---@return string creatureType
function UnitCreatureType(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitDamage)
function UnitDamage(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitDetailedThreatSituation)
---@param unit string
---@param mobUnit string
---@return boolean isTanking
---@return number status
---@return number scaledPercentage
---@return number rawPercentage
---@return number threatValue
function UnitDetailedThreatSituation(unit, mobUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitDistanceSquared)
---@param unit string
---@return number distanceSquared
---@return boolean checkedDistance
function UnitDistanceSquared(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitEffectiveLevel)
function UnitEffectiveLevel(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitExists)
---@param unit string
---@return boolean exists
function UnitExists(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitFactionGroup)
---@param unit string
---@return string englishFaction
---@return string localizedFaction
function UnitFactionGroup(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitGUID)
---@param unit WowUnit
---@return string? guid
function UnitGUID(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitGetAvailableRoles)
function UnitGetAvailableRoles() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitGetIncomingHeals)
function UnitGetIncomingHeals(unit, healer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitGetTotalAbsorbs)
---@param unit string
---@return number totalAbsorbs
function UnitGetTotalAbsorbs(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitGetTotalHealAbsorbs)
---@param unit string
---@return number totalHealAbsorbs
function UnitGetTotalHealAbsorbs(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitGroupRolesAssigned)
---@param Unit string
---@return string role
function UnitGroupRolesAssigned(Unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHPPerStamina)
function UnitHPPerStamina() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHasIncomingResurrection)
function UnitHasIncomingResurrection(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHasLFGDeserter)
function UnitHasLFGDeserter(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHasLFGRandomCooldown)
function UnitHasLFGRandomCooldown(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHasRelicSlot)
function UnitHasRelicSlot(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHasVehiclePlayerFrameUI)
function UnitHasVehiclePlayerFrameUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHasVehicleUI)
function UnitHasVehicleUI(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHealth)
function UnitHealth(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHealthMax)
function UnitHealthMax(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHonor)
function UnitHonor(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHonorLevel)
function UnitHonorLevel(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitHonorMax)
function UnitHonorMax(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInAnyGroup)
function UnitInAnyGroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInBattleground)
function UnitInBattleground(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInOtherParty)
function UnitInOtherParty() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInParty)
---@param unit string
---@return boolean inParty
function UnitInParty(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInRaid)
---@param unit string
---@return number? index
function UnitInRaid(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInRange)
function UnitInRange(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInSubgroup)
function UnitInSubgroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInVehicle)
function UnitInVehicle(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInVehicleControlSeat)
function UnitInVehicleControlSeat(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInVehicleHidesPetFrame)
function UnitInVehicleHidesPetFrame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsAFK)
function UnitIsAFK(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsBattlePet)
---@param unit string
---@return boolean isBattlePet
function UnitIsBattlePet(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsBattlePetCompanion)
---@param unit string
---@return boolean isCompanion
function UnitIsBattlePetCompanion(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsCharmed)
---@param unit string
---@return boolean isTrue
function UnitIsCharmed(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsControlling)
function UnitIsControlling(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsCorpse)
function UnitIsCorpse(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsDND)
function UnitIsDND(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsDead)
function UnitIsDead(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsDeadOrGhost)
function UnitIsDeadOrGhost(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsEnemy)
function UnitIsEnemy(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsFeignDeath)
---@param unit string
---@return boolean isFeign
function UnitIsFeignDeath(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsFriend)
function UnitIsFriend(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsGhost)
function UnitIsGhost(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsGroupAssistant)
function UnitIsGroupAssistant() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsGroupLeader)
---@param unit string
---@param partyCategory? number
---@return boolean isLeader
function UnitIsGroupLeader(unit, partyCategory) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsInMyGuild)
function UnitIsInMyGuild(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsMercenary)
function UnitIsMercenary() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsOtherPlayersBattlePet)
---@param unit string
---@return boolean isOther
function UnitIsOtherPlayersBattlePet(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsOtherPlayersPet)
function UnitIsOtherPlayersPet() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsPVP)
function UnitIsPVP(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsPVPFreeForAll)
function UnitIsPVPFreeForAll(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsPVPSanctuary)
function UnitIsPVPSanctuary(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsPlayer)
---@param unit string
---@return boolean isTrue
function UnitIsPlayer(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsPossessed)
---@param unit string
---@return boolean isTrue
function UnitIsPossessed(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsQuestBoss)
function UnitIsQuestBoss(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsRaidOfficer)
function UnitIsRaidOfficer(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsSameServer)
---@param unit string
---@return boolean sameServer
function UnitIsSameServer(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsTapDenied)
---@param unit string
---@return boolean unitIsTapDenied
function UnitIsTapDenied(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsTrivial)
function UnitIsTrivial(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsUnconscious)
function UnitIsUnconscious() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsUnit)
function UnitIsUnit(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsVisible)
function UnitIsVisible(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsWildBattlePet)
---@param unit string
---@return boolean isWild
function UnitIsWildBattlePet(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitLeadsAnyGroup)
function UnitLeadsAnyGroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitLevel)
---@param unit WowUnit
---@return number level
function UnitLevel(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitName)
---@param unit WowUnit
---@return string? name
---@return string? realm
function UnitName(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitName)
---@param unit WowUnit
---@return string? name
---@return string? realm
function UnitFullName(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitName)
---@param unit WowUnit
---@return string? name
---@return string? realm
function UnitNameUnmodified(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitNumPowerBarTimers)
function UnitNumPowerBarTimers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitOnTaxi)
---@param unit string
---@return boolean onTaxi
function UnitOnTaxi(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPVPName)
---@param unit string
---@return string titleName
function UnitPVPName(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPlayerControlled)
---@param unit string
---@return boolean UnitIsPlayerControlled
function UnitPlayerControlled(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPlayerOrPetInParty)
function UnitPlayerOrPetInParty(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPlayerOrPetInRaid)
function UnitPlayerOrPetInRaid(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPosition)
---@param unit string
---@return number posY
---@return number posX
---@return number posZ
---@return number instanceID
function UnitPosition(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPowerBarTimerInfo)
function UnitPowerBarTimerInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPowerType)
---@param unit WowUnit
---@param index? number
---@return PowerType powerType
---@return string powerToken
---@return number altR
---@return number altG
---@return number altB
function UnitPowerType(unit, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitRace)
---@param unit string
---@return string raceName
---@return string raceFile
---@return number raceID
function UnitRace(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitRangedAttackPower)
function UnitRangedAttackPower(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitRangedDamage)
function UnitRangedDamage(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitReaction)
function UnitReaction(unit, otherUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitRealmRelationship)
function UnitRealmRelationship() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitSelectionColor)
---@param UnitId string
---@param useExtendedColors? boolean
---@return number red
---@return number green
---@return number blue
---@return number alpha
function UnitSelectionColor(UnitId, useExtendedColors) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitSelectionType)
---@param UnitId string
---@param useExtendedColors? boolean
---@return number type
function UnitSelectionType(UnitId, useExtendedColors) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitSetRole)
function UnitSetRole() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitShouldDisplayName)
function UnitShouldDisplayName() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitSpellHaste)
---@param unit string
---@return number spellHastePercent
function UnitSpellHaste(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitStagger)
function UnitStagger() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitStat)
function UnitStat(unit, statIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitSwitchToVehicleSeat)
function UnitSwitchToVehicleSeat(unit, seatId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitTargetsVehicleInRaidUI)
function UnitTargetsVehicleInRaidUI(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitThreatPercentageOfLead)
---@param unit string
---@param mobUnit string
---@return number percentage
function UnitThreatPercentageOfLead(unit, mobUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitThreatSituation)
---@param unit string
---@param mobUnit? string
---@return number? status
function UnitThreatSituation(unit, mobUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitTrialBankedLevels)
function UnitTrialBankedLevels(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitTrialXP)
function UnitTrialXP(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitUsingVehicle)
---@param unit string
---@return boolean isTrue
function UnitUsingVehicle(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitVehicleSeatCount)
function UnitVehicleSeatCount(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitVehicleSeatInfo)
function UnitVehicleSeatInfo(unit, seatId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitVehicleSkin)
function UnitVehicleSkin(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitWeaponAttackPower)
function UnitWeaponAttackPower(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitXP)
---@param unit string
---@return number XP
function UnitXP(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitXPMax)
---@param unit string
---@return number XP
function UnitXPMax(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnlearnSpecialization)
function UnlearnSpecialization(specIndex, isPet) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnlockVoidStorage)
function UnlockVoidStorage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnmuteSoundFile)
function UnmuteSoundFile() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UpdateAddOnCPUUsage)
function UpdateAddOnCPUUsage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UpdateAddOnMemoryUsage)
function UpdateAddOnMemoryUsage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UpdateInventoryAlertStatus)
function UpdateInventoryAlertStatus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UpdateWarGamesList)
function UpdateWarGamesList() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UpdateWindow)
function UpdateWindow() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseAction)
function UseAction(slot, checkCursor, onSelf) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseContainerItem)
---@param bagID number
---@param slot number
---@param target? string
---@param reagentBankAccessible? boolean
function UseContainerItem(bagID, slot, target, reagentBankAccessible) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseHearthstone)
function UseHearthstone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseInventoryItem)
function UseInventoryItem(invSlot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseItemByName)
---@param name string
---@param target? string
function UseItemByName(name, target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseQuestLogSpecialItem)
function UseQuestLogSpecialItem(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseToy)
---@param itemId number
function UseToy(itemId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseToyByName)
---@param name string
function UseToyByName(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UseWorldMapActionButtonSpellOnQuest)
function UseWorldMapActionButtonSpellOnQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimDecrement)
function VehicleAimDecrement() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimDownStart)
function VehicleAimDownStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimDownStop)
function VehicleAimDownStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimGetAngle)
function VehicleAimGetAngle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimGetNormAngle)
function VehicleAimGetNormAngle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimGetNormPower)
function VehicleAimGetNormPower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimIncrement)
function VehicleAimIncrement() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimRequestAngle)
function VehicleAimRequestAngle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimRequestNormAngle)
function VehicleAimRequestNormAngle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimSetNormPower)
function VehicleAimSetNormPower() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimUpStart)
function VehicleAimUpStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleAimUpStop)
function VehicleAimUpStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleExit)
function VehicleExit() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehicleNextSeat)
function VehicleNextSeat() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_VehiclePrevSeat)
function VehiclePrevSeat() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_ViewGuildRecipes)
function ViewGuildRecipes(skillLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_WarGameRespond)
function WarGameRespond(accept) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_WithdrawGuildBankMoney)
function WithdrawGuildBankMoney(money) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_addframetext)
function addframetext(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_debuglocals)
function debuglocals() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_debugprofilestart)
function debugprofilestart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_debugprofilestop)
---@return number elapsedMilliseconds
function debugprofilestop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_debugstack)
function debugstack(start, count1, count2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_forceinsecure)
function forceinsecure() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_geterrorhandler)
---@return function func
function geterrorhandler() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_hooksecurefunc)
---@param tbl table
---@param name string
---@param hook function
---@overload fun(name: string, hook: function)
function hooksecurefunc(tbl, name, hook) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_issecure)
---@return boolean secure
function issecure() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_issecurevariable)
---@param table? table
---@param variable string
---@return boolean isSecure
---@return string? taint
function issecurevariable(table, variable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_scrub)
function scrub() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_securecall)
function securecall() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_securecallfunction)
function securecallfunction() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_secureexecuterange)
function secureexecuterange() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_seterrorhandler)
---@param errFunc function
function seterrorhandler(errFunc) end

