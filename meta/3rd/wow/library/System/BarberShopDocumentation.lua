---@meta
C_BarberShop = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.ApplyCustomizationChoices)
---@return boolean success
function C_BarberShop.ApplyCustomizationChoices() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.Cancel)
function C_BarberShop.Cancel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.ClearPreviewChoices)
---@param clearSavedChoices boolean
function C_BarberShop.ClearPreviewChoices(clearSavedChoices) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.GetAvailableCustomizations)
---@return CharCustomizationCategory[] categories
function C_BarberShop.GetAvailableCustomizations() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.GetCurrentCameraZoom)
---@return number zoomLevel
function C_BarberShop.GetCurrentCameraZoom() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.GetCurrentCharacterData)
---@return BarberShopCharacterData characterData
function C_BarberShop.GetCurrentCharacterData() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.GetCurrentCost)
---@return number cost
function C_BarberShop.GetCurrentCost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.HasAnyChanges)
---@return boolean hasChanges
function C_BarberShop.HasAnyChanges() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.IsViewingAlteredForm)
---@return boolean isViewingAlteredForm
function C_BarberShop.IsViewingAlteredForm() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.MarkCustomizationChoiceAsSeen)
---@param choiceID number
function C_BarberShop.MarkCustomizationChoiceAsSeen(choiceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.MarkCustomizationOptionAsSeen)
---@param optionID number
function C_BarberShop.MarkCustomizationOptionAsSeen(optionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.PreviewCustomizationChoice)
---@param optionID number
---@param choiceID number
function C_BarberShop.PreviewCustomizationChoice(optionID, choiceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.RandomizeCustomizationChoices)
function C_BarberShop.RandomizeCustomizationChoices() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.ResetCameraRotation)
function C_BarberShop.ResetCameraRotation() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.ResetCustomizationChoices)
function C_BarberShop.ResetCustomizationChoices() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.RotateCamera)
---@param diffDegrees number
function C_BarberShop.RotateCamera(diffDegrees) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SaveSeenChoices)
function C_BarberShop.SaveSeenChoices() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetCameraDistanceOffset)
---@param offset number
function C_BarberShop.SetCameraDistanceOffset(offset) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetCameraZoomLevel)
---@param zoomLevel number
---@param keepCustomZoom? boolean
function C_BarberShop.SetCameraZoomLevel(zoomLevel, keepCustomZoom) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetCustomizationChoice)
---@param optionID number
---@param choiceID number
function C_BarberShop.SetCustomizationChoice(optionID, choiceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetModelDressState)
---@param dressedState boolean
function C_BarberShop.SetModelDressState(dressedState) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetSelectedSex)
---@param sex number
function C_BarberShop.SetSelectedSex(sex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetViewingAlteredForm)
---@param isViewingAlteredForm boolean
function C_BarberShop.SetViewingAlteredForm(isViewingAlteredForm) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.SetViewingShapeshiftForm)
---@param shapeshiftFormID? number
function C_BarberShop.SetViewingShapeshiftForm(shapeshiftFormID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BarberShop.ZoomCamera)
---@param zoomAmount number
function C_BarberShop.ZoomCamera(zoomAmount) end

---@class BarberShopCharacterData
---@field raceData BarberShopRaceData
---@field sex number

---@class BarberShopRaceData
---@field name string
---@field fileName string
---@field alternateFormRaceData CharacterAlternateFormData|nil
