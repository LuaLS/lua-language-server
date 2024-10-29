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
    self.parsedBlock = {}
    local main = self.ast.main
    self:parseBlock(main)
    self:parseClasses(self.ast.nodesMap['catclass'])
    return self.results
end

---@private
---@param block LuaParser.Node.Block
function M:parseBlock(block)
    if self.parsedBlock[block] then
        return
    end
    self.parsedBlock[block] = true
    local isMain = block.isMain
    for _, child in ipairs(block.childs) do
        self:parseState(child, isMain)
    end
end

---@private
---@param classes LuaParser.Node.CatClass[]
function M:parseClasses(classes)
    if not classes then
        return
    end
    for _, class in ipairs(classes) do
        local block = class.parentBlock
        if block then
            self:parseBlock(block)
        end
    end
end

---@private
---@param state LuaParser.Node.State
---@param isMain boolean
function M:parseState(state, isMain)
    local lastClass
    if isMain and state.kind == 'assign' then
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
        local value = state.value
        if not value then
            goto continue
        end
        if value.kind == 'catclass' then
            ---@cast value LuaParser.Node.CatClass
            self:parseCatClass(value)
            lastClass = value
        elseif value.kind == 'catfield' then
            ---@cast value LuaParser.Node.CatField
            self:parseCatField(value, lastClass)
        end
        ::continue::
    end
end

---@param lnode LuaParser.Node.Base
---@return Node.Location
function M:makeLocation(lnode)
    return {
        uri = self.vfile.uri,
        offset = lnode.start,
        length = lnode.finish - lnode.start,
    }
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
        location = self:makeLocation(var),
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

---@private
---@param value LuaParser.Node.CatClass
function M:parseCatClass(value)
    self.results[#self.results+1] = {
        kind = 'class',
        name = value.classID.id,
        location = self:makeLocation(value)
    }
end

---@private
---@param value LuaParser.Node.CatField
---@param lastClass? LuaParser.Node.CatClass
function M:parseCatField(value, lastClass)
    if not lastClass then
        return
    end
    local className = lastClass.classID.id
    self.results[#self.results+1] = {
        kind = 'classfield',
        className = className,
        field = {
            key = self.scope.node.value(value.key.id),
            value = self:parseNode(value.value) or self.scope.node.UNKNOWN,
            location = self:makeLocation(value),
        }
    }
end

---@param value LuaParser.Node.CatType
function M:parseNode(value)
    
end

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
---@return VM.IndexProcess
function ls.vm.createIndexProcess(vfile, ast)
    return New 'VM.IndexProcess' (vfile, ast)
end
