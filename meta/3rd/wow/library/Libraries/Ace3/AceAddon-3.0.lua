---@meta
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0)
---@class AceAddon-3.0
local AceAddon = {}

---@return boolean @if possible, return true or false depending on success.
-- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-2)
function AceAddon:Disable() end

---@return boolean @if possible, return true or false depending on success.
---@param name string
-- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-3)
function AceAddon:DisableModule(name) end

---@return boolean @if possible, return true or false depending on success.
-- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-4)
function AceAddon:Enable() end


---@param name string
---@return boolean @if possible, return true or false depending on success.
-- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-5)
function AceAddon:EnableModule(name) end

---@param name string
---@param silent? boolean
---@return table module
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-6)
function AceAddon:GetModule(name, silent) end

---@return string name
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-7)
function AceAddon:GetName() end

---@return boolean enabled
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-8)
function AceAddon:IsEnabled() end

---@return function iter
---@return table invariant
---@return number init
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-9)
function AceAddon:IterateModules() end

---@param name string
---@param lib string
---@vararg string
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-10)
function AceAddon:NewModule(name, lib, ...) end
--function AceAddon:NewModule(name, prototype, lib, ...) end

---@param lib string
---@vararg string
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-11)
function AceAddon:SetDefaultModuleLibraries(lib, ...) end

---@param prototype table
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-12)
function AceAddon:SetDefaultModulePrototype(prototype) end

---@param state boolean
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-13)
function AceAddon:SetDefaultModuleState(state) end

---@param state boolean
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-14)
function AceAddon:SetEnabledState(state) end

---@param name string
---@param silent? boolean
---@return AceAddon-3.0
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-15)
function AceAddon:GetAddon(name, silent) end

---@return function iter
---@return table invariant
---@return number init
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-16)
function AceAddon:IterateAddonStatus() end

---@return function iter
---@return table invariant
---@return number init
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-17)
function AceAddon:IterateAddons() end

---@param object? table
---@param name string
---@param lib string
---@param ... any
---@return AceAddon-3.0
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-18)
function AceAddon:NewAddon(object, name, lib, ...) end
