---@meta
---@class EditBox : Frame
local EditBox = {}

---@param scriptType ScriptEditBox
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return function handler
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_GetScript)
function EditBox:GetScript(scriptType, bindingType) end

---@param scriptType ScriptEditBox
---@return boolean hasScript
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HasScript)
function EditBox:HasScript(scriptType) end

---@param scriptType ScriptEditBox
---@param handler function
---@param bindingType LE_SCRIPT_BINDING_TYPE
---@return boolean success
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_HookScript)
function EditBox:HookScript(scriptType, handler, bindingType) end

---@param scriptType ScriptEditBox
---@param handler function
---[Documentation](https://wowpedia.fandom.com/wiki/API_ScriptObject_SetScript)
function EditBox:SetScript(scriptType, handler) end


---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_AddHistoryLine)
function EditBox:AddHistoryLine(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_ClearFocus)
function EditBox:ClearFocus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_ClearHistory)
function EditBox:ClearHistory() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_Disable)
function EditBox:Disable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_Enable)
function EditBox:Enable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetAltArrowKeyMode)
function EditBox:GetAltArrowKeyMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetBlinkSpeed)
function EditBox:GetBlinkSpeed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetCursorPosition)
function EditBox:GetCursorPosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetDisplayText)
function EditBox:GetDisplayText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetHighlightColor)
function EditBox:GetHighlightColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetHistoryLines)
function EditBox:GetHistoryLines() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetInputLanguage)
function EditBox:GetInputLanguage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetMaxBytes)
function EditBox:GetMaxBytes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetMaxLetters)
function EditBox:GetMaxLetters() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetNumLetters)
function EditBox:GetNumLetters() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetNumber)
function EditBox:GetNumber() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetText)
function EditBox:GetText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetTextInsets)
function EditBox:GetTextInsets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetUTF8CursorPosition)
function EditBox:GetUTF8CursorPosition() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_GetVisibleTextByteLimit)
function EditBox:GetVisibleTextByteLimit() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_HasFocus)
function EditBox:HasFocus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_HighlightText)
function EditBox:HighlightText(startPos, endPos) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_Insert)
function EditBox:Insert(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsAutoFocus)
function EditBox:IsAutoFocus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsCountInvisibleLetters)
function EditBox:IsCountInvisibleLetters() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsEnabled)
function EditBox:IsEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsInIMECompositionMode)
function EditBox:IsInIMECompositionMode() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsMultiLine)
function EditBox:IsMultiLine() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsNumeric)
function EditBox:IsNumeric() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsPassword)
function EditBox:IsPassword() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_IsSecureText)
function EditBox:IsSecureText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetAltArrowKeyMode)
function EditBox:SetAltArrowKeyMode(enable) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetAutoFocus)
function EditBox:SetAutoFocus(state) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetBlinkSpeed)
function EditBox:SetBlinkSpeed(speed) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetCountInvisibleLetters)
function EditBox:SetCountInvisibleLetters() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetCursorPosition)
function EditBox:SetCursorPosition(position) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetEnabled)
function EditBox:SetEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetFocus)
function EditBox:SetFocus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetHighlightColor)
function EditBox:SetHighlightColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetHistoryLines)
function EditBox:SetHistoryLines(numLines) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxBytes)
function EditBox:SetMaxBytes(maxBytes) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters)
function EditBox:SetMaxLetters(maxLetters) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetMultiLine)
function EditBox:SetMultiLine(state) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetNumber)
function EditBox:SetNumber(number) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetNumeric)
function EditBox:SetNumeric(state) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetPassword)
function EditBox:SetPassword(state) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetSecureText)
function EditBox:SetSecureText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetSecurityDisablePaste)
function EditBox:SetSecurityDisablePaste() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetSecurityDisableSetText)
function EditBox:SetSecurityDisableSetText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetText)
function EditBox:SetText(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetTextInsets)
function EditBox:SetTextInsets(l, r, t, b) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_SetVisibleTextByteLimit)
function EditBox:SetVisibleTextByteLimit(maxVisibleBytes) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_EditBox_ToggleInputLanguage)
function EditBox:ToggleInputLanguage() end
