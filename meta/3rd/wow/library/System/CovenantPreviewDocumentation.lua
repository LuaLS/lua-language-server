---@meta
C_CovenantPreview = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CovenantPreview.CloseFromUI)
function C_CovenantPreview.CloseFromUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CovenantPreview.GetCovenantInfoForPlayerChoiceResponseID)
---@param playerChoiceResponseID number
---@return CovenantPreviewInfo previewInfo
function C_CovenantPreview.GetCovenantInfoForPlayerChoiceResponseID(playerChoiceResponseID) end

---@class CovenantAbilityInfo
---@field spellID number
---@field type CovenantAbilityType

---@class CovenantFeatureInfo
---@field name string
---@field description string
---@field texture number

---@class CovenantPreviewInfo
---@field textureKit string
---@field transmogSetID number
---@field mountID number
---@field covenantName string
---@field covenantZone string
---@field description string
---@field covenantCrest string
---@field covenantAbilities CovenantAbilityInfo[]
---@field fromPlayerChoice boolean
---@field covenantSoulbinds CovenantSoulbindInfo[]
---@field featureInfo CovenantFeatureInfo

---@class CovenantSoulbindInfo
---@field spellID number
---@field uiTextureKit string
---@field name string
---@field description string
---@field sortOrder number
