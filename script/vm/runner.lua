---@class VM.Runner
local M = Class 'VM.Runner'

---@type 'ready' | 'indexing' | 'indexed' | 'running' | 'runned'
M.state = 'ready'

---@class VM.Runner.Context
---@field lastClass? Node.Type
---@field generics? table<LuaParser.Node.CatGeneric, Node.Generic>
---@field catGroup? LuaParser.Node.Cat[]
---@field catGroupMap? table<LuaParser.Node.Cat, LuaParser.Node.Cat[]>

---@param block LuaParser.Node.Block
---@param vfile VM.Vfile
function M:__init(block, vfile)
    self.block = block
    self.vfile = vfile
    self.vm = vfile.scope.vm
    self.node  = vfile.scope.node
    ---@type table<LuaParser.Node.Base, Node?>
    self.nodeMap = {}
    ---@type table<LuaParser.Node.Base, Node.Variable|false>
    self.variableMap = {}
    ---@type VM.Runner.Context
    self.context = {}
    ---@type function[]
    self.disposes = {}
    self.resolve = function (unsolve, source)
        self.nodeMap[source] = nil
        local node = self:parse(source)
        self.nodeMap[source] = node
        return node
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

function M:index()
    if self.state ~= 'ready' then
        return
    end
    self.state = 'indexing'
    self:parse(self.block)
    for _, state in ipairs(self.block.childs) do
        if state.isBlock then
            ---@diagnostic disable-next-line: cast-type-mismatch
            ---@cast state LuaParser.Node.Block
            self:getSubRunner(state):index()
        else
            self:parse(state)
        end
    end
    self.state = 'indexed'
end

function M:run()
    if self.state ~= 'indexed' then
        return
    end
    self.state = 'running'
    self.state = 'runned'
end

---@param source LuaParser.Node.Base
---@return Node
function M:parse(source)
    local node = self.nodeMap[source]
    if node then
        return node
    end
    if source.isLiteral then
        ---@cast source LuaParser.Node.Literal
        return self.node.value(source.value)
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
---@param default? Node
---@return Node
function M:lazyParse(source, default)
    local node = self.nodeMap[source]
    if node then
        return node
    end
    if source.isLiteral then
        ---@cast source LuaParser.Node.Literal
        return self.node.value(source.value)
    end
    local unsolve = self.node.unsolve(default or self.node.UNKNOWN, source, self.resolve)
    self.nodeMap[source] = unsolve
    return unsolve
end

---@param source LuaParser.Node.Base
---@param node Node
function M:setNode(source, node)
    self.nodeMap[source] = node
end

---@param source LuaParser.Node.Base
---@return Node.Location
function M:makeLocation(source)
    return {
        uri = self.vfile.uri,
        offset = source.start,
        length = source.finish - source.start,
    }
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
        path[#path+1] = self.vm:getKey(current)
        if current.kind == 'var' then
            break
        end
        current = current.last
    end

    ls.util.revertArray(path)

    return path
end

---@param field LuaParser.Node.Field
---@return LuaParser.Node.Var?
function M:getFirstVar(field)
    local current = field.last
    for _ = 1, 1000 do
        if not current then
            return nil
        end
        if current.kind == 'var' then
            ---@cast current LuaParser.Node.Var
            return current
        end
        current = current.last
    end
end

---@param source LuaParser.Node.Base
---@param key Node.Key
---@param value? LuaParser.Node.Exp
---@return Node.Field
function M:makeNodeField(source, key, value)
    local node = self.node
    ---@type Node
    local nkey
    if type(key) ~= 'table' then
        ---@cast key -Node
        nkey = node.value(key)
    else
        ---@cast key Node
        nkey = key
    end
    local nvalue, var
    if value ~= nil then
        nvalue = self:lazyParse(value)
        var = self:getVariable(value)
    end
    local field = {
        key = nkey,
        value = nvalue,
        valueVar = var,
        location = self:makeLocation(source),
    }
    return field
end

---@param generic LuaParser.Node.CatGeneric
---@return Node.Generic
function M:makeGeneric(generic)
    local generics = self.context.generics
    if not generics then
        generics = {}
        self.context.generics = generics
    end
    if generics[generic] then
        return generics[generic]
    end
    local gnode = self.node.generic(generic.id.id, generic.extends and self:parse(generic.extends))

    generics[generic] = gnode

    return gnode
end

function M:clearCatGroup()
    local context = self.context
    context.catGroup = nil
end

---@param group LuaParser.Node.Cat[]
---@param cat LuaParser.Node.Cat
---@return boolean
local function isNearby(group, cat)
    local last = group[#group]
    if not last then
        return true
    end
    return (last.finishRow + 1) == cat.startRow
end

---@param cat LuaParser.Node.Cat
---@param nearby? boolean
function M:addToCatGroup(cat, nearby)
    local context = self.context
    local group = context.catGroup

    if not group
    or (nearby and not isNearby(group, cat)) then
        group = {}
        context.catGroup = group
    end
    group[#group+1] = cat

    local map = context.catGroupMap
    if not map then
        map = {}
        context.catGroupMap = map
    end
    map[cat] = group
end

---@param nearbySource? LuaParser.Node.Base
---@return LuaParser.Node.Cat[]?
function M:getCatGroup(nearbySource)
    local group = self.context.catGroup
    if not group then
        return nil
    end
    local first = group[1]
    if not first then
        return nil
    end
    if nearbySource then
        local sourceLine = nearbySource.startRow
        local catLine = group[#group].finishRow
        if (sourceLine - 1) ~= catLine then
            return nil
        end
    end
    return group
end

---@param source LuaParser.Node.Base
---@param variable Node.Variable
function M:setVariable(source, variable)
    self.variableMap[source] = variable
end

---@param source LuaParser.Node.Base
---@return Node.Variable?
function M:getVariable(source)
    if self.variableMap[source] then
        return self.variableMap[source] or nil
    end
    self.variableMap[source] = false
    local parser = M.variableParsers[source.kind]
    if not parser then
        return nil
    end
    local variable = parser(self, source)
    self.variableMap[source] = variable or false
    return variable
end

---@param block LuaParser.Node.Block
---@return VM.Runner
function M:getSubRunner(block)
    local runner = self.vfile:getRunner(block, self.context)
    return runner
end

---@param block LuaParser.Node.Block
---@return VM.Runner
function M:indexSubRunner(block)
    local runner = self:getSubRunner(block)
    runner:index()
    return runner
end

---@param source LuaParser.Node.Base
---@param key Node.Key
---@return Node.Field[]
function M:findFields(source, key)
    -- TODO 添加缓存
    local found = {}

    ---@param variable Node.Variable
    ---@param results Node.Field[]
    ---@param ... Node.Key
    local function findByVar(variable, results, ...)
        if found[variable] then
            return
        end
        found[variable] = true
        local child = variable:getChild(...)
        if child.assigns and not found[child] then
            found[child] = true
            ---@param assign Node.Field
            for assign in child.assigns:pairsFast() do
                results[#results+1] = assign
            end
        end

        if variable.assigns then
            ---@param assign Node.Field
            for assign in variable.assigns:pairsFast() do
                local var = assign.valueVar
                if var then
                    findByVar(var, results, ...)
                end
            end
        end

        local parent = variable.parent
        if parent then
            findByVar(parent, results, variable.key, ...)
        end
    end

    ---@param src LuaParser.Node.Base
    ---@param results Node.Field[]
    ---@param ... Node.Key
    local function find(src, results, ...)
        if found[src] then
            return
        end
        found[src] = true
        local variable = self:getVariable(src)
        if variable then
            findByVar(variable, results, ...)
        end
    end

    ---@type Node.Field[]
    local results = {}
    find(source, results, key)

    return results
end

---@param context VM.Runner.Context
function M:setContext(context)
    self.context = context
end

---@alias VM.RunnerParser fun(runner: VM.Runner, source: LuaParser.Node.Base): Node?
---@alias VM.VariableParser fun(runner: VM.Runner, source: LuaParser.Node.Base): Node.Variable?

---@private
---@type table<string, VM.RunnerParser>
M.parsers = {}

---@private
---@type table<string, VM.VariableParser>
M.variableParsers = {}

---@param kind string
---@param parser VM.RunnerParser
function ls.vm.registerRunnerParser(kind, parser)
    M.parsers[kind] = parser
end

---@param kind string
---@param parser VM.VariableParser
function ls.vm.registerVariableParser(kind, parser)
    M.variableParsers[kind] = parser
end


---@param block LuaParser.Node.Block
---@param vfile VM.Vfile
---@return VM.Runner
function ls.vm.createRunner(block, vfile)
    return New 'VM.Runner' (block, vfile)
end
