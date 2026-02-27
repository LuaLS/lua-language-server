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

Presize(W, 3)

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

function W:setValue(id, value, isAssign)
    local stack = self:currentStack()
    stack.current[id] = value
    if isAssign then
        if not stack.changed then
            stack.changed = {}
        end
        stack.changed[id] = true
    end
end

---@param block table[]
---@param start? integer
function W:traceBlock(block, start)
    if not block then
        return
    end
    for i = start or 1, #block do
        local v = block[i]
        self:traceUnit(v)
    end
end

function W:traceVar(var)
    local id, alias = var[2], var[3]
    self.aliasID[alias] = id

    self:setValue(id, self.map[alias].value, true)
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
    local rt = self.scope.rt
    local lastStack
    local stacks = {}
    local changed = {}
    for i = 2, #ifNode do
        lastStack = self:traceIfChild(ifNode[i], lastStack)
        stacks[#stacks+1] = lastStack
        if lastStack.changed then
            ls.util.tableMerge(changed, lastStack.changed)
        end
    end

    for id in pairs(changed) do
        local union = {}
        for _, stack in ipairs(stacks) do
            local value = stack.current[id]
            union[#union+1] = value
        end
        local value = rt.union(union)
        self:setValue(id, value, true)
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

function W:traceUnit(unit)
    local tag = unit[1]
    if tag == 'var' then
        self:traceVar(unit)
        return
    end
    if tag == 'ref' then
        self:traceRef(unit)
        return
    end
    if tag == 'if' then
        self:traceIf(unit)
        return
    end
    if tag == 'condition' then
        self:traceCondition(unit)
        return
    end
end

function W:trace2Refs(exp)
    local a, b
    for i = 2, #exp do
        if exp[i] == 'v' then
            if not a then
                a = exp[i - 1]
            else
                b = exp[i - 1]
            end
        else
            self:traceUnit(exp[i])
        end
    end
    return a, b
end

function W:traceOne(exp, start)
    for i = start, #exp do
        if exp[i] == 'v' then
            return exp[i - 1], i + 1
        else
            self:traceUnit(exp[i])
        end
    end
    return nil
end

function W:traceCondition(condition, revert)
    local exp = condition[#condition]
    for i = 2, #condition - 1 do
        self:traceUnit(condition[i])
    end
    self:traceConditionUnit(exp, revert)
end

function W:traceConditionUnit(exp, revert)
    local kind = exp[1]
    if kind == 'ref' then
        self:traceTruly(exp, revert)
    elseif kind == 'call' then
        self:traceCallTruly(exp, revert)
    elseif kind == '==' then
        local left, right = self:trace2Refs(exp)
        self:traceEqual(left, right, revert)
        self:traceEqual(right, left, revert)
        self:traceCallEqual(left, right, revert)
        self:traceCallEqual(right, left, revert)
    elseif kind == '~=' then
        local left, right = self:trace2Refs(exp)
        self:traceEqual(left, right, not revert)
        self:traceEqual(right, left, not revert)
        self:traceCallEqual(left, right, not revert)
        self:traceCallEqual(right, left, not revert)
    elseif kind == 'not' then
        self:traceCondition(exp, not revert)
    elseif kind == 'and' then
        self:traceAnd(exp, revert)
    elseif kind == 'or' then
        self:traceOr(exp, revert)
    end
end

function W:traceAnd(exp, revert)
    local stack1 = self:pushStack()
    local left, nextIndex = self:traceOne(exp, 2)
    self:traceConditionUnit(left, revert)

    local stack2 = self:pushStack()
    local right = self:traceOne(exp, nextIndex)
    self:traceConditionUnit(right, revert)
    self:popStack()
    self:popStack()

    local currentStack = self:currentStack()

    ls.util.tableMerge(currentStack.current, stack1.current)
    ls.util.tableMerge(currentStack.current, stack2.current)

    for k in pairs(stack2.otherSide) do
        if stack1.otherSide[k] then
            currentStack.otherSide[k] = stack2.otherSide[k] | stack1.otherSide[k]
        end
    end
end

function W:traceOr(exp, revert)
    -- stack1 和 stack2 从同一基础出发独立收窄（平行而非嵌套）
    local stack1 = self:pushStack()
    local left, nextIndex = self:traceOne(exp, 2)
    self:traceConditionUnit(left, revert)
    self:popStack()

    local stack2 = self:pushStack()
    local right = self:traceOne(exp, nextIndex)
    self:traceConditionUnit(right, revert)
    self:popStack()

    local currentStack = self:currentStack()

    -- true 分支：左侧或右侧任一为真
    -- 若某变量两侧都有收窄结果，取并集；
    -- 若只有一侧有，说明另一侧对此变量无约束，无法收窄，不写入（保持原始值）
    for k in pairs(stack1.current) do
        if stack2.current[k] then
            currentStack.current[k] = stack1.current[k] | stack2.current[k]
        end
    end

    -- false 分支：左侧且右侧都为假，两侧 otherSide 依次应用（交叠）
    ls.util.tableMerge(currentStack.otherSide, stack1.otherSide)
    ls.util.tableMerge(currentStack.otherSide, stack2.otherSide)
end

function W:traceTruly(exp, revert)
    if exp[1] ~= 'ref' then
        return
    end

    self:traceByValue(exp, self.scope.rt.TRULY, revert)
end

function W:traceEqual(left, right, revert)
    if not left or left[1] ~= 'ref' then
        return
    end
    if not right then
        return
    end
    local rvalue
    if right[1] == 'ref' then
        rvalue = self:traceRef(right)
    else
        rvalue = self:traceValue(right)
    end
    if not rvalue then
        return
    end

    self:traceByValue(left, rvalue, revert)
end

function W:traceByValue(var, value, revert)
    local vvalue = self:traceRef(var)
    if not vvalue then
        return
    end

    local id = var[2]
    local narrowed, otherSide = vvalue:narrowEqual(value)
    if revert then
        self:setNarrowResult(id, otherSide, narrowed)
    else
        self:setNarrowResult(id, narrowed, otherSide)
    end

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
            if revert then
                self:setNarrowResult(id, otherSide, narrowed)
            else
                self:setNarrowResult(id, narrowed, otherSide)
            end
        end
    end
end

---通过函数调用返回值（truthy检测）收窄参数类型
---call entry: {'call', callAlias, funcAlias, {arg1Alias, ...}}
function W:traceCallTruly(exp, revert)
    if exp[1] ~= 'call' then
        return
    end
    local rt = self.scope.rt
    local funcAlias = exp[3]
    local argAliases = exp[4]
    local ok, funcVar = pcall(function() return self.map[funcAlias] end)
    if not ok or not funcVar then
        return
    end
    local func = funcVar.value
    if not func then
        return
    end
    for i, argAlias in ipairs(argAliases) do
        -- 找到对应的 ref（通过 aliasID 找 id，再通过 id 找 ref entry）
        local id = self.aliasID[argAlias]
        if not id then
            goto continue
        end
        local argValue = self:getValue(id)
        if not argValue then
            goto continue
        end
        local narrowed, otherSide = rt.narrow(argValue):asCall {
            func        = func,
            myType      = 'param',
            myIndex     = i,
            mode        = 'match',
            targetType  = 'return',
            targetIndex = 1,
            targetValue = rt.TRULY,
        }:narrowCall()
        if revert then
            self:setNarrowResult(id, otherSide, narrowed)
        else
            self:setNarrowResult(id, narrowed, otherSide)
        end
        -- 向上传播到父变量
        local pid = id
        while true do
            local pdata = self.parentMap[pid]
            if not pdata then
                break
            end
            pid = pdata[1]
            local pvalue = self:getValue(pid)
            if pvalue then
                local key = pdata[2]
                local pnarrowed, potherSide = pvalue:narrowByField(key, revert and otherSide or narrowed)
                if revert then
                    self:setNarrowResult(pid, potherSide, pnarrowed)
                else
                    self:setNarrowResult(pid, pnarrowed, potherSide)
                end
            end
        end
        ::continue::
    end
end

---通过函数调用返回值（equal检测）收窄参数类型
---call entry: {'call', callAlias, funcAlias, {arg1Alias, ...}}
function W:traceCallEqual(callExp, valueExp, revert)
    if not callExp or callExp[1] ~= 'call' then
        return
    end
    if not valueExp then
        return
    end
    local rvalue
    if valueExp[1] == 'ref' then
        rvalue = self:traceRef(valueExp)
    else
        rvalue = self:traceValue(valueExp)
    end
    if not rvalue then
        return
    end
    local rt = self.scope.rt
    local funcAlias = callExp[3]
    local argAliases = callExp[4]
    local ok2, funcVar = pcall(function() return self.map[funcAlias] end)
    if not ok2 or not funcVar then
        return
    end
    local func = funcVar.value
    if not func then
        return
    end
    for i, argAlias in ipairs(argAliases) do
        local id = self.aliasID[argAlias]
        if not id then
            goto continue
        end
        local argValue = self:getValue(id)
        if not argValue then
            goto continue
        end
        local narrowed, otherSide = rt.narrow(argValue):asCall {
            func        = func,
            myType      = 'param',
            myIndex     = i,
            mode        = 'equal',
            targetType  = 'return',
            targetIndex = 1,
            targetValue = rvalue,
        }:narrowCall()
        if revert then
            self:setNarrowResult(id, otherSide, narrowed)
        else
            self:setNarrowResult(id, narrowed, otherSide)
        end
        -- 向上传播到父变量
        local pid = id
        while true do
            local pdata = self.parentMap[pid]
            if not pdata then
                break
            end
            pid = pdata[1]
            local pvalue = self:getValue(pid)
            if pvalue then
                local key = pdata[2]
                local pnarrowed, potherSide = pvalue:narrowByField(key, revert and otherSide or narrowed)
                if revert then
                    self:setNarrowResult(pid, potherSide, pnarrowed)
                else
                    self:setNarrowResult(pid, pnarrowed, potherSide)
                end
            end
        end
        ::continue::
    end
end

function W:setNarrowResult(id, result, otherSide)
    local stack = self:currentStack()
    stack.current[id] = result
    stack.otherSide[id] = otherSide
end

---@class Node.Tracer.Stack
local S = Class 'Node.Tracer.Stack'

Presize(S, 3)

---@type table<string, true>?
S.changed = nil

---@param parent? Node.Tracer.Stack
function S:__init(parent)
    self.parent = parent
    self.current = {}
    self.otherSide = {}
end
