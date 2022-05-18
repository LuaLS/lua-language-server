---@meta
C_ScrappingMachineUI = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.CloseScrappingMachine)
function C_ScrappingMachineUI.CloseScrappingMachine() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.DropPendingScrapItemFromCursor)
---@param index number
function C_ScrappingMachineUI.DropPendingScrapItemFromCursor(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex)
---@param index number
---@return ItemLocationMixin itemLoc
function C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.GetScrapSpellID)
---@return number spellID
function C_ScrappingMachineUI.GetScrapSpellID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.GetScrappingMachineName)
---@return string name
function C_ScrappingMachineUI.GetScrappingMachineName() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.HasScrappableItems)
---@return boolean hasScrappableItems
function C_ScrappingMachineUI.HasScrappableItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.RemoveAllScrapItems)
function C_ScrappingMachineUI.RemoveAllScrapItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.RemoveCurrentScrappingItem)
function C_ScrappingMachineUI.RemoveCurrentScrappingItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.RemoveItemToScrap)
---@param index number
function C_ScrappingMachineUI.RemoveItemToScrap(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.ScrapItems)
function C_ScrappingMachineUI.ScrapItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.SetScrappingMachine)
---@param gameObject string
function C_ScrappingMachineUI.SetScrappingMachine(gameObject) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScrappingMachineUI.ValidateScrappingList)
function C_ScrappingMachineUI.ValidateScrappingList() end
