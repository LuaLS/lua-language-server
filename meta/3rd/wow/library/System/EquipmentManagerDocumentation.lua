---@meta
C_EquipmentSet = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.AssignSpecToEquipmentSet)
---@param equipmentSetID number
---@param specIndex number
function C_EquipmentSet.AssignSpecToEquipmentSet(equipmentSetID, specIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.CanUseEquipmentSets)
---@return boolean canUseEquipmentSets
function C_EquipmentSet.CanUseEquipmentSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.ClearIgnoredSlotsForSave)
function C_EquipmentSet.ClearIgnoredSlotsForSave() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.CreateEquipmentSet)
---@param equipmentSetName string
---@param icon? string
function C_EquipmentSet.CreateEquipmentSet(equipmentSetName, icon) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.DeleteEquipmentSet)
---@param equipmentSetID number
function C_EquipmentSet.DeleteEquipmentSet(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.EquipmentSetContainsLockedItems)
---@param equipmentSetID number
---@return boolean hasLockedItems
function C_EquipmentSet.EquipmentSetContainsLockedItems(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetEquipmentSetAssignedSpec)
---@param equipmentSetID number
---@return number specIndex
function C_EquipmentSet.GetEquipmentSetAssignedSpec(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetEquipmentSetForSpec)
---@param specIndex number
---@return number equipmentSetID
function C_EquipmentSet.GetEquipmentSetForSpec(specIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetEquipmentSetID)
---@param equipmentSetName string
---@return number equipmentSetID
function C_EquipmentSet.GetEquipmentSetID(equipmentSetName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetEquipmentSetIDs)
---@return number[] equipmentSetIDs
function C_EquipmentSet.GetEquipmentSetIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetEquipmentSetInfo)
---@param equipmentSetID number
---@return string name
---@return number iconFileID
---@return number setID
---@return boolean isEquipped
---@return number numItems
---@return number numEquipped
---@return number numInInventory
---@return number numLost
---@return number numIgnored
function C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetIgnoredSlots)
---@param equipmentSetID number
---@return boolean[] slotIgnored
function C_EquipmentSet.GetIgnoredSlots(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetItemIDs)
---@param equipmentSetID number
---@return number[] itemIDs
function C_EquipmentSet.GetItemIDs(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetItemLocations)
---@param equipmentSetID number
---@return number[] locations
function C_EquipmentSet.GetItemLocations(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.GetNumEquipmentSets)
---@return number numEquipmentSets
function C_EquipmentSet.GetNumEquipmentSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.IgnoreSlotForSave)
---@param slot number
function C_EquipmentSet.IgnoreSlotForSave(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.IsSlotIgnoredForSave)
---@param slot number
---@return boolean isSlotIgnored
function C_EquipmentSet.IsSlotIgnoredForSave(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.ModifyEquipmentSet)
---@param equipmentSetID number
---@param newName string
---@param newIcon? string
function C_EquipmentSet.ModifyEquipmentSet(equipmentSetID, newName, newIcon) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.PickupEquipmentSet)
---@param equipmentSetID number
function C_EquipmentSet.PickupEquipmentSet(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.SaveEquipmentSet)
---@param equipmentSetID number
---@param icon? string
function C_EquipmentSet.SaveEquipmentSet(equipmentSetID, icon) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.UnassignEquipmentSetSpec)
---@param equipmentSetID number
function C_EquipmentSet.UnassignEquipmentSetSpec(equipmentSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.UnignoreSlotForSave)
---@param slot number
function C_EquipmentSet.UnignoreSlotForSave(slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_EquipmentSet.UseEquipmentSet)
---@param equipmentSetID number
---@return boolean setWasEquipped
function C_EquipmentSet.UseEquipmentSet(equipmentSetID) end
