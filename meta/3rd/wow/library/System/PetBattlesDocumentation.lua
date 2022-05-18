---@meta
C_PetBattles = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetBreedQuality)
---@param petOwner number
---@param slot number
---@return number quality
function C_PetBattles.GetBreedQuality(petOwner, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetIcon)
---@param petOwner number
---@param slot number
---@return number iconFileID
function C_PetBattles.GetIcon(petOwner, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.GetName)
---@param petOwner number
---@param slot number
---@return string customName
---@return string speciesName
function C_PetBattles.GetName(petOwner, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.IsPlayerNPC)
---@return boolean isPlayerNPC
function C_PetBattles.IsPlayerNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PetBattles.IsWildBattle)
---@return boolean isWildBattle
function C_PetBattles.IsWildBattle() end
