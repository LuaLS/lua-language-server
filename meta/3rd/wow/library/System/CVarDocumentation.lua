---@meta
C_CVar = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.GetCVar)
---@param name CVar
---@return string? value
function C_CVar.GetCVar(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.GetCVarBitfield)
---@param name CVar
---@param index number
---@return boolean? value
function C_CVar.GetCVarBitfield(name, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.GetCVarBool)
---@param name CVar
---@return boolean? value
function C_CVar.GetCVarBool(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.GetCVarDefault)
---@param name CVar
---@return string? defaultValue
function C_CVar.GetCVarDefault(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.RegisterCVar)
---@param name CVar
---@param value? string
function C_CVar.RegisterCVar(name, value) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.ResetTestCVars)
function C_CVar.ResetTestCVars() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.SetCVar)
---@param name CVar
---@param value? string
---@param scriptCVar? string
---@return boolean success
function C_CVar.SetCVar(name, value, scriptCVar) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CVar.SetCVarBitfield)
---@param name CVar
---@param index number
---@param value boolean
---@param scriptCVar? string
---@return boolean success
function C_CVar.SetCVarBitfield(name, index, value, scriptCVar) end
