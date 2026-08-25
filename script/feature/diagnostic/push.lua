local converter = require 'feature.diagnostic.converter'
local File      = require 'feature.diagnostic.file'

---@class Feature.Diagnostic.Push
local M = {}

---@type table<Uri, Task>
local tasks = {}

local DELAY = 0.1

---@async
---@param uri Uri
local function publish(uri)
    local server = ls.server
    if not server then
        return
    end
    local scope = ls.scope.find(uri)
    if not scope then
        return
    end
    local vfile = scope.vm:getFile(uri)
               or scope.vm:createFile(uri)
    local document = scope:getDocument(uri)
    if not document then
        return
    end
    local results = File.get(vfile):fetch()
    if not results then
        return
    end
    local items = converter.convert(document, results, server.positionEncoding)
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
