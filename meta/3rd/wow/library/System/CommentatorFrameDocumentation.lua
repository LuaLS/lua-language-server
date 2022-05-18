---@meta
C_Commentator = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AddPlayerOverrideName)
---@param playerName string
---@param overrideName string
function C_Commentator.AddPlayerOverrideName(playerName, overrideName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AddTrackedDefensiveAuras)
---@param spellIDs number[]
function C_Commentator.AddTrackedDefensiveAuras(spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AddTrackedOffensiveAuras)
---@param spellIDs number[]
function C_Commentator.AddTrackedOffensiveAuras(spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AreTeamsSwapped)
---@return boolean teamsAreSwapped
function C_Commentator.AreTeamsSwapped() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AssignPlayerToTeam)
---@param playerName string
---@param teamName string
function C_Commentator.AssignPlayerToTeam(playerName, teamName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AssignPlayersToTeam)
---@param playerName string[]
---@param teamName string
function C_Commentator.AssignPlayersToTeam(playerName, teamName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.AssignPlayersToTeamInCurrentInstance)
---@param teamIndex number
---@param teamName string
function C_Commentator.AssignPlayersToTeamInCurrentInstance(teamIndex, teamName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.CanUseCommentatorCheats)
---@return boolean canUseCommentatorCheats
function C_Commentator.CanUseCommentatorCheats() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ClearCameraTarget)
function C_Commentator.ClearCameraTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ClearFollowTarget)
function C_Commentator.ClearFollowTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ClearLookAtTarget)
---@param lookAtIndex? number
function C_Commentator.ClearLookAtTarget(lookAtIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.EnterInstance)
function C_Commentator.EnterInstance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ExitInstance)
function C_Commentator.ExitInstance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.FindSpectatedUnit)
---@param unitToken string
---@return number playerIndex
---@return number teamIndex
---@return boolean isPet
function C_Commentator.FindSpectatedUnit(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.FindTeamNameInCurrentInstance)
---@param teamIndex number
---@return string? teamName
function C_Commentator.FindTeamNameInCurrentInstance(teamIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.FindTeamNameInDirectory)
---@param playerNames string[]
---@return string? teamName
function C_Commentator.FindTeamNameInDirectory(playerNames) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.FlushCommentatorHistory)
function C_Commentator.FlushCommentatorHistory() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.FollowPlayer)
---@param factionIndex number
---@param playerIndex number
---@param forceInstantTransition? boolean
function C_Commentator.FollowPlayer(factionIndex, playerIndex, forceInstantTransition) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.FollowUnit)
---@param token string
function C_Commentator.FollowUnit(token) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ForceFollowTransition)
function C_Commentator.ForceFollowTransition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetAdditionalCameraWeight)
---@return number teamIndex
---@return number playerIndex
function C_Commentator.GetAdditionalCameraWeight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetAdditionalCameraWeightByToken)
---@param unitToken string
---@return number weight
function C_Commentator.GetAdditionalCameraWeightByToken(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetAllPlayerOverrideNames)
---@return NameOverrideEntry[] nameEntries
function C_Commentator.GetAllPlayerOverrideNames() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetCamera)
---@return number xPos
---@return number yPos
---@return number zPos
---@return number yaw
---@return number pitch
---@return number roll
---@return number fov
function C_Commentator.GetCamera() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetCameraCollision)
---@return boolean isColliding
function C_Commentator.GetCameraCollision() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetCameraPosition)
---@return number xPos
---@return number yPos
---@return number zPos
function C_Commentator.GetCameraPosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetCommentatorHistory)
---@return CommentatorHistory history
function C_Commentator.GetCommentatorHistory() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetCurrentMapID)
---@return number? mapID
function C_Commentator.GetCurrentMapID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetDampeningPercent)
---@return number percentage
function C_Commentator.GetDampeningPercent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetDistanceBeforeForcedHorizontalConvergence)
---@return number distance
function C_Commentator.GetDistanceBeforeForcedHorizontalConvergence() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetDurationToForceHorizontalConvergence)
---@return number ms
function C_Commentator.GetDurationToForceHorizontalConvergence() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetExcludeDistance)
---@return number excludeDistance
function C_Commentator.GetExcludeDistance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetHardlockWeight)
---@return number weight
function C_Commentator.GetHardlockWeight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetHorizontalAngleThresholdToSmooth)
---@return number angle
function C_Commentator.GetHorizontalAngleThresholdToSmooth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetIndirectSpellID)
---@param trackedSpellID number
---@return number indirectSpellID
function C_Commentator.GetIndirectSpellID(trackedSpellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetInstanceInfo)
---@param mapIndex number
---@param instanceIndex number
---@return number mapID
---@return string? mapName
---@return number status
---@return number instanceIDLow
---@return number instanceIDHigh
function C_Commentator.GetInstanceInfo(mapIndex, instanceIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetLookAtLerpAmount)
---@return number amount
function C_Commentator.GetLookAtLerpAmount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMapInfo)
---@param mapIndex number
---@return number teamSize
---@return number minLevel
---@return number maxLevel
---@return number numInstances
function C_Commentator.GetMapInfo(mapIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMatchDuration)
---@return number seconds
function C_Commentator.GetMatchDuration() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMaxNumPlayersPerTeam)
---@return number maxNumPlayersPerTeam
function C_Commentator.GetMaxNumPlayersPerTeam() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMaxNumTeams)
---@return number maxNumTeams
function C_Commentator.GetMaxNumTeams() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMode)
---@return number commentatorMode
function C_Commentator.GetMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMsToHoldForHorizontalMovement)
---@return number ms
function C_Commentator.GetMsToHoldForHorizontalMovement() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMsToHoldForVerticalMovement)
---@return number ms
function C_Commentator.GetMsToHoldForVerticalMovement() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMsToSmoothHorizontalChange)
---@return number ms
function C_Commentator.GetMsToSmoothHorizontalChange() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetMsToSmoothVerticalChange)
---@return number ms
function C_Commentator.GetMsToSmoothVerticalChange() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetNumMaps)
---@return number numMaps
function C_Commentator.GetNumMaps() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetNumPlayers)
---@param factionIndex number
---@return number numPlayers
function C_Commentator.GetNumPlayers(factionIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetOrCreateSeries)
---@param teamName1 string
---@param teamName2 string
---@return CommentatorSeries data
function C_Commentator.GetOrCreateSeries(teamName1, teamName2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerAuraInfo)
---@param teamIndex number
---@param playerIndex number
---@param spellID number
---@return number startTime
---@return number duration
---@return boolean enable
function C_Commentator.GetPlayerAuraInfo(teamIndex, playerIndex, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerAuraInfoByUnit)
---@param token string
---@param spellID number
---@return number startTime
---@return number duration
---@return boolean enable
function C_Commentator.GetPlayerAuraInfoByUnit(token, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerCooldownInfo)
---@param teamIndex number
---@param playerIndex number
---@param spellID number
---@return number startTime
---@return number duration
---@return boolean enable
function C_Commentator.GetPlayerCooldownInfo(teamIndex, playerIndex, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerCooldownInfoByUnit)
---@param unitToken string
---@param spellID number
---@return number startTime
---@return number duration
---@return boolean enable
function C_Commentator.GetPlayerCooldownInfoByUnit(unitToken, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerCrowdControlInfo)
---@param teamIndex number
---@param playerIndex number
---@return number spellID
---@return number expiration
---@return number duration
function C_Commentator.GetPlayerCrowdControlInfo(teamIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerCrowdControlInfoByUnit)
---@param token string
---@return number spellID
---@return number expiration
---@return number duration
function C_Commentator.GetPlayerCrowdControlInfoByUnit(token) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerData)
---@param teamIndex number
---@param playerIndex number
---@return CommentatorPlayerData? info
function C_Commentator.GetPlayerData(teamIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerFlagInfo)
---@param teamIndex number
---@param playerIndex number
---@return boolean hasFlag
function C_Commentator.GetPlayerFlagInfo(teamIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerFlagInfoByUnit)
---@param unitToken string
---@return boolean hasFlag
function C_Commentator.GetPlayerFlagInfoByUnit(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerOverrideName)
---@param originalName string
---@return string overrideName
function C_Commentator.GetPlayerOverrideName(originalName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerSpellCharges)
---@param teamIndex number
---@param playerIndex number
---@param spellID number
---@return number charges
---@return number maxCharges
---@return number startTime
---@return number duration
function C_Commentator.GetPlayerSpellCharges(teamIndex, playerIndex, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPlayerSpellChargesByUnit)
---@param unitToken string
---@param spellID number
---@return number charges
---@return number maxCharges
---@return number startTime
---@return number duration
function C_Commentator.GetPlayerSpellChargesByUnit(unitToken, spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetPositionLerpAmount)
---@return number amount
function C_Commentator.GetPositionLerpAmount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetSmoothFollowTransitioning)
---@return boolean enabled
function C_Commentator.GetSmoothFollowTransitioning() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetSoftlockWeight)
---@return number weight
function C_Commentator.GetSoftlockWeight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetSpeedFactor)
---@return number factor
function C_Commentator.GetSpeedFactor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetStartLocation)
---@param mapID number
---@return Vector3DMixin pos
function C_Commentator.GetStartLocation(mapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetTeamColor)
---@param teamIndex number
---@return ColorMixin color
function C_Commentator.GetTeamColor(teamIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetTeamColorByUnit)
---@param unitToken string
---@return ColorMixin color
function C_Commentator.GetTeamColorByUnit(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetTimeLeftInMatch)
---@return number? timeLeft
function C_Commentator.GetTimeLeftInMatch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetTrackedSpellID)
---@param indirectSpellID number
---@return number trackedSpellID
function C_Commentator.GetTrackedSpellID(indirectSpellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetTrackedSpells)
---@param teamIndex number
---@param playerIndex number
---@param category TrackedSpellCategory
---@return number[]? spells
function C_Commentator.GetTrackedSpells(teamIndex, playerIndex, category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetTrackedSpellsByUnit)
---@param unitToken string
---@param category TrackedSpellCategory
---@return number[]? spells
function C_Commentator.GetTrackedSpellsByUnit(unitToken, category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetUnitData)
---@param unitToken string
---@return CommentatorUnitData data
function C_Commentator.GetUnitData(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.GetWargameInfo)
---@param listID number
---@return string name
---@return number minPlayers
---@return number maxPlayers
---@return boolean isArena
function C_Commentator.GetWargameInfo(listID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.HasTrackedAuras)
---@param token string
---@return boolean hasOffensiveAura
---@return boolean hasDefensiveAura
function C_Commentator.HasTrackedAuras(token) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsSmartCameraLocked)
---@return boolean isSmartCameraLocked
function C_Commentator.IsSmartCameraLocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsSpectating)
---@return boolean isSpectating
function C_Commentator.IsSpectating() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsTrackedDefensiveAura)
---@param spellID number
---@return boolean isDefensiveTrigger
function C_Commentator.IsTrackedDefensiveAura(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsTrackedOffensiveAura)
---@param spellID number
---@return boolean isOffensiveTrigger
function C_Commentator.IsTrackedOffensiveAura(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsTrackedSpell)
---@param teamIndex number
---@param playerIndex number
---@param spellID number
---@param category TrackedSpellCategory
---@return boolean isTracked
function C_Commentator.IsTrackedSpell(teamIndex, playerIndex, spellID, category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsTrackedSpellByUnit)
---@param unitToken string
---@param spellID number
---@param category TrackedSpellCategory
---@return boolean isTracked
function C_Commentator.IsTrackedSpellByUnit(unitToken, spellID, category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.IsUsingSmartCamera)
---@return boolean isUsingSmartCamera
function C_Commentator.IsUsingSmartCamera() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.LookAtPlayer)
---@param factionIndex number
---@param playerIndex number
---@param lookAtIndex? number
function C_Commentator.LookAtPlayer(factionIndex, playerIndex, lookAtIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.RemoveAllOverrideNames)
function C_Commentator.RemoveAllOverrideNames() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.RemovePlayerOverrideName)
---@param originalPlayerName string
function C_Commentator.RemovePlayerOverrideName(originalPlayerName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.RequestPlayerCooldownInfo)
---@param teamIndex number
---@param playerIndex number
function C_Commentator.RequestPlayerCooldownInfo(teamIndex, playerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ResetFoVTarget)
function C_Commentator.ResetFoVTarget() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ResetSeriesScores)
---@param teamName1 string
---@param teamName2 string
function C_Commentator.ResetSeriesScores(teamName1, teamName2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ResetSettings)
function C_Commentator.ResetSettings() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ResetTrackedAuras)
function C_Commentator.ResetTrackedAuras() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetAdditionalCameraWeight)
---@param teamIndex number
---@param playerIndex number
---@param weight number
function C_Commentator.SetAdditionalCameraWeight(teamIndex, playerIndex, weight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetAdditionalCameraWeightByToken)
---@param unitToken string
---@param weight number
function C_Commentator.SetAdditionalCameraWeightByToken(unitToken, weight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetBlocklistedAuras)
---@param spellIDs number[]
function C_Commentator.SetBlocklistedAuras(spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetBlocklistedCooldowns)
---@param specID number
---@param spellIDs number[]
function C_Commentator.SetBlocklistedCooldowns(specID, spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetCamera)
---@param xPos number
---@param yPos number
---@param zPos number
---@param yaw number
---@param pitch number
---@param roll number
---@param fov number
function C_Commentator.SetCamera(xPos, yPos, zPos, yaw, pitch, roll, fov) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetCameraCollision)
---@param collide boolean
function C_Commentator.SetCameraCollision(collide) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetCameraPosition)
---@param xPos number
---@param yPos number
---@param zPos number
---@param snapToLocation boolean
function C_Commentator.SetCameraPosition(xPos, yPos, zPos, snapToLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetCheatsEnabled)
---@param enableCheats boolean
function C_Commentator.SetCheatsEnabled(enableCheats) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetCommentatorHistory)
---@param history CommentatorHistory
function C_Commentator.SetCommentatorHistory(history) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetDistanceBeforeForcedHorizontalConvergence)
---@param distance number
function C_Commentator.SetDistanceBeforeForcedHorizontalConvergence(distance) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetDurationToForceHorizontalConvergence)
---@param ms number
function C_Commentator.SetDurationToForceHorizontalConvergence(ms) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetExcludeDistance)
---@param excludeDistance number
function C_Commentator.SetExcludeDistance(excludeDistance) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetFollowCameraSpeeds)
---@param elasticSpeed number
---@param minSpeed number
function C_Commentator.SetFollowCameraSpeeds(elasticSpeed, minSpeed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetHardlockWeight)
---@param weight number
function C_Commentator.SetHardlockWeight(weight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetHorizontalAngleThresholdToSmooth)
---@param angle number
function C_Commentator.SetHorizontalAngleThresholdToSmooth(angle) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetLookAtLerpAmount)
---@param amount number
function C_Commentator.SetLookAtLerpAmount(amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMapAndInstanceIndex)
---@param mapIndex number
---@param instanceIndex number
function C_Commentator.SetMapAndInstanceIndex(mapIndex, instanceIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMouseDisabled)
---@param disabled boolean
function C_Commentator.SetMouseDisabled(disabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMoveSpeed)
---@param newSpeed number
function C_Commentator.SetMoveSpeed(newSpeed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMsToHoldForHorizontalMovement)
---@param ms number
function C_Commentator.SetMsToHoldForHorizontalMovement(ms) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMsToHoldForVerticalMovement)
---@param ms number
function C_Commentator.SetMsToHoldForVerticalMovement(ms) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMsToSmoothHorizontalChange)
---@param ms number
function C_Commentator.SetMsToSmoothHorizontalChange(ms) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetMsToSmoothVerticalChange)
---@param ms number
function C_Commentator.SetMsToSmoothVerticalChange(ms) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetPositionLerpAmount)
---@param amount number
function C_Commentator.SetPositionLerpAmount(amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetRequestedDebuffCooldowns)
---@param specID number
---@param spellIDs number[]
function C_Commentator.SetRequestedDebuffCooldowns(specID, spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetRequestedDefensiveCooldowns)
---@param specID number
---@param spellIDs number[]
function C_Commentator.SetRequestedDefensiveCooldowns(specID, spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetRequestedOffensiveCooldowns)
---@param specID number
---@param spellIDs number[]
function C_Commentator.SetRequestedOffensiveCooldowns(specID, spellIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetSeriesScore)
---@param teamName1 string
---@param teamName2 string
---@param scoringTeamName string
---@param score number
function C_Commentator.SetSeriesScore(teamName1, teamName2, scoringTeamName, score) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetSeriesScores)
---@param teamName1 string
---@param teamName2 string
---@param score1 number
---@param score2 number
function C_Commentator.SetSeriesScores(teamName1, teamName2, score1, score2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetSmartCameraLocked)
---@param locked boolean
function C_Commentator.SetSmartCameraLocked(locked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetSmoothFollowTransitioning)
---@param enabled boolean
function C_Commentator.SetSmoothFollowTransitioning(enabled) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetSoftlockWeight)
---@param weight number
function C_Commentator.SetSoftlockWeight(weight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetSpeedFactor)
---@param factor number
function C_Commentator.SetSpeedFactor(factor) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetTargetHeightOffset)
---@param offset number
function C_Commentator.SetTargetHeightOffset(offset) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SetUseSmartCamera)
---@param useSmartCamera boolean
function C_Commentator.SetUseSmartCamera(useSmartCamera) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SnapCameraLookAtPoint)
function C_Commentator.SnapCameraLookAtPoint() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.StartWargame)
---@param listID number
---@param teamSize number
---@param tournamentRules boolean
---@param teamOneCaptain string
---@param teamTwoCaptain string
function C_Commentator.StartWargame(listID, teamSize, tournamentRules, teamOneCaptain, teamTwoCaptain) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.SwapTeamSides)
function C_Commentator.SwapTeamSides() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ToggleCheats)
function C_Commentator.ToggleCheats() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.UpdateMapInfo)
---@param targetPlayer? string
function C_Commentator.UpdateMapInfo(targetPlayer) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.UpdatePlayerInfo)
function C_Commentator.UpdatePlayerInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ZoomIn)
function C_Commentator.ZoomIn() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Commentator.ZoomOut)
function C_Commentator.ZoomOut() end

---@class CommentatorHistory
---@field series CommentatorSeries[]
---@field teamDirectory CommentatorTeamDirectoryEntry[]
---@field overrideNameDirectory CommentatorOverrideNameEntry[]

---@class CommentatorOverrideNameEntry
---@field originalName string
---@field newName string

---@class CommentatorPlayerData
---@field unitToken string
---@field name string
---@field faction number
---@field specialization number
---@field damageDone number
---@field damageTaken number
---@field healingDone number
---@field healingTaken number
---@field kills number
---@field deaths number
---@field soloShuffleRoundWins number
---@field soloShuffleRoundLosses number

---@class CommentatorSeries
---@field teams CommentatorSeriesTeam[]

---@class CommentatorSeriesTeam
---@field name string
---@field score number

---@class CommentatorTeamDirectoryEntry
---@field playerName string
---@field teamName string

---@class CommentatorUnitData
---@field healthMax number
---@field health number
---@field absorbTotal number
---@field isDeadOrGhost boolean
---@field isFeignDeath boolean
---@field powerTypeToken string
---@field power number
---@field powerMax number

---@class NameOverrideEntry
---@field originalName string
---@field overrideName string
