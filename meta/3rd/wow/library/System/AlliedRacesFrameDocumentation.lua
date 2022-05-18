---@meta
C_AlliedRaces = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AlliedRaces.ClearAlliedRaceDetailsGiver)
function C_AlliedRaces.ClearAlliedRaceDetailsGiver() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AlliedRaces.GetAllRacialAbilitiesFromID)
---@param raceID number
---@return AlliedRaceRacialAbility[] allDisplayInfo
function C_AlliedRaces.GetAllRacialAbilitiesFromID(raceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AlliedRaces.GetRaceInfoByID)
---@param raceID number
---@return AlliedRaceInfo info
function C_AlliedRaces.GetRaceInfoByID(raceID) end

---@class AlliedRaceInfo
---@field raceID number
---@field maleModelID number
---@field femaleModelID number
---@field achievementIds number[]
---@field maleName string
---@field femaleName string
---@field description string
---@field raceFileString string
---@field crestAtlas string
---@field modelBackgroundAtlas string
---@field bannerColor ColorMixin

---@class AlliedRaceRacialAbility
---@field description string
---@field name string
---@field icon number
