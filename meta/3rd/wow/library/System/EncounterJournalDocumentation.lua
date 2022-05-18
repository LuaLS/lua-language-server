---@meta
C_EncounterJournal = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetDungeonEntrancesForMap)
---@param uiMapID number
---@return DungeonEntranceMapInfo[] dungeonEntrances
function C_EncounterJournal.GetDungeonEntrancesForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetEncountersOnMap)
---@param uiMapID number
---@return EncounterJournalMapEncounterInfo[] encounters
function C_EncounterJournal.GetEncountersOnMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetLootInfo)
---@param id number
---@return EncounterJournalItemInfo itemInfo
function C_EncounterJournal.GetLootInfo(id) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetLootInfoByIndex)
---@param index number
---@param encounterIndex? number
---@return EncounterJournalItemInfo itemInfo
function C_EncounterJournal.GetLootInfoByIndex(index, encounterIndex) end

---Represents the icon indices for this EJ section.  An icon index can be used to arrive at texture coordinates for specific encounter types, e.g.: EncounterJournal_SetFlagIcon
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetSectionIconFlags)
---@param sectionID number
---@return number[]? iconFlags
function C_EncounterJournal.GetSectionIconFlags(sectionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetSectionInfo)
---@param sectionID number
---@return EncounterJournalSectionInfo info
function C_EncounterJournal.GetSectionInfo(sectionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.GetSlotFilter)
---@return ItemSlotFilterType filter
function C_EncounterJournal.GetSlotFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.InstanceHasLoot)
---@param instanceID? number
---@return boolean hasLoot
function C_EncounterJournal.InstanceHasLoot(instanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.IsEncounterComplete)
---@param journalEncounterID number
---@return boolean isEncounterComplete
function C_EncounterJournal.IsEncounterComplete(journalEncounterID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.ResetSlotFilter)
function C_EncounterJournal.ResetSlotFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.SetPreviewMythicPlusLevel)
---@param level number
function C_EncounterJournal.SetPreviewMythicPlusLevel(level) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.SetPreviewPvpTier)
---@param tier number
function C_EncounterJournal.SetPreviewPvpTier(tier) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EncounterJournal.SetSlotFilter)
---@param filterSlot ItemSlotFilterType
function C_EncounterJournal.SetSlotFilter(filterSlot) end

---@class DungeonEntranceMapInfo
---@field areaPoiID number
---@field position Vector2DMixin
---@field name string
---@field description string
---@field atlasName string
---@field journalInstanceID number

---@class EncounterJournalItemInfo
---@field itemID number
---@field encounterID number|nil
---@field name string|nil
---@field itemQuality string|nil
---@field filterType ItemSlotFilterType|nil
---@field icon number|nil
---@field slot string|nil
---@field armorType string|nil
---@field link string|nil
---@field handError boolean|nil
---@field weaponTypeError boolean|nil
---@field displayAsPerPlayerLoot boolean|nil

---@class EncounterJournalMapEncounterInfo
---@field encounterID number
---@field mapX number
---@field mapY number

---@class EncounterJournalSectionInfo
---@field spellID number
---@field title string
---@field description string|nil
---@field headerType number
---@field abilityIcon number
---@field creatureDisplayID number
---@field uiModelSceneID number
---@field siblingSectionID number|nil
---@field firstChildSectionID number|nil
---@field filteredByDifficulty boolean
---@field link string
---@field startsOpen boolean
