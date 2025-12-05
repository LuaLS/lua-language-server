---@class Document.LSPConverter
local M = Class 'Document.LSPConverter'

---@param document Document
---@param encoding Encoder.Encoding
function M:__init(document, encoding)
    self.document = document
    self.encoding = encoding
end

---@param position LSP.Position
---@return integer offset # 0-based
function M:at(position)
    local pc = self.document.positionConverter
    return pc:positionToOffset(position.line, position.character, self.encoding)
end

---@param offset integer # 0-based
---@return LSP.Position
function M:position(offset)
    local pc = self.document.positionConverter
    local line, character = pc:offsetToPosition(offset, self.encoding)
    return { line = line, character = character }
end

---@overload fun(self, range: Range): LSP.Range
---@overload fun(self, range: LSP.Range): LSP.Range
---@overload fun(self, startOffset: integer, endOffset: integer): LSP.Range
function M:range(...)
    -- fun(startOffset: integer, endOffset: integer)
    local startOffset, endOffset = ...
    if endOffset then
        return {
            start = self:position(startOffset),
            ['end'] = self:position(endOffset),
        }
    end
    local range = ...
    -- fun(range: Range)
    if #range == 2 then
        return {
            start = self:position(range[1]),
            ['end'] = self:position(range[2]),
        }
    end
    -- fun(LSP.Range)
    return range
end

---@param rangeOrLocation LSP.Range | Range | Location
---@return LSP.Location
function M:location(rangeOrLocation)
    if rangeOrLocation.uri then
        ---@cast rangeOrLocation Location
        assert(self.document.file.uri == rangeOrLocation.uri)
        return {
            uri = self.document.file.uri,
            range = self:range(rangeOrLocation.range),
        }
    end

    ---@cast rangeOrLocation LSP.Range | Range
    return {
        uri = self.document.file.uri,
        range = self:range(rangeOrLocation),
    }
end

---@overload fun(self, location: Location): LSP.LocationLink
---@overload fun(self, targetRange: LSP.Range | Range, targetSelectionRange: LSP.Range | Range, originRange: LSP.Range | Range): LSP.LocationLink
function M:locationLink(...)
    -- fun(self, location: Location)
    local location = ...
    if location.uri then
        ---@cast location Location
        assert(self.document.file.uri == location.uri)
        return {
            targetUri = location.uri,
            targetRange = self:range(location.range),
            targetSelectionRange = self:range(location.selectRange or location.range),
            originSelectionRange = location.originRange and self:range(location.originRange) or nil,
        }
    end
    -- fun(self, targetRange: LSP.Range | Range, targetSelectionRange: LSP.Range | Range, originRange: LSP.Range | Range)
    local targetRange, targetSelectionRange, originRange = ...
    return {
        targetUri = self.document.file.uri,
        targetRange = self:range(targetRange),
        targetSelectionRange = self:range(targetSelectionRange),
        originSelectionRange = self:range(originRange),
    }
end
