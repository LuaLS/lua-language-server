---@class Node.Tracer: Node
local M = ls.node.register 'Node.Tracer'

M.kind = 'tracer'

---@param scope Scope
---@param map table<string, Node>
---@param parentMap table<string, [string, string]>
function M:__init(scope, map, parentMap)
    self.scope = scope
    self.map = map
    self.parentMap = parentMap
end

---@param self Node.Tracer
---@return Node
---@return true
M.__getter.value = function (self)
    return self.scope.rt.NEVER, true
end

---@param flow table
function M:setFlow(flow)
    self.flow = flow
end

---@type Node.Tracer.Walker?
M.walker = nil

M.__getter.walker = function (self)
    return New 'Node.Tracer.Walker' (self.scope, self.map, self.parentMap), true
end

function M:trace()
    self.walker:start(self.flow)
end

---@class Node.Tracer.Walker
local W = Class 'Node.Tracer.Walker'

---@param scope Scope
---@param map table<string, Node.Variable>
---@param parentMap table<string, [string, string]>
function W:__init(scope, map, parentMap)
    self.scope = scope
    self.map   = map
    self.parentMap = parentMap
end

function W:start(block)
    if self.started then
        return
    end
    self.started = true
    self.aliasID = {}
    ---@type Node.Tracer.Stack[]
    self.stacks  = {}
    self:pushStack()
    self:traceBlock(block)
end

function W:pushStack()
    local stack = New 'Node.Tracer.Stack' (self:currentStack())
    self.stacks[#self.stacks+1] = stack
    return stack
end

function W:popStack()
    self.stacks[#self.stacks] = nil
end

function W:currentStack()
    return self.stacks[#self.stacks]
end

---@param id string
---@return Node?
function W:getValue(id)
    for i = #self.stacks, 1, -1 do
        local stack = self.stacks[i]
        local value = stack.current[id]
        if value then
            return value
        end
    end
    return nil
end

function W:setValue(id, value)
    local stack = self:currentStack()
    stack.current[id] = value
end

---@param block table[]
---@param start? integer
function W:traceBlock(block, start)
    for i = start or 1, #block do
        local v = block[i]
        local tag = v[1]
        if tag == 'var' then
            self:traceVar(v)
            goto continue
        end
        if tag == 'ref' then
            self:traceRef(v)
            goto continue
        end
        if tag == 'if' then
            self:traceIf(v)
            goto continue
        end
        if tag == 'condition' then
            self:traceCondition(v)
            goto continue
        end
        ::continue::
    end
end

function W:traceVar(var)
    local id, alias = var[2], var[3]
    self.aliasID[alias] = id

    self:setValue(id, self.map[alias].value)
end

---@param ref ['ref', string, string]
---@return Node?
function W:traceRef(ref)
    local id, alias = ref[2], ref[3]
    self.aliasID[alias] = id
    local value = self:getValue(id)
    if not value then
        value = self.map[alias].value
        self:setValue(id, value)
    end
    self.map[alias]:setCurrentValue(value)
    return value
end

---@param data ['value', string]
---@return Node?
function W:traceValue(data)
    local id = data[2]
    return self.map[id]
end

function W:traceIf(ifNode)
    local lastStack
    for i = 2, #ifNode do
        lastStack = self:traceIfChild(ifNode[i], lastStack)
    end
end

---@param block table
---@param lastStack? Node.Tracer.Stack
---@return Node.Tracer.Stack
function W:traceIfChild(block, lastStack)
    local stack = self:pushStack()
    if lastStack then
        stack.current = lastStack.otherSide
    end
    self:traceBlock(block)
    self:popStack()
    return stack
end

function W:traceCondition(condition)
    local exp = condition[2]
    local kind = exp[1]
    if kind == 'ref' then
        self:traceTruly(exp)
    elseif kind == 'equal' then
        self:traceEqual(exp[2], exp[3])
        self:traceEqual(exp[3], exp[2])
    end
end

function W:traceTruly(exp)
    if exp[1] ~= 'ref' then
        return
    end

    self:traceByValue(exp, self.scope.rt.TRULY)
end

function W:traceEqual(left, right)
    if left[1] ~= 'ref' then
        return
    end
    local rvalue = self:traceValue(right)
    if not rvalue then
        return
    end

    self:traceByValue(left, rvalue)
end

function W:traceByValue(var, value)
    local vvalue = self:traceRef(var)
    if not vvalue then
        return
    end

    local id = var[2]
    local narrowed, otherSide = vvalue:narrowEqual(value)
    self:setNarrowResult(id, narrowed, otherSide)

    while true do
        local pdata = self.parentMap[id]
        if not pdata then
            break
        end
        id = pdata[1]
        local pvalue = self:getValue(id)
        if pvalue then
            local key = pdata[2]
            narrowed, otherSide = pvalue:narrowByField(key, narrowed)
            self:setNarrowResult(id, narrowed, otherSide)
        end
    end
end

function W:setNarrowResult(id, result, otherSide)
    local stack = self:currentStack()
    stack.current[id] = result
    stack.otherSide[id] = otherSide
end

---@class Node.Tracer.Stack
local S = Class 'Node.Tracer.Stack'

---@param parent? Node.Tracer.Stack
function S:__init(parent)
    self.parent = parent
    self.current = {}
    self.otherSide = {}
end
