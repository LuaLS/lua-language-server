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

---@param tracker Node.Tracer
---@return Node.Tracer
function M:setParent(tracker)
    self.parent = tracker
    return self
end

---@type Node.Tracer?
M.parent = nil

-- 闭包创建点处外层收窄状态的快照（由外层 walker 推入）
---@type table<table<string, Node>>?
M.parentStack = nil

---@type Node.Tracer.Walker?
M.walker = nil

M.__getter.walker = function (self)
    return New 'Node.Tracer.Walker' (self.scope, self.map, self.parentMap, self), true
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
---@param tracer Node.Tracer
function W:__init(scope, map, parentMap, tracer)
    self.scope = scope
    self.map   = map
    self.parentMap = parentMap
    self.tracer = tracer
end

function W:start(block)
    if self.started then
        return
    end
    self.started = true
    self.aliasID = {}
    self.assignVersion = 0
    self.versionMap = {}
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

-- 这些节点一定不是 nil（基础类型由 isDefinitelyNotNil 单独判定）
local NOT_NIL_KINDS = {
    table   = true,
    class   = true,
    ['function'] = true,
    array   = true,
    list    = true,
    tuple   = true,
    value   = true,
    pack    = true,
    spread  = true,
}

-- 收窄结果常以变量包装返回（如把实参收窄到形参的注解变量），判定前先展开
---@param node Node
---@return Node
local function resolveNarrowValue(node)
    local cur = node
    for _ = 1, 8 do
        if cur.kind ~= 'variable' then
            break
        end
        ---@cast cur Node.Variable
        local inner = cur:getStaticValue()
        if not inner or inner == cur then
            break
        end
        cur = inner
    end
    return cur
end

-- 值本身是否就是 nil（或 union 里含 nil 成员）
---@param node any
---@return boolean
local function isNilValue(node)
    if not node then
        return false
    end
    if node.kind == 'variable' then
        ---@cast node Node
        node = resolveNarrowValue(node)
    end
    if node.kind == 'type' then
        return node.typeName == 'nil'
    end
    if node.kind == 'union' then
        ---@cast node Node.Union
        for _, v in ipairs(node.values) do
            if v.kind == 'type' and v.typeName == 'nil' then
                return true
            end
        end
    end
    return false
end

-- 值是否「确定不是 nil」：any / unknown / 含 nil 成员的 union 都不算确定
---@param node any
---@return boolean
local function isDefinitelyNotNil(node)
    if not node then
        return false
    end
    if node.kind == 'variable' then
        ---@cast node Node
        node = resolveNarrowValue(node)
    end
    if node.kind == 'type' then
        ---@cast node Node.Type
        local name = node.typeName
        if name == 'nil' or name == 'any' or name == 'unknown'
        or name == 'provisional' or name == 'unknownkey' then
            return false
        end
        return true
    end
    if node.kind == 'union' then
        ---@cast node Node.Union
        for _, v in ipairs(node.values) do
            if not isDefinitelyNotNil(v) then
                return false
            end
        end
        return true
    end
    return NOT_NIL_KINDS[node.kind] == true
end

-- 短路操作数的继承起点：只继承「确定不是 nil」的收窄。
-- 另一侧变成 nil 的收窄多是字段比较向上传播的副产品（`c.type ~= 'x'` 不该让 c 变成 nil），
-- 带进短路右侧会把可能为 nil 的值算给右操作数
---@param stack Node.Tracer.Stack
---@param base table<string, Node>
function W:seedOpposite(stack, base)
    for k, v in pairs(base) do
        if not isNilValue(v) then
            stack.current[k] = v
        end
    end
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
    return self:getUpvalue(id)
end

--- 闭包内读取外层变量：用创建时外层 walker 推来的收窄快照兜底
---@param id string
---@return Node?
function W:getUpvalue(id)
    local tracer = self.tracer
    if not tracer then
        return nil
    end
    local snapshot = tracer.parentStack
    if not snapshot then
        local parent = tracer.parent
        if not parent then
            return nil
        end
        -- 快照还没推过来：先让外层 walker 走到闭包创建点（结果与触发者无关）
        parent.walker:start(parent.flow)
        snapshot = tracer.parentStack
        if not snapshot then
            return nil
        end
    end
    for i = #snapshot, 1, -1 do
        local value = snapshot[i][id]
        -- 只采用外层已经排除 nil 的结果：这正是收窄要修的场景；
        -- 仍带 nil 的 flow 值往往比注解/赋值推断更含糊，用在闭包里会引入误报
        if value and not self.scope.rt.NIL:canCast(value) then
            return value
        end
    end
    return nil
end

--- 该 id 是否为闭包里的外层变量（外层 walker 在创建点已记过它的状态）
---@param id string
---@return boolean
function W:isUpvalue(id)
    local tracer = self.tracer
    if not tracer then
        return false
    end
    local snapshot = tracer.parentStack
    if not snapshot then
        return false
    end
    for i = #snapshot, 1, -1 do
        if snapshot[i][id] ~= nil then
            return true
        end
    end
    return false
end

--- 当前收窄状态的快照：逐层拷贝，外层 walker 还会继续往里写，不能共享；
--- 同时带上本 tracer 已收到的那份（两层以上闭包时逐层传下去）
---@return table<table<string, Node>>
function W:snapshot()
    local result = {}
    local base = self.tracer and self.tracer.parentStack
    if base then
        for i = 1, #base do
            result[#result+1] = base[i]
        end
    end
    for i = 1, #self.stacks do
        local src = self.stacks[i].current
        local dst = {}
        for k, v in pairs(src) do
            dst[k] = v
        end
        result[#result+1] = dst
    end
    return result
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
    -- 用 getStaticValue()（不触发 tracer）而非 .value（会触发新 Walker 递归）。
    -- 赋值点 shadow 的 currentValue 即是 Coder 编译时已设置好的赋值表达式值。
    local value = node:getStaticValue()
    self:setValue(id, value, true)
    self.assignVersion = self.assignVersion + 1
    self.versionMap[id] = self.assignVersion
end

--- 由基变量的 flow 值派生字段读取结果（不写入收窄栈）：
--- 基变量被收窄后，注解推导出的字段值里掺着的 nil 不该再算进来。
--- 求值未完成（PROVISIONAL）或字段不存在时不采纳。
---@param id string
---@return Node?
function W:deriveFieldValue(id)
    local pdata = self.parentMap[id]
    if not pdata or pdata[3] then
        return nil
    end
    local pvalue = self:getValue(pdata[1]) or self:deriveFieldValue(pdata[1])
    if not pvalue then
        return nil
    end
    local r, e = pvalue:get(pdata[2])
    if not e then
        return nil
    end
    if r.kind == 'field' then
        r = r.value
    end
    if r.kind == 'variable' then
        ---@cast r Node.Variable
        r = r:getStaticValue()
    end
    if r == self.scope.rt.PROVISIONAL then
        return nil
    end
    return r
end

---@param ref ['ref', string, string]
---@return Node?
--- 不变量：本函数只允许通过不触发 Tracer 的接口读取输入（stratum-1），
--- 否则会与正在进行的求值相互递归（求值 -> walk -> 求值）。
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
    local pdata = self.parentMap[id]
    local rt = self.scope.rt
    if pdata and pdata[3] then
        local pver = self.versionMap[pdata[1]]
        local myver = self.versionMap[id]
        if pver and (not myver or pver > myver) then
            local pvalue = self:getValue(pdata[1])
            if pvalue then
                local r, e = pvalue:get(pdata[2])
                if e then
                    if r.kind == 'field' then
                        r = r.value
                    end
                    if r.kind == 'variable' then
                        ---@cast r Node.Variable
                        r = r:getStaticValue()
                    end
                    -- 求值未完成：不采纳该值，但保留 walker 自身的值（无则后续走静态兜底），
                    -- 不能丢弃整次读取，否则节点拿不到位置相关的值
                    if r ~= rt.PROVISIONAL then
                        value = r
                    end
                elseif myver then
                    value = rt.NIL
                end
            end
        end
    elseif pdata and not value then
        -- 普通字段读取的 flow 值：基变量收窄后，注解推导里的 nil 不该再算进来
        -- （`---@type T?` 的局部收窄后读字段仍是 `T?` 那一族误报）。
        -- 派生值仍可能为 nil 时不采纳（多半比注解更含糊，采纳会引入新误报），
        -- 也不写回收窄栈：字段读取的记忆值会掩盖基变量后续的重赋值。
        local derived = self:deriveFieldValue(id)
        if derived and not isNilValue(derived) then
            value = derived
        end
    end
    if not value and not self:isUpvalue(id) then
        local node = self.map[alias]
        -- 统一使用 getStaticValue()（不含可选链的 nil 合并），
        -- 避免把单次可选链访问的 nil 写入共享的 id 值，污染后续普通访问。
        value = node:getStaticValue()
        self:setValue(id, value)
    end
    local node = self.map[alias]
    node:setCurrentValue(value)
    return value
end

--- 字段读取 id 的收窄值：收窄栈上没有时按基变量的 flow 值派生
---@param id string
---@return Node?
function W:getFieldNarrowValue(id)
    local value = self:getValue(id)
    if value then
        return value
    end
    return self:deriveFieldValue(id)
end

-- `---@cast x -T` 用：只按**同名**去掉成员。
-- 不能按 `canCast` 去（那会把 T 的子类一并去掉：`---@cast p -fs.path` 里的 fs.dummy
-- 继承 fs.path，属于「不是父类本身」的成员，应当保留）。
-- 成员都取不到名字时（如合并出来的表）返回 nil，由调用方按 `canCast` 回退。
---@param rt Node.Runtime
---@param value Node
---@param castType Node
---@return Node?
local function removeMemberByName(rt, value, castType)
    if castType.kind ~= 'type' then
        return nil
    end
    ---@cast castType Node.Type
    local name = castType.typeName
    local target = value:simplify()
    local members
    if target.kind == 'union' then
        ---@cast target Node.Union
        members = target.values
    elseif target.kind == 'type' and target.value ~= target and target.value.kind == 'union' then
        ---@cast target Node.Type
        local tv = target.value
        ---@cast tv Node.Union
        members = tv.values
    else
        members = { target }
    end
    local remain = {}
    local named  = false
    for _, m in ipairs(members) do
        local mname
        if m.kind == 'type' then
            ---@cast m Node.Type
            mname = m.typeName
        elseif m.kind == 'class' then
            ---@cast m Node.Class
            mname = m.className
        elseif m.kind == 'alias' then
            ---@cast m Node.Alias
            mname = m.aliasName
        end
        if mname then
            named = true
        end
        if mname ~= name then
            remain[#remain + 1] = m
        end
    end
    if not named then
        return nil
    end
    if #remain == 0 then
        return rt.NEVER
    end
    if #remain == #members then
        -- 按同名没有可去成员：保持原值（不回退按 canCast 去，否则子类会被连坐）
        return value
    end
    if #remain == 1 then
        return remain[1]
    end
    return rt.union(remain)
end

---@param cast ['cast', string, ('+' | '-' | nil), (string | nil), (boolean | nil)]
function W:traceCast(cast)
    local id  = cast[2]
    local op  = cast[3]
    local key = cast[4]
    local opt = cast[5]
    local rt  = self.scope.rt
    local castType = key and self.map[key] or nil
    local value = self:getValue(id)
    if not value then
        -- 取不到旧值时只能做「断言」：`+`/`-` 需要旧值，不动
        if not castType or op then
            return
        end
        value = castType
    elseif castType then
        if op == '-' then
            value = removeMemberByName(rt, value, castType) or rt.subtract(value, castType)
        elseif op == '+' then
            value = value | castType
        else
            -- 不带 op 是断言：注解说是什么就是什么（与 `+`/`-` 的并入/去掉不同）
            value = castType
        end
    end
    if opt then
        if op == '-' then
            value = rt.subtract(value, rt.NIL)
        else
            value = value | rt.NIL
        end
    end
    self:setValue(id, value)
    -- 读取点自身的读值也要更新：`f(x--[[@as T]])` 的实参就是这条 cast 所在的表达式，
    -- 否则消费方（诊断 provider）读到的是 cast 之前的值
    local alias = cast[6]
    local node = alias and self.map[alias]
    if node and node.kind == 'variable' then
        ---@cast node Node.Variable
        node:setCurrentValue(value)
    end
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
        -- 以 return / goto / break / continue 结尾的分支不可达 if 之后的流程，其流不参与合并；
        -- 但其 otherSide（guard 收窄后的另一侧）需要参与合并
        if lastStack.terminated then
            for id in pairs(lastStack.otherSide) do
                stacks[#stacks+1] = { current = { [id] = lastStack.otherSide[id] } }
                changed[id] = true
            end
        else
            stacks[#stacks+1] = lastStack
            if lastStack.changed then
                ls.util.tableMerge(changed, lastStack.changed)
            end
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

    -- ifchild 是一个数组，第一个元素若为 return/exit/condition 节点则处理条件。
    -- return/exit 都表示该分支不会顺序落到 if 之后（return 返回、goto 跳 label、
    -- break/continue 跳出循环），合并时只取其 otherSide（守护后的另一侧收窄）
    local bodyStart = 1
    local first = ifchild[1]
    local terminated
    if first == 'return' or first == 'exit'
    or (type(first) == 'table' and (first[1] == 'return' or first[1] == 'exit')) then
        terminated = true
        bodyStart = 2
        first = ifchild[2]
    end
    if type(first) == 'table' and first[1] == 'condition' then
        self:traceCondition(first)
        bodyStart = bodyStart + 1
    end
    self:traceBlock(ifchild, bodyStart)

    self:popStack()
    stack.terminated = terminated
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
    if tag == 'cast' then
        self:traceCast(unit)
        return
    end
    if tag == 'nonnil' then
        local id, alias = unit[2], unit[3]
        self.aliasID[alias] = id
        local stack = self:currentStack()
        self.nonNilBackup = self.nonNilBackup or {}
        self.nonNilBackup[id] = { stack.current[id], stack.otherSide[id] }
        self:traceByValue({ 'ref', id, alias }, self.scope.rt.NIL, true)
        return
    end
    if tag == 'unnonnil' then
        local id = unit[2]
        local backup = self.nonNilBackup and self.nonNilBackup[id]
        if not backup then
            return
        end
        self.nonNilBackup[id] = nil
        local stack = self:currentStack()
        stack.current[id] = backup[1]
        stack.otherSide[id] = backup[2]
        return
    end
    if tag == 'seed' then
        -- 闭包创建点：把当前收窄快照推给内层 tracer
        ---@type table<string, Node>
        local map = self.map
        local tracer = map[unit[2]]
        if tracer and tracer.kind == 'tracer' then
            ---@cast tracer Node.Tracer
            tracer.parentStack = self:snapshot()
        end
        return
    end
    if tag == 'and' or tag == 'or' then
        -- 顶层 and/or 表达式节点（如 `x = a and b`）：
        -- 遍历内部 ref，使其获得正确的 currentValue，避免退化到 getGuessValue 引入 nil
        for i = 2, #unit do
            local inner = unit[i]
            if type(inner) == 'table' then
                self:traceUnit(inner)
            end
        end
        return
    end
    if tag == 'call' then
        self:traceCallNarrow(unit, false)
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
        self:traceTruthy(exp, revert)
    elseif kind == 'call' then
        self:traceCallTruthy(exp, revert)
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
    elseif kind == '<'
    or     kind == '>'
    or     kind == '<='
    or     kind == '>=' then
        -- 比较运算不产生类型收窄，仅追踪操作数 ref 的流
        for i = 2, #exp do
            local inner = exp[i]
            if type(inner) == 'table' then
                self:traceUnit(inner)
            end
        end
    elseif kind == 'not' then
        -- 结构：{'not', [副作用ref...], condExp}
        -- 最后子节点是 condExp，前面的副作用 ref 用于建立 aliasID
        local n = #exp
        for i = 2, n - 1 do
            self:traceUnit(exp[i])
        end
        local inner = exp[n]
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
    -- 树形：{'and', 左, 右的 ref…, 右} —— 右操作数自己的 ref 会平铺在同一个节点里
    -- （只有单条目操作数才长成 {'and', 左, 右}）。这里保持 exp[2]/exp[3] 的旧读法，
    -- 但中间的 ref 必须跟着右操作数、在 seed 之后走一遍：否则这些读取拿不到收窄值，
    -- 节点上也没有 currentValue，消费方（诊断 provider）会退回注解值。
    local left  = exp[2]
    local right = exp[3]

    local stack1 = self:pushStack()
    if left then
        self:traceConditionUnit(left, revert)
    end

    -- 右侧只在左侧为真时才求值（`and` 短路）：把左侧的真流垫在下面供其继承，
    -- 右侧自己的收窄仍只记在 stack2，避免左侧的收窄被当成右侧的结果合并出去
    local seed = self:pushStack()
    self:seedOpposite(seed, revert and stack1.otherSide or stack1.current)

    local stack2 = self:pushStack()
    for i = 3, #exp - 1 do
        local inner = exp[i]
        if type(inner) == 'table' then
            self:traceUnit(inner)
        end
    end
    if right then
        self:traceConditionUnit(right, revert)
    end
    self:popStack()
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
    -- 树形：{'or', 左, 右的 ref…, 右} —— 右操作数自己的 ref 会平铺在同一个节点里
    -- （只有单条目操作数才长成 {'or', 左, 右}）。中间的 ref 跟着右操作数一起走，
    -- 理由同 traceAnd。
    local left  = exp[2]
    local right = exp[3]

    local stack1 = self:pushStack()
    if left then
        self:traceConditionUnit(left, revert)
    end

    -- 右侧只在左侧为假时才求值（`or` 短路）：把左侧的假流垫在下面供其继承，
    -- 右侧自己的收窄仍只记在 stack2，避免左侧的收窄被当成右侧的结果合并出去
    local seed = self:pushStack()
    self:seedOpposite(seed, revert and stack1.current or stack1.otherSide)

    local stack2 = self:pushStack()
    for i = 3, #exp - 1 do
        local inner = exp[i]
        if type(inner) == 'table' then
            self:traceUnit(inner)
        end
    end
    if right then
        self:traceConditionUnit(right, revert)
    end
    self:popStack()
    self:popStack()
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

function W:traceTruthy(exp, revert)
    if exp[1] ~= 'ref' then
        return
    end

    self:traceByValue(exp, self.scope.rt.TRUTHY, revert)

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
                goto traceTruthy_done
            end
            local func = funcVar.value
            if not func then
                goto traceTruthy_done
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
                                targetValue = rt.TRUTHY,
                            }:narrowCall()
                            local current = revert and otherSide or narrowed
                            local base = otherValue:simplify()
                            local known = base ~= rt.ANY and base ~= rt.UNKNOWN
                            local skip = known and otherValue:canCast(current)
                            if not skip then
                                if revert then
                                    self:setNarrowResult(info.varId, otherSide, narrowed)
                                else
                                    self:setNarrowResult(info.varId, narrowed, otherSide)
                                end
                            end
                        end
                    end
                end
            end
            ::traceTruthy_done::
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

--- 是否为动态键读取（键无法静态解析的 `t[expr]`）
---@param ref ['ref', string, string]
---@return boolean
function W:isDynamicKeyRef(ref)
    local node = self.map[ref[3]]
    return node?.kind == 'variable' and node?.key == self.scope.rt.UNKNOWNKEY
end

function W:traceByValue(var, value, revert)
    local rt = self.scope.rt
    local vvalue = self:traceRef(var)
    if not vvalue then
        -- 闭包里的外层变量（或参数）：外层 flow 值带 nil 时 getUpvalue 不采纳，
        -- 读值退回注解推断，收窄也就没有基值。这里补上注解作为基值，
        -- 但 `any` 不作为基值——对它收窄只会得到 truthy/falsy 标记，写进栈会盖住读值。
        local node = self.map[var[3]]
        vvalue = node and node:getExpectValue()
        if not vvalue
        or vvalue == rt.ANY
        or vvalue == rt.UNKNOWN then
            return
        end
    end

    local id = var[2]
    local narrowed, otherSide = vvalue:narrowEqual(value)
    -- 动态键读取（`t[expr]`）在中间码中共用一个槽位（`t[unknown]`），不同键之间会互相覆盖：
    -- 只对当前分支做断言，另一侧保持原值，避免某个键的真假结果泄漏给其他键的读取
    if self:isDynamicKeyRef(var) then
        if revert then
            narrowed = vvalue
        else
            otherSide = vvalue
        end
    end
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
        local pvalue = self:getFieldNarrowValue(id)
        if pvalue then
            -- 基值含糊（any/unknown）时按字段反推出来的只是垃圾值，
            -- 写回基变量会盖住它自己的读值（`if src.type == 'x'` 一族）
            local final = pvalue:finalValue()
            if final ~= rt.ANY and final ~= rt.UNKNOWN then
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
end

---通过函数调用返回值（truthy检测）收窄参数类型
---call entry: {'call', callAlias, funcAlias, {arg1Alias, ...}}
function W:traceCallTruthy(exp, revert)
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
        local argValue = self:getFieldNarrowValue(id)
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
            targetValue = rt.TRUTHY,
        }:narrowCall()
        -- 谓词真假只说明实参是否满足条件，不应把「确定不是 nil」的实参整份换成含 nil 的值
        -- （`fun(...): boolean?`、形参注解可选等与实参无关的签名会把实参收窄成含 nil 的形参变量）
        if isDefinitelyNotNil(argValue:simplify()) then
            if isNilValue(narrowed) then
                narrowed = argValue
            end
            if isNilValue(otherSide) then
                otherSide = argValue
            end
        end
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
            local pvalue = self:getFieldNarrowValue(pid)
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

--- 语句级调用：根据函数签名注解 narrow 收窄对应实参
--- call entry: {'call', callAlias, funcAlias, {arg1Alias, ...}}
--- narrow 注解声明参数在调用正常返回后收窄为 truthy 或指定类型。
function W:traceCallNarrow(exp, revert)
    if exp[1] ~= 'call' then
        return
    end
    local funcAlias  = exp[3]
    local argAliases = exp[4]
    local funcVar = self.map[funcAlias]
    if not funcVar then
        return
    end
    local func = funcVar.value
    if not func then
        return
    end
    local narrowDefs
    if func.kind == 'function' then
        ---@cast func Node.Function
        narrowDefs = func:getNarrowDefs()
    elseif func.kind == 'union' then
        local collected = {}
        func:each('function', function (f)
            ---@cast f Node.Function
            local defs = f:getNarrowDefs()
            if defs and #defs > 0 then
                collected[#collected+1] = defs
            end
        end)
        if #collected > 0 then
            narrowDefs = collected[1]
        end
    end
    if not narrowDefs or #narrowDefs == 0 then
        return
    end
    for _, def in ipairs(narrowDefs) do
        local paramName = def.param
        local narrowType = def.type
        local funcs = {}
        if func.kind == 'function' then
            ---@cast func Node.Function
            funcs[#funcs+1] = func
        else
            func:each('function', function (f)
                ---@cast f Node.Function
                if not f:isDummy() then
                    funcs[#funcs+1] = f
                end
            end)
        end
        for _, f in ipairs(funcs) do
            local argIndex = self:findParamIndex(f, paramName)
            if not argIndex then
                goto continue
            end
            local argAlias = argAliases[argIndex]
            if not argAlias then
                goto continue
            end
            local id = self.aliasID[argAlias]
            if not id then
                goto continue
            end
            local argValue = self:getFieldNarrowValue(id)
            if not argValue then
                goto continue
            end
            local narrowed, otherSide
            if narrowType then
                narrowed, otherSide = argValue:narrow(narrowType)
            else
                narrowed, otherSide = argValue.truthy, argValue.falsy
            end
            if revert then
                narrowed, otherSide = otherSide, narrowed
            end
            self:setNarrowResult(id, narrowed, otherSide)
            self:propagateNarrow(id, narrowed, otherSide, revert)
            goto continue
        end
        ::continue::
    end
    return
end

--- 在函数定义中找到参数名对应的位置（下标从 1 开始）
---@param func Node.Function
---@param paramName string
---@return integer?
function W:findParamIndex(func, paramName)
    for i, def in ipairs(func.paramsDef) do
        if def.key == paramName then
            return i
        end
    end
    if func.varargParamName == paramName then
        return #func.paramsDef + 1
    end
    return nil
end

--- 将收窄结果沿 parentMap 向上传播到父变量
---@param id string
---@param narrowed Node
---@param otherSide Node
---@param revert? boolean
function W:propagateNarrow(id, narrowed, otherSide, revert)
    local pid = id
    while true do
        local pdata = self.parentMap[pid]
        if not pdata then
            break
        end
        pid = pdata[1]
        local pvalue = self:getFieldNarrowValue(pid)
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
        local argValue = self:getFieldNarrowValue(id)
        if not argValue then
            goto continue
        end
        local argIsNotNil = isDefinitelyNotNil(argValue:simplify())
        local narrowed, otherSide = rt.narrow(argValue):asCall {
            func        = func,
            myType      = 'param',
            myIndex     = i,
            mode        = 'equal',
            targetType  = 'return',
            targetIndex = 1,
            targetValue = rvalue,
        }:narrowCall()
        -- 反推结果只是「形参要求什么」，不得比实参自己的类型更宽：
        -- 形参注解可选（`uri?`）时反推值会把实参读值染成 `uri | nil`，盖掉实参自己的类型
        local ownType = self.map[argAlias]:getExpectValue()
        if ownType and ownType ~= rt.ANY and ownType ~= rt.UNKNOWN then
            if not narrowed:canCast(ownType) then
                narrowed = ownType
            end
            if not otherSide:canCast(ownType) then
                otherSide = ownType
            end
        end
        -- 与 traceCallTruthy 同理：实参已确定不是 nil 时，反推结果里的 nil 只是形参注解带来的
        if argIsNotNil then
            if isNilValue(narrowed) then
                narrowed = removeMemberByName(rt, narrowed, rt.NIL) or argValue
            end
            if isNilValue(otherSide) then
                otherSide = removeMemberByName(rt, otherSide, rt.NIL) or argValue
            end
        end
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
            local pvalue = self:getFieldNarrowValue(pid)
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
---@field parent? Node.Tracer.Stack
---@field current table<string, Node>
---@field otherSide table<string, Node>
---@field changed? table<string, true>
---@field terminated? boolean # 分支以 return 结尾，流不参与合并
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
