---@meta
C_ZoneAbility = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ZoneAbility.GetActiveAbilities)
---@return ZoneAbilityInfo[] zoneAbilities
function C_ZoneAbility.GetActiveAbilities() end

---@class ZoneAbilityInfo
---@field zoneAbilityID number
---@field uiPriority number
---@field spellID number
---@field textureKit string
---@field tutorialText string|nil
