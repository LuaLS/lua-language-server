---@class VM.IndexProcess
local M = Class 'VM.IndexProcess'

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
function M:__init(vfile, ast)
    self.vfile = vfile
    self.ast = ast
    self.scope = vfile.scope
end

function M:start()
    local node = self.scope.node
    node:lockCache()
    local main = self.ast.main
    self:parseBlock(main)
    node:unlockCache()
end

---@private
---@param block LuaParser.Node.Function
function M:parseBlock(block)
    for _, child in ipairs(block.childs) do
        self:parseState(child)
    end
end

---@private
---@param state LuaParser.Node.State
function M:parseState(state)
end

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
---@return VM.IndexProcess
function ls.vm.createIndexProcess(vfile, ast)
    return New 'VM.IndexProcess' (vfile, ast)
end
