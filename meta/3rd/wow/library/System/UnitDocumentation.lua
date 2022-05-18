---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/API_GetNegativeCorruptionEffectInfo)
---@return CorruptionEffectInfo[] corruptionEffects
function GetNegativeCorruptionEffectInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitChargedPowerPoints)
---@param unit string
---@return number[] pointIndices
function GetUnitChargedPowerPoints(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitPowerBarInfo)
---@param unitToken string
---@return UnitPowerBarInfo info
function GetUnitPowerBarInfo(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitPowerBarInfoByID)
---@param barID number
---@return UnitPowerBarInfo info
function GetUnitPowerBarInfoByID(barID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitPowerBarStrings)
---@param unitToken string
---@return string? name
---@return string? tooltip
---@return string? cost
function GetUnitPowerBarStrings(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitPowerBarStringsByID)
---@param barID number
---@return string? name
---@return string? tooltip
---@return string? cost
function GetUnitPowerBarStringsByID(barID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitPowerBarTextureInfo)
---@param unitToken string
---@param textureIndex number
---@param timerIndex? number
---@return number texture
---@return number colorR
---@return number colorG
---@return number colorB
---@return number colorA
function GetUnitPowerBarTextureInfo(unitToken, textureIndex, timerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetUnitPowerBarTextureInfoByID)
---@param barID number
---@param textureIndex number
---@return number texture
---@return number colorR
---@return number colorG
---@return number colorB
---@return number colorA
function GetUnitPowerBarTextureInfoByID(barID, textureIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsUnitModelReadyForUI)
---@param unitToken string
---@return boolean isReady
function IsUnitModelReadyForUI(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_PlayerVehicleHasComboPoints)
---@return boolean vehicleHasComboPoints
function PlayerVehicleHasComboPoints() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPortraitTexture)
---@param textureObject table
---@param unitToken string
function SetPortraitTexture(textureObject, unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SetPortraitTextureFromCreatureDisplayID)
---@param textureObject table
---@param creatureDisplayID number
function SetPortraitTextureFromCreatureDisplayID(textureObject, creatureDisplayID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitAlliedRaceInfo)
---@param unit string
---@return boolean isAlliedRace
---@return boolean hasHeritageArmorUnlocked
function UnitAlliedRaceInfo(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitChromieTimeID)
---@param unit string
---@return number ID
function UnitChromieTimeID(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitClass)
---@param unit string
---@return string className
---@return string classFilename
---@return number classID
function UnitClass(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitClassBase)
---@param unit string
---@return string classFilename
---@return number classID
function UnitClassBase(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitInPartyShard)
---@param unit string
---@return boolean inPartyShard
function UnitInPartyShard(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsConnected)
---@param unit string
---@return boolean isConnected
function UnitIsConnected(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitIsOwnerOrControllerOfUnit)
---@param controllingUnit string
---@param controlledUnit string
---@return boolean unitIsOwnerOrControllerOfUnit
function UnitIsOwnerOrControllerOfUnit(controllingUnit, controlledUnit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitNameplateShowsWidgetsOnly)
---@param unit string
---@return boolean nameplateShowsWidgetsOnly
function UnitNameplateShowsWidgetsOnly(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPhaseReason)
---@param unit string
---@return PhaseReason? reason
function UnitPhaseReason(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPower)
---@param unitToken string
---@param powerType PowerType
---@param unmodified boolean
---@return number power
function UnitPower(unitToken, powerType, unmodified) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPowerBarID)
---@param unitToken string
---@return number barID
function UnitPowerBarID(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPowerDisplayMod)
---@param powerType PowerType
---@return number displayMod
function UnitPowerDisplayMod(powerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPowerMax)
---@param unitToken string
---@param powerType PowerType
---@param unmodified boolean
---@return number maxPower
function UnitPowerMax(unitToken, powerType, unmodified) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitPvpClassification)
---@param unit string
---@return PvPUnitClassification? classification
function UnitPvpClassification(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitQuestTrivialLevelRange)
---@param unit string
---@return number levelRange
function UnitQuestTrivialLevelRange(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitQuestTrivialLevelRangeScaling)
---@param unit string
---@return number levelRange
function UnitQuestTrivialLevelRangeScaling(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitSex)
---@param unit string
---@return number? sex
function UnitSex(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitTreatAsPlayerForDisplay)
---@param unit string
---@return boolean treatAsPlayer
function UnitTreatAsPlayerForDisplay(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_UnitWidgetSet)
---@param unit string
---@return number uiWidgetSet
function UnitWidgetSet(unit) end

---@class CorruptionEffectInfo
---@field name string
---@field description string
---@field minCorruption number

---@class UnitPowerBarInfo
---@field ID number
---@field barType number
---@field minPower number
---@field startInset number
---@field endInset number
---@field smooth boolean
---@field hideFromOthers boolean
---@field showOnRaid boolean
---@field opaqueSpark boolean
---@field opaqueFlash boolean
---@field anchorTop boolean
---@field forcePercentage boolean
---@field sparkUnderFrame boolean
---@field flashAtMinPower boolean
---@field fractionalCounter boolean
---@field animateNumbers boolean
