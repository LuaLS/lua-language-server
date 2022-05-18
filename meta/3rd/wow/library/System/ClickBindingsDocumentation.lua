---@meta
C_ClickBindings = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.CanSpellBeClickBound)
---@param spellID number
---@return boolean canBeBound
function C_ClickBindings.CanSpellBeClickBound(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.ExecuteBinding)
---@param targetToken string
---@param button string
---@param modifiers number
function C_ClickBindings.ExecuteBinding(targetToken, button, modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.GetBindingType)
---@param button string
---@param modifiers number
---@return ClickBindingType type
function C_ClickBindings.GetBindingType(button, modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.GetEffectiveInteractionButton)
---@param button string
---@param modifiers number
---@return string effectiveButton
function C_ClickBindings.GetEffectiveInteractionButton(button, modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.GetProfileInfo)
---@return ClickBindingInfo[] infoVec
function C_ClickBindings.GetProfileInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.GetStringFromModifiers)
---@param modifiers number
---@return string modifierString
function C_ClickBindings.GetStringFromModifiers(modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.GetTutorialShown)
---@return boolean tutorialShown
function C_ClickBindings.GetTutorialShown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.MakeModifiers)
---@return number modifiers
function C_ClickBindings.MakeModifiers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.ResetCurrentProfile)
function C_ClickBindings.ResetCurrentProfile() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.SetProfileByInfo)
---@param infoVec ClickBindingInfo[]
function C_ClickBindings.SetProfileByInfo(infoVec) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ClickBindings.SetTutorialShown)
function C_ClickBindings.SetTutorialShown() end
