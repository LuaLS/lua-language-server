---@class VM.Vfile
local M = Class 'VM.Vfile'

M.version = 0
M.indexedVersion = -1

---@param scope Scope
---@param uri Uri
function M:__init(scope, uri)
    self.scope = scope
    self.uri = uri
    ---@type table<LuaParser.Node.Block, VM.Runner?>
    self.runners = {}
end

function M:__del()
    self:resetRunners()
end

function M:update()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.version == document.serverVersion then
        return
    end
    self.version = document.serverVersion
    self:resetRunners()
end

function M:resetRunners()
    for block, runner in pairs(self.runners) do
        Delete(runner)
        self.runners[block] = nil
    end
end

---@param ast? LuaParser.Ast
---@param mode any
function M:indexAst(ast, mode)
    if self.indexedVersion == self.version then
        return
    end
    self.indexedVersion = self.version

    if not ast then
        local document = self.scope:getDocument(self.uri)
        if not document then
            return
        end
        ast = document.ast
        if not ast then
            return
        end
    end

    xpcall(function ()
        local runner = self:getRunner(ast.main)
        runner:index()
    end, log.error)
end

---@param block LuaParser.Node.Block
---@param context? VM.Runner.Context
---@return VM.Runner
function M:getRunner(block, context)
    local runner = self.runners[block]
    if not runner then
        runner = ls.vm.createRunner(block, self)
        if context then
            runner:setContext(context)
        end
        self.runners[block] = runner
    end
    return runner
end

---@param source LuaParser.Node.Base
---@return Node?
function M:getNode(source)
    local block = source.parentBlock
    if not block then
        return nil
    end
    local runner = self:getRunner(block)
    runner:index()
    return runner:parse(source)
end

---@param source LuaParser.Node.Base
---@return Node.Variable?
function M:getVariable(source)
    local block = source.parentBlock
    if not block then
        return nil
    end
    local runner = self:getRunner(block)
    runner:index()
    return runner:getVariable(source)
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
