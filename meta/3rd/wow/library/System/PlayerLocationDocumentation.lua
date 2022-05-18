---@meta
C_PlayerInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GUIDIsPlayer)
---@param guid string
---@return boolean isPlayer
function C_PlayerInfo.GUIDIsPlayer(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetClass)
---@param playerLocation PlayerLocationMixin
---@return string? className
---@return string? classFilename
---@return number? classID
function C_PlayerInfo.GetClass(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetName)
---@param playerLocation PlayerLocationMixin
---@return string? name
function C_PlayerInfo.GetName(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetRace)
---@param playerLocation PlayerLocationMixin
---@return number? raceID
function C_PlayerInfo.GetRace(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetSex)
---@param playerLocation PlayerLocationMixin
---@return number? sex
function C_PlayerInfo.GetSex(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.IsConnected)
---@param playerLocation? PlayerLocationMixin
---@return boolean? isConnected
function C_PlayerInfo.IsConnected(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.UnitIsSameServer)
---@param playerLocation PlayerLocationMixin
---@return boolean unitIsSameServer
function C_PlayerInfo.UnitIsSameServer(playerLocation) end
