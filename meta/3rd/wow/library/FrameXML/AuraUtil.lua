---@meta
AuraUtil = {}

---[FrameXML](https://github.com/Gethe/wow-ui-source/blob/live/Interface/FrameXML/AuraUtil.lua#L32)
-- Finds the first aura that matches the name
---@param auraName string
---@param unit string
---@param filter? string
---@return string name
---@return number icon
---@return number count
---@return string? dispelType
---@return number duration
---@return number expirationTime
---@return string source
---@return boolean isStealable
---@return boolean nameplateShowPersonal
---@return number spellId
---@return boolean canApplyAura
---@return boolean isBossDebuff
---@return boolean castByPlayer
---@return boolean nameplateShowAll
---@return number timeMod
---@return ...
function AuraUtil.FindAuraByName(auraName, unit, filter) end

---[FrameXML](https://github.com/Gethe/wow-ui-source/blob/live/Interface/FrameXML/AuraUtil.lua#L51)
--- Iterates over a filtered list of auras
---@param unit string
---@param filter string
---@param maxCount? any
---@param func function
---@return string name
---@return number icon
---@return number count
---@return string? dispelType
---@return number duration
---@return number expirationTime
---@return string source
---@return boolean isStealable
---@return boolean nameplateShowPersonal
---@return number spellId
---@return boolean canApplyAura
---@return boolean isBossDebuff
---@return boolean castByPlayer
---@return boolean nameplateShowAll
---@return number timeMod
---@return ...
function AuraUtil.ForEachAura(unit, filter, maxCount, func) end
