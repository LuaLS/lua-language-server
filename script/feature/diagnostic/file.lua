local converter = require 'feature.diagnostic.converter'
local merge     = require 'feature.diagnostic.merge'

---@class Feature.Diagnostic.Contribution
---@field items Feature.Diagnostic[]
---@field disposed boolean

---@class Feature.Diagnostic.File: Class.Base
---@field vfile VM.Vfile
local M = Class 'Feature.Diagnostic.File'

---@type VM.Vfile
M.vfile = nil
---@type Feature.Diagnostic.Contribution[]
M.contributions = nil
---@type Feature.Diagnostic[]?
M.results = nil
---@type Task?
M.pushTask = nil
---@type fun()?
M.fileDispose = nil
---@type integer
M.version = -1

local DELAY = 0.1

---@param vfile VM.Vfile
function M:__init(vfile)
    self.vfile = vfile
    self.contributions = {}
end

---@param items Feature.Diagnostic[]
---@return fun()
function M:contribute(items)
    local contribution = { items = items }
    self.contributions[#self.contributions+1] = contribution
    self:schedulePush()
    return function ()
        if contribution.disposed then
            return
        end
        contribution.disposed = true
        ls.util.arrayRemove(self.contributions, contribution, true)
        self:schedulePush()
    end
end

---@async
function M:refresh()
    local vfile = self.vfile
    ls.scope.waitReady(vfile.uri)
    vfile:awaitIndex()
    if self.fileDispose and self.version == vfile.version then
        return
    end
    if self.fileDispose then
        self.fileDispose()
        self.fileDispose = nil
    end
    self.version = vfile.version
    local results = ls.feature.diagnostic(vfile.uri)
    self.fileDispose = self:contribute(results)
end

function M:schedulePush()
    if self.pushTask then
        self.pushTask:reject(ls.task.REJECT_CANCELED)
    end
    self.pushTask = ls.task.create(nil, function (result, err)
        if result then
            self:push()
        end
    end)
    ---@async
    : execute(function (task)
        ls.await.sleep(DELAY)
        task:resolve(true)
    end)
end

---@return Feature.Diagnostic[]
function M:merge()
    local results = {}
    for _, contribution in ipairs(self.contributions) do
        for _, item in ipairs(contribution.items) do
            results[#results+1] = item
        end
    end
    return merge.merge(results)
end

function M:push()
    local results = self:merge()
    if ls.util.equal(self.results, results) then
        return
    end
    self.results = results

    local server = ls.server
    if not server then
        return
    end
    local document = self.vfile.scope:getDocument(self.vfile.uri)
    if not document then
        return
    end
    local items = converter.convert(document, results, server.positionEncoding)
    server.client:notify('textDocument/publishDiagnostics', {
        uri         = self.vfile.uri,
        diagnostics = items,
    })
end

function M:dispose()
    self.contributions = {}
    self.fileDispose = nil
    self.results = nil
    self.version = -1
    if self.pushTask then
        self.pushTask:reject(ls.task.REJECT_CANCELED)
        self.pushTask = nil
    end

    local server = ls.server
    if server then
        server.client:notify('textDocument/publishDiagnostics', {
            uri         = self.vfile.uri,
            diagnostics = {},
        })
    end
end

---@param vfile VM.Vfile
---@return Feature.Diagnostic.File
function M.get(vfile)
    if not vfile.diagnostic then
        vfile.diagnostic = New 'Feature.Diagnostic.File' (vfile)
    end
    return vfile.diagnostic
end

return M
