---@class VM
local M = Class 'VM'

---@param scope Scope
function M:__init(scope)
    self.scope  = scope
    self.node   = scope.rt
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

---@async
---@param uri Uri
---@return VM.Vfile
function M:awaitIndexFile(uri)
    local file = self:getFile(uri)
              or self:createFile(uri)
    file:awaitIndex()
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

---@param source LuaParser.Node.Base
---@return VM.Coder?
function M:getCoder(source)
    local uri = source.ast.source
    local vfile = self:getFile(uri)
    if not vfile then
        return nil
    end
    return vfile.coder
end

---@param field LuaParser.Node.Term
---@return Node.Key
function M:getKey(field)
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
                return key.value or self.node.UNKNOWN
            end
            return self.node.UNKNOWN
        end
    elseif field.kind == 'var' then
        ---@cast field LuaParser.Node.Var
        return field.id
    else
        return self.node.UNKNOWN
    end
end

---@param field LuaParser.Node.Field
---@return Node.Key[]
function M:getFullPath(field)
    local path = {}

    local current = field.last
    for _ = 1, 1000 do
        if not current then
            break
        end
        path[#path+1] = self:getKey(current)
        if current.kind == 'var' then
            break
        end
        current = current.last
    end

    ls.util.revertArray(path)

    return path
end

---@param scope Scope
---@return VM
function ls.vm.create(scope)
    return New 'VM' (scope)
end

return M
