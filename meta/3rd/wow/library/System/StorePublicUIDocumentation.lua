---@meta
C_StorePublic = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_StorePublic.DoesGroupHavePurchaseableProducts)
---@param groupID number
---@return boolean hasPurchaseableProducts
function C_StorePublic.DoesGroupHavePurchaseableProducts(groupID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_StorePublic.IsDisabledByParentalControls)
---@return boolean disabled
function C_StorePublic.IsDisabledByParentalControls() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_StorePublic.IsEnabled)
---@return boolean enabled
function C_StorePublic.IsEnabled() end
