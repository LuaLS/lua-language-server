---@meta
C_EventToastManager = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EventToastManager.GetLevelUpDisplayToastsFromLevel)
---@param level number
---@return EventToastInfo[] toastInfo
function C_EventToastManager.GetLevelUpDisplayToastsFromLevel(level) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EventToastManager.GetNextToastToDisplay)
---@return EventToastInfo toastInfo
function C_EventToastManager.GetNextToastToDisplay() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EventToastManager.RemoveCurrentToast)
function C_EventToastManager.RemoveCurrentToast() end

---@class EventToastInfo
---@field eventToastID number
---@field title string
---@field subtitle string
---@field instructionText string
---@field iconFileID number
---@field subIcon string|nil
---@field link string
---@field qualityString string|nil
---@field quality number|nil
---@field eventType EventToastEventType
---@field displayType EventToastDisplayType
---@field uiTextureKit string
---@field sortOrder number
---@field time number|nil
---@field uiWidgetSetID number|nil
---@field extraUiWidgetSetID number|nil
---@field titleTooltip string|nil
---@field subtitleTooltip string|nil
---@field titleTooltipUiWidgetSetID number|nil
---@field subtitleTooltipUiWidgetSetID number|nil
---@field hideDefaultAtlas boolean|nil
---@field showSoundKitID number|nil
---@field hideSoundKitID number|nil
---@field colorTint ColorMixin|nil
