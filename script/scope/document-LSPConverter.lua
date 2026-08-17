---@class Document.LSPConverter
local M = Class 'Document.LSPConverter'

---@param document Document
---@param encoding? Encoder.Encoding  # 默认 'utf-8'
function M:__init(document, encoding)
    self.document = document
    self.encoding = encoding or 'utf-8'
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
---@overload fun(self, targetRange: LSP.Range | Range, targetSelectionRange: LSP.Range | Range, originRange: LSP.Range | Range, originUri?: Uri): LSP.LocationLink
function M:locationLink(...args)
    if #args == 1 then
        ---@type Location
        local location = args[1]
        assert(self.document.file.uri == location.uri)
        return self:_locationLink(location.range, location.selectRange, location.originRange, location.originUri)
    else
        return self:_locationLink(args[1], args[2], args[3], args[4])
    end
end


---@package
function M:_locationLink(range, selectRange, originRange, originUri)
    local link = {
        targetUri = self.document.file.uri,
        targetRange = self:range(range),
        targetSelectionRange = self:range(selectRange or range),
    }

    if originRange then
        originUri = originUri or self.document.file.uri
        local originDoc = self.document.scope?:getDocument(originUri)
        link.originSelectionRange = originDoc?:makeLSPConverter(self.encoding):range(originRange)
    end

    return link
end
