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
    local node = self.map[alias]
    -- 用 getCurrentValue()（不触发 tracer）而非 .value（会触发新 Walker 递归）。
    -- 赋值点 shadow 的 currentValue 即是 Coder 编译时已设置好的赋值表达式值。
    local value = node:getStaticValue()
    self:setValue(id, value, true)
end

---@param ref ['ref', string, string]
---@return Node?
function W:traceRef(ref)
    local id, alias = ref[2], ref[3]
    self.aliasID[alias] = id
    -- 建立 id -> aliases 的反向映射，供 link 查找 funcVar 使用
    if not self.idAliasMap then
        self.idAliasMap = {}
    end
    if not self.idAliasMap[id] then
        self.idAliasMap[id] = {}
    end
    self.idAliasMap[id][alias] = true

    local value = self:getValue(id)
    if not value then
        local node = self.map[alias]
        -- 若节点有 tracer（其 .value 会启动新 Walker，引发递归），
        -- 则用 getCurrentValue/getExpectValue/getGuessValue 作为初始值；
        -- 普通节点（无 tracer）直接用 .value。
        if node.tracer then
            value = node:getStaticValue()
        else
            value = node.value or self.scope.rt.ANY
        end
        self:setValue(id, value)
    end
    self.map[alias]:setCurrentValue(value)
    return value
end

---@param data ['value', string]
---@return Node?
function W:traceValue(data)
    if data[1] ~= 'value' then
        return nil
    end
    local id = data[2]
    return self.map[id]
end

function W:traceIf(ifNode)
    local rt = self.scope.rt
    local lastStack
    local stacks = {}
    local changed = {}
    -- ifNode: {'if', ifchild1, ifchild2, ...}
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

--- 处理单个 if 分支数组：{conditionNode?, ...block_entries}
--- conditionNode 为 {'condition', condExp}，可选（else 分支没有）
--- ifchild[1] 可以是 condition 节点，或者 false/nil（匿名分支）
---@param ifchild table
---@param lastStack? Node.Tracer.Stack
---@return Node.Tracer.Stack
function W:traceIfChild(ifchild, lastStack)
    local stack = self:pushStack()
    if lastStack then
        stack.current = lastStack.otherSide
    end

    -- ifchild 是一个数组，第一个元素若为 condition 节点则处理条件
    local bodyStart = 1
    local first = ifchild[1]
    if type(first) == 'table' and first[1] == 'condition' then
        self:traceCondition(first)
        bodyStart = 2
    end
    self:traceBlock(ifchild, bodyStart)

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
    if tag == 'link' then
        self:traceLink(unit)
        return
    end
end

--- 通过逻辑变量名 funcVarId 在 idAliasMap 中找到对应的 Node.Variable
---@param funcVarId string 逻辑变量名（如 'type', 'f'）
---@return Node.Variable?
function W:getFuncVar(funcVarId)
    if not funcVarId then return nil end
    local aliases = self.idAliasMap and self.idAliasMap[funcVarId]
    if not aliases then return nil end
    for alias in pairs(aliases) do
        local v = self.map[alias]
        if v then return v end
    end
    return nil
end

--- 记录变量 id 与函数调用的关联，供间接窄化使用
--- link entry: {'link', varId, callAlias, funcVarId, argAliases, returnIndex}
function W:traceLink(link)
    if not self.varLinkMap then
        self.varLinkMap = {}
    end
    if not self.callLinkMap then
        self.callLinkMap = {}
    end
    local varId      = link[2]
    local callAlias  = link[3]
    local returnIndex = link[6] or 1
    self.varLinkMap[varId] = link
    -- callLinkMap: callAlias -> list of {varId, returnIndex}
    if not self.callLinkMap[callAlias] then
        self.callLinkMap[callAlias] = {}
    end
    local list = self.callLinkMap[callAlias]
    list[#list+1] = { varId = varId, returnIndex = returnIndex }
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

--- 处理 condition 节点：{'condition', [副作用ref...], condExp}
--- 最后一个子节点是 condExp（树形 exp 节点），
--- 前面的子节点是副作用 ref（用于建立 aliasID，供 parentMap 链追踪）
function W:traceCondition(condition, revert)
    -- condition[1] == 'condition'
    -- condition[2..n-1] 是副作用 ref，condition[n] 是 condExp
    local n = #condition
    for i = 2, n - 1 do
        self:traceUnit(condition[i])
    end
    local exp = condition[n]
    if exp then
        self:traceConditionUnit(exp, revert)
    end
end

function W:traceConditionUnit(exp, revert)
    local kind = exp[1]
    if kind == 'ref' then
        self:traceTruly(exp, revert)
    elseif kind == 'call' then
        self:traceCallTruly(exp, revert)
    elseif kind == '==' then
        -- 结构：{'==', [副作用ref...], left, right}
        -- 最后两个子节点是左右操作数，前面的是副作用 ref
        local n     = #exp
        local left  = exp[n - 1]
        local right = exp[n]
        -- 先处理副作用 ref
        for i = 2, n - 2 do
            self:traceUnit(exp[i])
        end
        self:traceEqual(left, right, revert)
        self:traceEqual(right, left, revert)
        self:traceCallEqual(left, right, revert)
        self:traceCallEqual(right, left, revert)
    elseif kind == '~=' then
        local n     = #exp
        local left  = exp[n - 1]
        local right = exp[n]
        for i = 2, n - 2 do
            self:traceUnit(exp[i])
        end
        self:traceEqual(left, right, not revert)
        self:traceEqual(right, left, not revert)
        self:traceCallEqual(left, right, not revert)
        self:traceCallEqual(right, left, not revert)
    elseif kind == 'not' then
        -- 树形：exp[2] 是被取反的子表达式
        local inner = exp[2]
        if inner then
            self:traceConditionUnit(inner, not revert)
        end
    elseif kind == 'and' then
        self:traceAnd(exp, revert)
    elseif kind == 'or' then
        self:traceOr(exp, revert)
    end
end

function W:traceAnd(exp, revert)
    -- 树形：exp[2] 是左操作数，exp[3] 是右操作数
    -- 如果某一侧编译时没有产生 flow 条目（如字面量），则该位置为 nil，跳过
    local left  = exp[2]
    local right = exp[3]

    local stack1 = self:pushStack()
    if left then
        self:traceConditionUnit(left, revert)
    end

    local stack2 = self:pushStack()
    if right then
        self:traceConditionUnit(right, revert)
    end
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
    -- 树形：exp[2] 是左操作数，exp[3] 是右操作数
    -- 如果某一侧编译时没有产生 flow 条目（如字面量），则该位置为 nil，跳过
    local left  = exp[2]
    local right = exp[3]

    -- stack1 和 stack2 从同一基础出发独立收窄（平行而非嵌套）
    local stack1 = self:pushStack()
    if left then
        self:traceConditionUnit(left, revert)
    end
    self:popStack()

    local stack2 = self:pushStack()
    if right then
        self:traceConditionUnit(right, revert)
    end
    self:popStack()

    local currentStack = self:currentStack()

    -- true 分支：左侧或右侧任一为真，取并集
    for k in pairs(stack1.current) do
        if stack2.current[k] then
            currentStack.current[k] = stack1.current[k] | stack2.current[k]
        end
    end

    -- false 分支：左侧且右侧都为假，两侧 otherSide 依次应用
    ls.util.tableMerge(currentStack.otherSide, stack1.otherSide)
    ls.util.tableMerge(currentStack.otherSide, stack2.otherSide)
end

function W:traceTruly(exp, revert)
    if exp[1] ~= 'ref' then
        return
    end

    self:traceByValue(exp, self.scope.rt.TRULY, revert)

    -- 间接窄化：若该 ref 的变量值来自函数调用的返回值，
    -- 通过 callLinkMap 窄化同一 call 的其他返回值
    local id = exp[2]
    if self.varLinkMap and self.callLinkMap then
        local linkEntry = self.varLinkMap[id]
        if linkEntry then
            local callAlias   = linkEntry[3]
            local funcKey     = linkEntry[4]
            local myRetIndex  = linkEntry[6] or 1
            local funcVar = self.map[funcKey]
            if not funcVar then
                goto traceTruly_done
            end
            local func = funcVar.value
            if not func then
                goto traceTruly_done
            end
            local rt = self.scope.rt
            local otherReturns = self.callLinkMap[callAlias]
            if otherReturns then
                for _, info in ipairs(otherReturns) do
                    if info.varId ~= id then
                        local otherValue = self:getValue(info.varId)
                        if otherValue then
                            local narrowed, otherSide = rt.narrow(otherValue):asCall {
                                func        = func,
                                myType      = 'return',
                                myIndex     = info.returnIndex,
                                mode        = 'match',
                                targetType  = 'return',
                                targetIndex = myRetIndex,
                                targetValue = rt.TRULY,
                            }:narrowCall()
                            if revert then
                                self:setNarrowResult(info.varId, otherSide, narrowed)
                            else
                                self:setNarrowResult(info.varId, narrowed, otherSide)
                            end
                        end
                    end
                end
            end
            ::traceTruly_done::
        end
    end
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

    -- 间接窄化：若该 ref 的变量值来自函数调用，通过 link 窄化参数
    local id = left[2]
    if self.varLinkMap then
        local linkEntry = self.varLinkMap[id]
        if linkEntry then
            -- linkEntry = {'link', varId, callAlias, funcAlias, argAliases}
            local callExp = { 'call', linkEntry[3], linkEntry[4], linkEntry[5] }
            self:traceCallEqual(callExp, right, revert)
        end
    end
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
    local funcVar = self.map[funcAlias]
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
    local funcVar = self.map[funcAlias]
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
