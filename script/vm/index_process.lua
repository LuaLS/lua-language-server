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
    ---@type table<LuaParser.Node.CatGeneric, Node.Generic>
    self.generics = {}
    local main = self.ast.main
    self:parseBlock(main)
    self:parseClasses(self.ast.nodesMap['catclass'])
    self:parseAliases(self.ast.nodesMap['catalias'])
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
    local cache = {}
    for _, child in ipairs(block.childs) do
        self:parseState(child, isMain, cache)
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
---@param aliases LuaParser.Node.CatAlias[]
function M:parseAliases(aliases)
    if not aliases then
        return
    end
    for _, alias in ipairs(aliases) do
        self.results[#self.results+1] = {
            kind = 'alias',
            name = alias.aliasID.id,
            value = self:parseNode(alias.extends),
            location = self:makeLocation(alias),
        }
    end
end

---@private
---@param state LuaParser.Node.State
---@param isMain boolean
---@param cache table
function M:parseState(state, isMain, cache)
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
            cache.lastClass = value
        elseif value.kind == 'catfield' then
            ---@cast value LuaParser.Node.CatField
            self:parseCatField(value, cache.lastClass)
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
            value = self:parseNode(value.value),
            location = self:makeLocation(value),
        }
    }
end

---@param value? LuaParser.Node.CatType
---@return Node
function M:parseNode(value)
    local node = self.scope.node
    if not value then
        return node.ANY
    end
    local kind = value.kind
    if kind == 'catid' then
        ---@cast value LuaParser.Node.CatID
        return node.type(value.id)
    end
    if kind == 'catinteger' then
        ---@cast value LuaParser.Node.CatInteger
        return node.value(value.value)
    end
    if kind == 'catboolean' then
        ---@cast value LuaParser.Node.CatBoolean
        return node.value(value.value)
    end
    if kind == 'catstring' then
        ---@cast value LuaParser.Node.CatString
        return node.value(value.value)
    end
    if kind == 'catunion' then
        ---@cast value LuaParser.Node.CatUnion
        return node.union(ls.util.map(value.exps, function (v, k)
            return self:parseNode(v)
        end))
    end
    if kind == 'catintersection' then
        ---@cast value LuaParser.Node.CatIntersection
        return node.intersection(ls.util.map(value.exps, function (v, k)
            return self:parseNode(v)
        end))
    end
    if kind == 'cattable' then
        ---@cast value LuaParser.Node.CatTable
        local t = node.table()
        for _, field in ipairs(value.fields) do
            if field.subtype == 'field' then
                t:addField {
                    key      = node.value(field.key.id),
                    value    = self:parseNode(field.value),
                    location = self:makeLocation(field),
                }
            else
                t:addField {
                    key      = self:parseNode(field.key --[[@as LuaParser.Node.CatType]]),
                    value    = self:parseNode(field.value),
                    location = self:makeLocation(field),
                }
            end
        end
        return t
    end
    if kind == 'cattuple' then
        ---@cast value LuaParser.Node.CatTuple
        return node.tuple(ls.util.map(value.exps, function (v, k)
            return self:parseNode(v)
        end))
    end
    if kind == 'catarray' then
        ---@cast value LuaParser.Node.CatArray
        return node.array(self:parseNode(value.node), value.size and value.size.value)
    end
    if kind == 'catcall' then
        ---@cast value LuaParser.Node.CatCall
        return node.type(value.node.id):call(ls.util.map(value.args, function (v, k)
            return self:parseNode(v)
        end))
    end
    if kind == 'catfunction' then
        ---@cast value LuaParser.Node.CatFunction
        local func = node.func()
        if value.async then
            func:setAsync()
        end
        if value.generics then
            func:bindGenerics(ls.util.map(value.generics, function (g, k)
                return self:makeGeneric(g)
            end))
        end
        if value.params then
            for _, param in ipairs(value.params) do
                local name = param.name
                if name == '...' then
                    func:addVarargParam(self:parseNode(param.value))
                else
                    func:addParam(name.id, self:parseNode(param.value))
                end
            end
        end
        if value.returns then
            for _, ret in ipairs(value.returns) do
                local name = ret.name and ret.name.id
                if name == '...' then
                    func:addVarargReturn(self:parseNode(ret.value))
                else
                    func:addReturn(name, self:parseNode(ret.value))
                end
            end
        end
        return func
    end
    return node.ANY
end

---@param generic LuaParser.Node.CatGeneric
---@return Node.Generic
function M:makeGeneric(generic)
    if self.generics[generic] then
        return self.generics[generic]
    end
    local gnode = self.scope.node.generic(generic.id.id, generic.extends and self:parseNode(generic.extends))

    self.generics[generic] = gnode

    return gnode
end

---@param vfile VM.Vfile
---@param ast LuaParser.Ast
---@return VM.IndexProcess
function ls.vm.createIndexProcess(vfile, ast)
    return New 'VM.IndexProcess' (vfile, ast)
end
