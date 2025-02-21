---@class VM.Runner
local M = Class 'VM.Runner'

---@type 'ready' | 'running' | 'finished'
M.state = 'ready'

---@class VM.Runner.Context
---@field lastClass? Node.Type

---@param block LuaParser.Node.Block
---@param scope Scope
function M:__init(block, scope)
    self.block = block
    self.scope = scope
    self.node  = scope.node
    ---@type table<LuaParser.Node.Base, Node?>
    self.nodeMap = {}
    ---@type VM.Runner.Context
    self.context = {}
    ---@type function[]
    self.disposes = {}
    self.resolve = function (unsolve, source)
        return self:parse(source)
    end
end

function M:__del()
    for _, dispose in ipairs(self.disposes) do
        dispose()
    end
end

---@param dispose function
function M:addDispose(dispose)
    self.disposes[#self.disposes+1] = dispose
end

function M:run()
    if self.state ~= 'ready' then
        return
    end
    self.state = 'running'
    for _, state in ipairs(self.block.childs) do
        self:parse(state)
    end
    self.state = 'finished'
end

---@param source LuaParser.Node.Base
---@return Node
function M:parse(source)
    local node = self.nodeMap[source]
    if node then
        return node
    end
    self.nodeMap[source] = self.node.UNKNOWN
    local parser = M.parsers[source.kind]
    if not parser then
        return self.node.UNKNOWN
    end
    node = parser(self, source)
    if not node then
        return self.node.UNKNOWN
    end
    self.nodeMap[source] = node
    return node
end

---@param source LuaParser.Node.Base
---@return Node.Location
function M:makeLocation(source)
    return {
        uri = self.scope.uri,
        offset = source.start,
        length = source.finish - source.start,
    }
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

---@param field LuaParser.Node.Field
---@return Node.Key[]
---@return LuaParser.Node.Var?
function M:makeFullPath(field)
    local path = {}
    local var

    local current = field.last
    for _ = 1, 1000 do
        if not current then
            break
        end
        path[#path+1] = self:getKey(current)
        if current.kind == 'var' then
            var = current
            break
        end
        current = current.last
    end

    ls.util.revertArray(path)

    return path, var
end

---@param var LuaParser.Node.Base
---@param key Node.Key
---@param value? LuaParser.Node.Exp
---@param useType? boolean
---@return Node.Field
function M:makeNodeField(var, key, value, useType)
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
        if useType then
            nvalue = node.type(nvalue.typeName)
        end
    else
        nvalue = node.unsolve(node.UNKNOWN, value, self.resolve)
    end
    local field = {
        key = nkey,
        value = nvalue,
        location = self:makeLocation(var),
    }
    return field
end

---@alias VM.RunnerParser fun(runner: VM.Runner, source: LuaParser.Node.Base): Node?

---@private
---@type table<string, VM.RunnerParser>
M.parsers = {}

---@param kind string
---@param parser VM.RunnerParser
function ls.vm.registerRunnerParser(kind, parser)
    M.parsers[kind] = parser
end

---@param block LuaParser.Node.Block
---@param scope Scope
---@return VM.Runner
function ls.vm.createRunner(block, scope)
    return New 'VM.Runner' (block, scope)
end
