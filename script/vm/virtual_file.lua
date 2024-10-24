---@class VM.Vfile
local M = Class 'VM.Vfile'

M.version = 0
M.indexedVersion = -1

---@param scope Scope
---@param uri Uri
function M:__init(scope, uri)
    self.scope = scope
    self.uri = uri
    self.contribute = ls.vm.createContribute(self.scope)
end

function M:__del()
    self.contribute:remove()
end

---@type VM.Contribute
M.contribute = nil

---@param indexNow? boolean
function M:update(indexNow)
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.version == document.serverVersion then
        return
    end
    self.version = document.serverVersion
    self:resetContribute()

    if indexNow then
        self:indexAst(document.ast)
    end
end

function M:resetContribute()
    if self.contribute then
        self.contribute:remove()
    end
    self.contribute = ls.vm.createContribute(self.scope)
end

---@param ast LuaParser.Ast
function M:indexAst(ast)
    if self.indexedVersion == self.version then
        return
    end
    self.indexedVersion = self.version

    local process = ls.vm.createIndexProcess(self, ast)
    local actions = process:start()
    self.contribute:commitActions(actions)
end


function M:remove()
    Delete(self)
end

---@param scope Scope
---@param uri Uri
---@return VM.Vfile
function ls.vm.createVfile(scope, uri)
    return New 'VM.Vfile' (scope, uri)
end
