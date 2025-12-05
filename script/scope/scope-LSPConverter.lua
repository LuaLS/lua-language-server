---@class Scope.LSPConverter
local M = Class 'Scope.LSPConverter'

---@param scope Scope
---@param encoding Encoder.Encoding
function M:__init(scope, encoding)
    self.scope = scope
    self.encoding = encoding
end

---@overload fun(self, location: Location): LSP.Location?
---@overload fun(self, uri: Uri, range: LSP.Range | Range): LSP.Location?
function M:location(...)
    -- fun(self, uri: Uri, range: LSP.Range | Range)
    local uri, range = ...
    if not range then
        -- fun(self, location: Location)
        local location = ...
        uri = location.uri
        range = location.range
    end

    local document = self.scope:getDocument(uri)
    if not document then
        return nil
    end
    local converter = document:makeLSPConverter(self.encoding)
    return converter:location(range)
end

---@overload fun(self, location: Location): LSP.LocationLink?
---@overload fun(self, uri: Uri, targetRange: LSP.Range | Range, targetSelectionRange: LSP.Range | Range, originRange: LSP.Range | Range): LSP.LocationLink?
function M:locationLink(...)
    -- fun(self, uri: Uri, targetRange: LSP.Range | Range, targetSelectionRange: LSP.Range | Range, originRange: LSP.Range | Range)
    local uri, targetRange = ...
    if targetRange then
        local document = self.scope:getDocument(uri)
        if not document then
            return nil
        end
        local converter = document:makeLSPConverter(self.encoding)
        return converter:locationLink(select(2, ...))
    end
    -- fun(self, location: Location)
    local location = ...
    uri = location.uri
    local document = self.scope:getDocument(uri)
    if not document then
        return nil
    end
    local converter = document:makeLSPConverter(self.encoding)
    return converter:locationLink(location)
end
