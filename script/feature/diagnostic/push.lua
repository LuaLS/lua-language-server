local converter = require 'feature.diagnostic.converter'

---@class Feature.Diagnostic.Push
local M = {}

---@type table<Uri, Task>
local tasks = {}

---@type table<Uri, LSP.Diagnostic[]>
local cache = {}

local DELAY = 0.1

---@param uri Uri
local function publish(uri)
    local server = ls.server
    if not server then
        return
    end
    local document = ls.scope.findDocument(uri)
    if not document then
        return
    end
    local diagnostics = ls.feature.diagnostic(uri)
    local items = converter.convert(document, diagnostics, server.positionEncoding)
    if ls.util.equal(cache[uri], items) then
        return
    end
    cache[uri] = items
    server.client:notify('textDocument/publishDiagnostics', {
        uri         = uri,
        diagnostics = items,
    })
end

---@param uri Uri
function M.refresh(uri)
    local old = tasks[uri]
    if old then
        old:reject(ls.task.REJECT_CANCELED)
    end
    local task = ls.task.create { uri = uri }
    tasks[uri] = task
    ---@async
    task:execute(function ()
        ls.await.sleep(DELAY)
        publish(uri)
        tasks[uri] = nil
    end)
end

---@param uri Uri
function M.clear(uri)
    local old = tasks[uri]
    if old then
        old:reject(ls.task.REJECT_CANCELED)
    end
    tasks[uri] = nil
    cache[uri] = nil
    local server = ls.server
    if not server then
        return
    end
    server.client:notify('textDocument/publishDiagnostics', {
        uri         = uri,
        diagnostics = {},
    })
end

function M.watchFiles()
    ls.file.onDidChange:on(function (uri)
        M.refresh(uri)
    end)
    ls.file.onDidRemove:on(function (uri)
        M.clear(uri)
    end)
end

return M
