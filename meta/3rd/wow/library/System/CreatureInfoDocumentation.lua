---@meta
C_CreatureInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CreatureInfo.GetClassInfo)
---@param classID number
---@return ClassInfo? classInfo
function C_CreatureInfo.GetClassInfo(classID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CreatureInfo.GetFactionInfo)
---@param raceID number
---@return FactionInfo? factionInfo
function C_CreatureInfo.GetFactionInfo(raceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CreatureInfo.GetRaceInfo)
---@param raceID number
---@return RaceInfo? raceInfo
function C_CreatureInfo.GetRaceInfo(raceID) end

---@class ClassInfo
---@field className string
---@field classFile string
---@field classID number

---@class FactionInfo
---@field name string
---@field groupTag string

---@class RaceInfo
---@field raceName string
---@field clientFileString string
---@field raceID number
