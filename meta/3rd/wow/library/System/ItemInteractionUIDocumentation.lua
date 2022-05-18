---@meta
C_ItemInteraction = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.ClearPendingItem)
function C_ItemInteraction.ClearPendingItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.CloseUI)
function C_ItemInteraction.CloseUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.GetChargeInfo)
---@return ItemInteractionChargeInfo chargeInfo
function C_ItemInteraction.GetChargeInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.GetItemConversionCurrencyCost)
---@param item ItemLocationMixin
---@return ConversionCurrencyCost conversionCost
function C_ItemInteraction.GetItemConversionCurrencyCost(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.GetItemInteractionInfo)
---@return ItemInteractionFrameInfo? info
function C_ItemInteraction.GetItemInteractionInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.GetItemInteractionSpellId)
---@return number spellId
function C_ItemInteraction.GetItemInteractionSpellId() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.InitializeFrame)
function C_ItemInteraction.InitializeFrame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.PerformItemInteraction)
function C_ItemInteraction.PerformItemInteraction() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.Reset)
function C_ItemInteraction.Reset() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.SetCorruptionReforgerItemTooltip)
function C_ItemInteraction.SetCorruptionReforgerItemTooltip() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.SetItemConversionOutputTooltip)
function C_ItemInteraction.SetItemConversionOutputTooltip() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemInteraction.SetPendingItem)
---@param item? ItemLocationMixin
---@return boolean success
function C_ItemInteraction.SetPendingItem(item) end

---@class ConversionCurrencyCost
---@field currencyID number
---@field amount number

---@class ItemInteractionChargeInfo
---@field newChargeAmount number
---@field rechargeRate number
---@field timeToNextCharge number

---@class ItemInteractionFrameInfo
---@field textureKit string
---@field openSoundKitID number
---@field closeSoundKitID number
---@field titleText string
---@field tutorialText string
---@field buttonText string
---@field interactionType UIItemInteractionType
---@field flags number
---@field description string|nil
---@field buttonTooltip string|nil
---@field confirmationDescription string|nil
---@field cost number|nil
---@field currencyTypeId number|nil
---@field dropInSlotSoundKitId number|nil
