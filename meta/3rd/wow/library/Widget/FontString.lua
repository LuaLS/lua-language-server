---@meta
---@class FontString : FontInstance, LayeredRegion
---[Documentation](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
local FontString = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_CalculateScreenAreaFromCharacterSpan)
function FontString:CalculateScreenAreaFromCharacterSpan(leftCharacterIndex, rightCharacterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_CanNonSpaceWrap)
function FontString:CanNonSpaceWrap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_CanWordWrap)
function FontString:CanWordWrap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_FindCharacterIndexAtCoordinate)
function FontString:FindCharacterIndexAtCoordinate(x, y) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetFieldSize)
function FontString:GetFieldSize() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetLineHeight)
function FontString:GetLineHeight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetMaxLines)
function FontString:GetMaxLines() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetNumLines)
function FontString:GetNumLines() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetStringHeight)
function FontString:GetStringHeight() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetStringWidth)
function FontString:GetStringWidth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetText)
function FontString:GetText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetUnboundedStringWidth)
function FontString:GetUnboundedStringWidth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_GetWrappedWidth)
function FontString:GetWrappedWidth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_IsTruncated)
function FontString:IsTruncated() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetAlphaGradient)
function FontString:SetAlphaGradient(start, length) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetFixedColor)
function FontString:SetFixedColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetFormattedText)
---@param formatstring string A string containing format specifiers (as with string.format()).
---@param ... any arg A list of values to be included in the formatted string.
function FontString:SetFormattedText(formatstring, ...) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetMaxLines)
function FontString:SetMaxLines() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetNonSpaceWrap)
function FontString:SetNonSpaceWrap(wrapFlag) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetText)
function FontString:SetText(text) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetTextHeight)
function FontString:SetTextHeight(pixelHeight) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_FontString_SetWordWrap)
function FontString:SetWordWrap() end
