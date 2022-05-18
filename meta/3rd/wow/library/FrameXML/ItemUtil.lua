---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/ItemTransmogInfoMixin)
---@class ItemTransmogInfoMixin
ItemTransmogInfoMixin = {}

--- See [CreateAndInitFromMixin](https://www.townlong-yak.com/framexml/go/CreateAndInitFromMixin)
---@param appearanceID number
---@param secondaryAppearanceID number?
---@param illusionID number?
function ItemTransmogInfoMixin:Init(appearanceID, secondaryAppearanceID, illusionID) end

---@param itemTransmogInfo table
---@return boolean
function ItemTransmogInfoMixin:IsEqual(itemTransmogInfo) end

function ItemTransmogInfoMixin:Clear() end

---@param isLegionArtifact boolean
function ItemTransmogInfoMixin:ConfigureSecondaryForMainHand(isLegionArtifact) end

---@return boolean
function ItemTransmogInfoMixin:IsMainHandIndividualWeapon() end

---@return boolean
function ItemTransmogInfoMixin:IsMainHandPairedWeapon() end
