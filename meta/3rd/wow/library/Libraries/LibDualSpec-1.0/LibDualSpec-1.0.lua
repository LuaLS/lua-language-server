---@meta
---@class LibDualSpec-1.0
local lib = {}

---@param target table the AceDB-3.0 instance.
---@param name string a user-friendly name of the database (best bet is the addon name).
function lib:EnhanceDatabase(target, name) end

---@param optionTable table The option table returned by AceDBOptions-3.0.
---@param target table The AceDB-3.0 the options operate on.
function lib:EnhanceOptions(optionTable, target) end