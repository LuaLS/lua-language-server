---@meta
Item = {}

---[Documentation](https://wowpedia.fandom.com/wiki/ItemMixin)
---@class ItemMixin
ItemMixin = {}

---@param itemLocation ItemLocationMixin
---@return ItemMixin
function Item:CreateFromItemLocation(itemLocation) end

---@param bagID number
---@param slotIndex number
---@return ItemMixin
function Item:CreateFromBagAndSlot(bagID, slotIndex) end

---@param equipmentSlotIndex number
---@return ItemMixin
function Item:CreateFromEquipmentSlot(equipmentSlotIndex) end

---@param itemLink string
---@return ItemMixin
function Item:CreateFromItemLink(itemLink) end

---@param itemID number
---@return ItemMixin
function Item:CreateFromItemID(itemID) end

---@param itemLocation ItemLocationMixin
function ItemMixin:SetItemLocation(itemLocation) end

---@param itemLink string
function ItemMixin:SetItemLink(itemLink) end

---@param itemID number
function ItemMixin:SetItemID(itemID) end

---@return ItemLocationMixin
function ItemMixin:GetItemLocation() end

---@return boolean
function ItemMixin:HasItemLocation() end

function ItemMixin:Clear() end

---@return boolean
function ItemMixin:IsItemEmpty() end

---@return string|number
function ItemMixin:GetStaticBackingItem() end

---@return boolean
function ItemMixin:IsItemInPlayersControl() end

-- Item API
---@return number
function ItemMixin:GetItemID() end

---@return boolean
function ItemMixin:IsItemLocked() end

function ItemMixin:LockItem() end

function ItemMixin:UnlockItem() end

---@return number
function ItemMixin:GetItemIcon() end

---@return string
function ItemMixin:GetItemName() end

---@return string
function ItemMixin:GetItemLink() end

---@return ItemQuality
function ItemMixin:GetItemQuality() end

---@return number
function ItemMixin:GetCurrentItemLevel() end

---@return table
function ItemMixin:GetItemQualityColor() end

---@return InventoryType
function ItemMixin:GetInventoryType() end

---@return string
function ItemMixin:GetItemGUID() end

---@return string
function ItemMixin:GetInventoryTypeName() end

---@return boolean
function ItemMixin:IsItemDataCached() end

---@return boolean
function ItemMixin:IsDataEvictable() end

--- Add a callback to be executed when item data is loaded, if the item data is already loaded then execute it immediately
---@param callbackFunction function
function ItemMixin:ContinueOnItemLoad(callbackFunction) end

--- Same as ContinueOnItemLoad, except it returns a function that when called will cancel the continue
---@param callbackFunction function
---@return function
function ItemMixin:ContinueWithCancelOnItemLoad(callbackFunction) end
