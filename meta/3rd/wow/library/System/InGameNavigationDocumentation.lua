---@meta
C_Navigation = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Navigation.GetDistance)
---@return number distance
function C_Navigation.GetDistance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Navigation.GetFrame)
---@return table? frame
function C_Navigation.GetFrame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Navigation.GetTargetState)
---@return NavigationState state
function C_Navigation.GetTargetState() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Navigation.HasValidScreenPosition)
---@return boolean hasValidScreenPosition
function C_Navigation.HasValidScreenPosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Navigation.WasClampedToScreen)
---@return boolean wasClamped
function C_Navigation.WasClampedToScreen() end
