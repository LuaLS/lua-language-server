---@class VM
local M = Class 'VM'

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    self.vfiles = {}
end

---@param uri Uri
function M:indexFile(uri)
    local document = self.scope:getDocument(uri)
    if not document then
        return
    end
end

---@param uri Uri
---@return VM.Vfile
function M:createFile(uri)
    local vfile = ls.vm.createVfile(self.scope, uri)
    self.vfiles[uri] = vfile
    return vfile
end

---@param uri Uri
function M:removeFile(uri)
    local vfile = self.vfiles[uri]
    if not vfile then
        return
    end
    self.vfiles[uri] = nil
    vfile:remove()
end

---@param scope Scope
---@return VM
function ls.vm.create(scope)
    return New 'VM' (scope)
end

return M
