---@class VM
local M = Class 'VM'

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    self.vfiles = ls.fs.newMap()
end

---@param uri Uri
---@return VM.Vfile
function M:indexFile(uri)
    local file = self:getFile(uri)
              or self:createFile(uri)
    file:index()
    return file
end

---@param uri Uri
---@return VM.Vfile?
function M:getFile(uri)
    return self.vfiles[uri]
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

---@param source LuaParser.Node.Base
---@return Node?
function M:getNode(source)
    local uri = source.ast.source
    local vfile = self:getFile(uri)
    if not vfile then
        return nil
    end
    return vfile:getNode(source)
end

---@param source LuaParser.Node.Base
---@return Node.Variable?
function M:getVariable(source)
    local uri = source.ast.source
    local vfile = self:getFile(uri)
    if not vfile then
        return nil
    end
    return vfile:getVariable(source)
end

---@param scope Scope
---@return VM
function ls.vm.create(scope)
    return New 'VM' (scope)
end

return M
