---@class Feature.Diagnostic.File: Class.Base
---@field vfile VM.Vfile
local M = Class 'Feature.Diagnostic.File'

---@type VM.Vfile
M.vfile = nil
---@type integer
M.version = -1
---@type Feature.Diagnostic[]?
M.results = nil
---@type boolean
M.dirty = false

---@param vfile VM.Vfile
function M:__init(vfile)
    self.vfile = vfile
end

function M:markDirty()
    self.dirty = true
end

---@async
---@return Feature.Diagnostic[]?
function M:fetch()
    local vfile = self.vfile
    ls.scope.waitReady(vfile.uri)
    vfile:awaitIndex()
    if not self.dirty and self.version == vfile.version then
        return nil
    end
    local results = ls.feature.diagnostic(vfile.uri)
    self.dirty = false
    self.version = vfile.version
    if ls.util.equal(self.results, results) then
        return nil
    end
    self.results = results
    return results
end

function M:dispose()
    self.results = nil
    self.version = -1
    self.dirty = false
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
