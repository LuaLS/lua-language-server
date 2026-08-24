---@class Feature.Diagnostic.Converter
local M = {}

---@param diag Feature.Diagnostic
---@param converter Document.LSPConverter
---@return LSP.Diagnostic
local function convertDiagnostic(diag, converter)
    ---@type LSP.Diagnostic
    local result = {
        range    = converter:range(diag.start, diag.finish),
        severity = diag.level,
        code     = diag.code,
        source   = 'Lua',
        message  = diag.message,
    }
    if diag.tags then
        result.tags = diag.tags
    end
    if diag.related then
        local relatedInformation = {}
        for i, rel in ipairs(diag.related) do
            relatedInformation[i] = {
                location = {
                    uri   = rel.uri,
                    range = converter:range(rel.start, rel.finish),
                },
                message = rel.message,
            }
        end
        result.relatedInformation = relatedInformation
    end
    return result
end

---@param document Document
---@param diagnostics Feature.Diagnostic[]
---@param encoding? Encoder.Encoding
---@return LSP.Diagnostic[]
function M.convert(document, diagnostics, encoding)
    local converter = document:makeLSPConverter(encoding)
    local results = {}
    for i, diag in ipairs(diagnostics) do
        results[i] = convertDiagnostic(diag, converter)
    end
    return results
end

return M
