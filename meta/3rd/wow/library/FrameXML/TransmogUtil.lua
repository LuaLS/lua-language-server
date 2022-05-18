---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/TransmogLocationMixin)
---@class TransmogPendingInfoMixin
TransmogPendingInfoMixin = {}

--- See [CreateAndInitFromMixin](https://www.townlong-yak.com/framexml/go/CreateAndInitFromMixin)
---@param pendingType TransmogPendingType
---@param transmogID number
---@param category number
function TransmogPendingInfoMixin:Init(pendingType, transmogID, category) end

---[Documentation](https://wowpedia.fandom.com/wiki/TransmogLocationMixin)
---@class TransmogLocationMixin
TransmogLocationMixin = {}

---@param slotID number
---@param transmogType TransmogType
---@param modification TransmogModification
function TransmogLocationMixin:Set(slotID, transmogType, modification) end

---@return boolean
function TransmogLocationMixin:IsAppearance() end

---@return boolean
function TransmogLocationMixin:IsIllusion() end

---@return number slotID
function TransmogLocationMixin:GetSlotID() end

---@return string slotName
function TransmogLocationMixin:GetSlotName() end

---@return boolean
function TransmogLocationMixin:IsEitherHand() end

---@return boolean
function TransmogLocationMixin:IsMainHand() end

---@return boolean
function TransmogLocationMixin:IsOffHand() end

---@param transmogLocation TransmogLocationMixin
---@return boolean
function TransmogLocationMixin:IsEqual(transmogLocation) end

---@return number armorCategoryID
function TransmogLocationMixin:GetArmorCategoryID() end

---@return number lookupKey
function TransmogLocationMixin:GetLookupKey() end

---@return boolean
function TransmogLocationMixin:IsSecondary() end
