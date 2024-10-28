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
            if not exp.value then
                goto continue
            end
            if exp.kind == 'var' then
                ---@cast exp LuaParser.Node.Var
                self:parseVar(exp)
            elseif exp.kind == 'field' then
                ---@cast exp LuaParser.Node.Field
                self:parseField(exp)
            end
            ::continue::
        end
    elseif state.kind == 'cat' then
        ---@cast state LuaParser.Node.Cat
        self:parseCat(state)
    end
end

---@param key Node.Key
---@param value LuaParser.Node.Exp
---@param var LuaParser.Node.Base
---@return Node.Field
function M:makeField(key, value, var)
    local node = self.scope.node
    ---@type Node
    local nkey
    if type(key) ~= 'table' then
        ---@cast key -Node
        nkey = node.value(key)
    else
        ---@cast key Node
        nkey = key
    end
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

---@param field LuaParser.Node.Term
---@return Node.Key
function M:getFieldPath(field)
    if field.kind == 'field' then
        ---@cast field LuaParser.Node.Field
        local key = field.key
        if key.kind == 'fieldid' then
            ---@cast key LuaParser.Node.FieldID
            return key.id
        else
            ---@cast key LuaParser.Node.Exp
            if key.isLiteral then
                ---@cast key LuaParser.Node.Literal
                return key.value or self.scope.node.UNKNOWN
            end
            return self.scope.node.UNKNOWN
        end
    elseif field.kind == 'var' then
        ---@cast field LuaParser.Node.Var
        return field.id
    else
        return self.scope.node.UNKNOWN
    end
end

---@private
---@param field LuaParser.Node.Field
---@return Node.Key[]
---@return LuaParser.Node.Var?
function M:makeFieldPath(field)
    local path = {}
    local var

    local current = field.last
    for _ = 1, 1000 do
        if not current then
            break
        end
        path[#path+1] = self:getFieldPath(current)
        if current.kind == 'var' then
            var = current
            break
        end
        current = current.last
    end

    ls.util.revertArray(path)

    return path, var
end

---@private
---@param field LuaParser.Node.Field
function M:parseField(field)
    local key = self:getFieldPath(field)

    local path, var = self:makeFieldPath(field)
    if not var or var.loc then
        return
    end

    local nfield = self:makeField(key, field.value, field)
    self.results[#self.results+1] = {
        kind = 'global',
        field = nfield,
        path = path,
    }
end

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
---@return VM.IndexProcess
function ls.vm.createIndexProcess(vfile, ast)
    return New 'VM.IndexProcess' (vfile, ast)
end
