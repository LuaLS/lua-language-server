---@meta
Spell = {}

---[Documentation](https://wowpedia.fandom.com/wiki/SpellMixin)
---@class SpellMixin
SpellMixin = {}

---@param spellID number
---@return SpellMixin
function Spell:CreateFromSpellID(spellID) end

---@param spellID number
function SpellMixin:SetSpellID(spellID) end

---@return number
function SpellMixin:GetSpellID() end

function SpellMixin:Clear() end

---@return boolean
function SpellMixin:IsSpellEmpty() end

---@return boolean
function SpellMixin:IsSpellDataCached() end

---@return string
function SpellMixin:GetSpellName() end

---@return string
function SpellMixin:GetSpellSubtext() end

---@return string
function SpellMixin:GetSpellDescription() end

-- Add a callback to be executed when spell data is loaded, if the spell data is already loaded then execute it immediately
---@param callbackFunction function
function SpellMixin:ContinueOnSpellLoad(callbackFunction) end

-- Same as ContinueOnSpellLoad, except it returns a function that when called will cancel the continue
---@param callbackFunction function
---@return function
function SpellMixin:ContinueWithCancelOnSpellLoad(callbackFunction) end
