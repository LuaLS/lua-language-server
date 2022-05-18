---@meta
C_UI = {}

---True if any display attached has a notch. This does not mean the current view intersects the notch.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UI.DoesAnyDisplayHaveNotch)
---@return boolean notchPresent
function C_UI.DoesAnyDisplayHaveNotch() end

---Region of screen left of screen notch. Zeros if no notch.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UI.GetTopLeftNotchSafeRegion)
---@return number left
---@return number right
---@return number top
---@return number bottom
function C_UI.GetTopLeftNotchSafeRegion() end

---Region of screen right of screen notch. Zeros if no notch.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UI.GetTopRightNotchSafeRegion)
---@return number left
---@return number right
---@return number top
---@return number bottom
function C_UI.GetTopRightNotchSafeRegion() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UI.Reload)
function C_UI.Reload() end

---UIParent will shift down to avoid notch if true. This does not mean there is a notch.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UI.ShouldUIParentAvoidNotch)
---@return boolean willAvoidNotch
function C_UI.ShouldUIParentAvoidNotch() end
