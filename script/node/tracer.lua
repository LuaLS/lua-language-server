---@class Node.Tracer: Node
local M = ls.node.register 'Node.Tracer'

M.kind = 'tracer'

---@param scope Scope
---@param map table<string, Node>
function M:__init(scope, map)
    self.scope = scope
    self.map = map
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
    return New 'Node.Tracer.Walker' (self.scope, self.map), true
end

function M:trace()
    self.walker:start(self.flow)
end

---@class Node.Tracer.Walker
local W = Class 'Node.Tracer.Walker'

---@param scope Scope
---@param map table<string, Node.Variable>
function W:__init(scope, map)
    self.scope = scope
    self.map   = map
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

function W:getValue(id)
    for i = #self.stacks, 1, -1 do
        local stack = self.stacks[i]
        local value = stack.current[id]
        if value then
            return value
        end
    end
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
---@return Node
function W:traceRef(ref)
    local id, alias = ref[2], ref[3]
    self.aliasID[alias] = id
    local value = self:getValue(id)
    self.map[alias]:setCurrentValue(value)
    return value
end

---@param data ['value', string]
---@return Node
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
    local condition = block[1]
    if condition[1] == 'condition' then
        self:traceCondition(condition[2])
        self:traceBlock(block, 2)
    else
        self:traceBlock(block)
    end
    self:popStack()
    return stack
end

function W:traceCondition(condition)
    local kind = condition[1]
    if kind == 'ref' then
        self:traceTruly(condition)
    elseif kind == 'equal' then
        self:traceEqual(condition[2], condition[3])
        self:traceEqual(condition[3], condition[2])
    end
end

function W:traceTruly(exp)
    if exp[1] == 'ref' then
        local value = self:traceRef(exp)
        self:setNarrowResult(exp[2], value.truly, value.falsy)
    end
end

function W:traceEqual(left, right)
    if left[1] ~= 'ref' then
        return
    end
    local var = self:traceRef(left)
    local value = self.map[right[2]]
    self:setNarrowResult(left[2], var:narrowEqual(value))
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
