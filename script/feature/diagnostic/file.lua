local converter = require 'feature.diagnostic.converter'

---@class Feature.Diagnostic.File: Class.Base
---@field vfile VM.Vfile
---@field contributions Feature.Diagnostic[]
---@field lastResults Feature.Diagnostic[]?
---@field version integer
---@field calculated boolean
---@field refreshTask Task?
---@field pushTimer Timer?
local M = Class 'Feature.Diagnostic.File'

---@type VM.Vfile
M.vfile = nil
---@type Feature.Diagnostic[]
M.contributions = nil
---@type Feature.Diagnostic[]?
M.lastResults = nil
---@type integer
M.version = -1
---@type boolean
M.calculated = false

local DELAY = 0.1

---@param vfile VM.Vfile
function M:__init(vfile)
    self.vfile = vfile
    self.contributions = {}
end

function M:__del()
    self.refreshTask?:reject(ls.task.REJECT_CANCELED)
    self:stop()
    self.contributions = {}
    self:pushNow()
end

function M:stop()
    self.pushTimer?:remove()
    self.pushTimer = nil
end

---@param item Feature.Diagnostic
function M:contribute(item)
    self.contributions[#self.contributions+1] = item
    self:schedulePush()
end

---@param callback? fun(results: Feature.Diagnostic[])
---@return Task
function M:refresh(callback)
    self.refreshTask?:reject(ls.task.REJECT_CANCELED)
    self.refreshTask = ls.task.create({}, function (result, err)
        self:pushNow()
        if callback then
            callback(result)
        end
    end)
        ---@async
        : execute(function (task)
            ls.await.sleep(DELAY)
            local vfile = self.vfile
            ls.scope.waitReady(vfile.uri)
            if self.calculated and self.version == vfile.version then
                task:resolve(self.lastResults or {})
                return
            end
            self:stop()
            self.contributions = {}
            self.calculated = true
            self.version = vfile.version
            local results = ls.feature.diagnostic(vfile.uri, function (item)
                self:contribute(item)
            end)

            task:resolve(results)
        end)

    return self.refreshTask
end

---@package
M.pushTimer = nil

function M:schedulePush()
    if self.pushTimer then
        return
    end
    self.pushTimer = ls.timer.wait(DELAY, function ()
        self.pushTimer = nil
        self:pushNow()
    end)
end

---@param results Feature.Diagnostic[]
---@return Feature.Diagnostic[]
local function organize(results)
    table.sort(results, function (a, b)
        if a.start == b.start then
            return a.finish < b.finish
        end
        return a.start < b.start
    end)

    local deduped = {}
    local i = 1
    while i <= #results do
        local best = results[i]
        local j = i + 1
        while j <= #results
        and results[j].start == best.start
        and results[j].finish == best.finish do
            if results[j].level < best.level then
                best = results[j]
            end
            j = j + 1
        end
        deduped[#deduped+1] = best
        i = j
    end
    return deduped
end

function M:pushNow()
    self.pushTimer?:remove()
    self.pushTimer = nil
    local results = organize(self.contributions)
    if ls.util.equal(self.lastResults, results) then
        return
    end
    self.lastResults = results

    local server = ls.server
    if not server then
        return
    end
    local items = {}
    if #results > 0 then
        local document = self.vfile.scope:getDocument(self.vfile.uri)
        if not document then
            return
        end
        items = converter.convert(document, results, server.positionEncoding)
    end
    server.client:notify('textDocument/publishDiagnostics', {
        uri         = self.vfile.uri,
        diagnostics = items,
    })
end

function M:remove()
    Delete(self)
end
