---@class VM.Vfile
local M = Class 'VM.Vfile'

M.version = 0
---@type Document?
M.document = nil

---@param scope Scope
---@param uri Uri
function M:__init(scope, uri)
    self.scope = scope
    self.uri = uri
end

function M:__del()
    self:resetRunners()
end

---@param ast LuaParser.Ast
---@return VM.Coder
function M:makeCoder(ast)
    local coder = ls.vm.createCoder()
    coder:makeFromAst(ast)
    return coder
end

function M:resetRunners()
    for _, runner in pairs(self.runners) do
        Delete(runner)
    end
    self.runners = {}
end

function M:index()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.document == document then
        return
    end
    self.document = document
    self.version = self.version + 1

    self.coder = self:makeCoder(document.ast)
    self.coder:run(self)
end

---@param source LuaParser.Node.Base
---@return Node?
function M:getNode(source)
    if not self.coder then
        return nil
    end
    local key = source.uniqueKey
    local node = self.coder.map[key]
    if not node then
        return nil
    end
    if node.kind == 'variable' then
        return node.value
    end
    return node
end

---@param source LuaParser.Node.Base
---@return Node.Variable?
function M:getVariable(source)
    if not self.coder then
        return nil
    end
    local key = source.uniqueKey
    local node = self.coder.map[key]
    if not node then
        return nil
    end
    if node.kind == 'variable' then
        return node
    end
    return nil
end

---@param source LuaParser.Node.Base
---@param key Node.Key
---@return Node.Field[]?
function M:findFields(source, key)
    error('Not implemented')
    return nil
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
