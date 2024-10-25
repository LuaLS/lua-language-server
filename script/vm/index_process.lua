---@class VM.IndexProcess
local M = Class 'VM.IndexProcess'

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
function M:__init(vfile, ast)
    self.vfile = vfile
    self.ast = ast
    self.scope = vfile.scope
end

---@return VM.Contribute.Action[]
function M:start()
    ---@type VM.Contribute.Action[]
    self.results = {}
    local main = self.ast.main
    self:parseBlock(main)
    return self.results
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
    if state.kind == 'assign' then
        ---@cast state LuaParser.Node.Assign
        for _, exp in ipairs(state.exps) do
            if exp.kind == 'var' then
                ---@cast exp LuaParser.Node.Var
                self:parseVar(exp)
            end
        end
    end
end

---@param key string
---@param value LuaParser.Node.Exp
---@param var LuaParser.Node.Var
---@return Node.Field
function M:makeField(key, value, var)
    local node = self.scope.node
    local nkey = node.value(key)
    local nvalue
    ---@type Node.Location
    local location = {
        uri = self.vfile.uri,
        offset = var.start,
        length = var.finish - var.start,
    }
    if not value or value.kind == 'nil' then
        nvalue = node.NIL
    elseif value.isLiteral then
        ---@cast value LuaParser.Node.Literal
        nvalue = node.value(value.value)
    elseif value.kind == 'function' then
        nvalue = node.FUNCTION
    elseif value.kind == 'table' then
        nvalue = node.TABLE
    else
        nvalue = node.UNKNOWN
    end
    local field = {
        key = nkey,
        value = nvalue,
        location = location,
    }
    return field
end

---@private
---@param var LuaParser.Node.Var
function M:parseVar(var)
    if var.loc then
        return
    end
    -- global, add to G
    local field = self:makeField(var.id, var.value, var)
    self.results[#self.results+1] = {
        kind = 'global',
        field = field,
    }
end

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
---@return VM.IndexProcess
function ls.vm.createIndexProcess(vfile, ast)
    return New 'VM.IndexProcess' (vfile, ast)
end
