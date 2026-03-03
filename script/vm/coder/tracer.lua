---@class Coder
local M = Class 'Coder'

---@type Coder.Tracer[]
M.tracers = nil

---@param source LuaParser.Node.Function
function M:startTracer(source)
    local id = 'scope|' .. source.uniqueKey
    local tracerKey = self:getCustomKey(id)
    self:addLine('{tracer} = rt.tracer(r, p)' % {
        tracer = tracerKey,
    })
    self:addLine('{tracer}:setFlow(coder.tracerFlowMap[{flow%q}])' % {
        tracer = tracerKey,
        flow = id,
    })
    if not self.tracers then
        self.tracers = {}
    end
    table.insert(self.tracers, New 'Coder.Tracer' (self, id))
end

function M:getTracer()
    return self.tracers[#self.tracers]
end

function M:finishTracer()
    ---@type Coder.Tracer
    local top = table.remove(self.tracers)
    local data = top:getStack()
    self.tracerFlowMap[top.id] = data
end

---@class Coder.Tracer
local T = Class 'Coder.Tracer'

Presize(T, 4)

---@param coder Coder
---@param id string
function T:__init(coder, id)
    self.coder   = coder
    self.id      = id
    -- block 栈：最顶层是当前语句块，push/pop 对应 if 分支进出
    self.blocks  = {{}}
    -- node 栈：正在构建的复合表达式节点（==, and, or, not ...）
    self.nodes   = {}
    self.visibleVars = {}
end

--- 将一个 entry 追加到当前位置。
--- 若正在构建复合节点，追加为该节点的操作数；
--- 否则追加到当前语句块。
---@param kind string
---@param ... any
function T:append(kind, ...)
    local entry = { kind, ... }
    if #self.nodes > 0 then
        -- 追加为最内层复合节点的操作数
        local node = self.nodes[#self.nodes]
        node[#node+1] = entry
    else
        -- 追加到当前语句块
        local block = self.blocks[#self.blocks]
        block[#block+1] = entry
    end
end

--- 开始构建一个复合节点。
--- op 为字符串时，节点第一个元素为 op（有 tag）；
--- op 为 false/nil 时，生成匿名节点（无 tag，子节点从 [1] 开始）。
---@param op string | false | nil
function T:openNode(op)
    local node
    if op then
        node = { op }
    else
        node = {}
    end
    self.nodes[#self.nodes+1] = node
end

--- 完成当前复合节点的构建，将其"提交"到上一层（父节点或语句块）。
function T:closeNode()
    local node = table.remove(self.nodes)
    if #self.nodes > 0 then
        -- 提交到父节点
        local parent = self.nodes[#self.nodes]
        parent[#parent+1] = node
    else
        -- 提交到语句块
        local block = self.blocks[#self.blocks]
        block[#block+1] = node
    end
end

function T:appendVar(source)
    local id = self.coder:getVarName(source)
    if not id then
        return
    end
    -- 若处于 deferVar 模式，暂存到队列，等 flushDeferVar 时再追加到 flow
    if self.deferVarQueue then
        self.deferVarQueue[#self.deferVarQueue + 1] = source
        return
    end
    self:append('var', id, source.uniqueKey)
    self.visibleVars[id] = true
end

--- 开始推迟 appendVar：之后调用 appendVar 的节点放入 deferVarQueue。
--- 支持嵌套：每次调用都会压入一个新的队列层。
function T:beginDeferVar()
    if not self.deferVarStack then
        self.deferVarStack = {}
    end
    local queue = {}
    self.deferVarStack[#self.deferVarStack + 1] = queue
    self.deferVarQueue = queue
end

--- 将当前层队列中所有推迟的 appendVar 刷入 flow，并弹出该层。
--- 支持嵌套：弹出当前层后恢复上一层为活跃队列。
function T:flushDeferVar()
    if not self.deferVarStack or #self.deferVarStack == 0 then
        return
    end
    local queue = table.remove(self.deferVarStack)
    -- 恢复上一层（若有），否则置 nil 表示不在 defer 模式
    self.deferVarQueue = self.deferVarStack[#self.deferVarStack]
    for _, source in ipairs(queue) do
        local id = self.coder:getVarName(source)
        if id then
            self:append('var', id, source.uniqueKey)
            self.visibleVars[id] = true
        end
    end
end

function T:appendRef(source)
    local id = self.coder:getVarName(source)
    if not id then
        return
    end
    self:append('ref', id, source.uniqueKey)
    -- 只有在该变量曾经被赋值（visibleVars[id] 为 true）之后的读取点（ref shadow）
    -- 才设置 tracer，触发 Walker 来获得正确的收窄/赋值后的值。
    -- Walker 内部通过 getCurrentValue() 读赋值表达式，不会触发 ref shadow 的 tracer，避免递归。
    if self.visibleVars[id] then
        self.coder:addLine('{var}:setTracer({tracer})' % {
            var    = self.coder:getKey(source),
            tracer = self.coder:getCustomKey(self.id),
        })
    end
    self.visibleVars[id] = true
end

---@param source LuaParser.Node.Call
function T:appendCall(source)
    local funcAlias = source.node.uniqueKey
    local argAliases = {}
    for _, arg in ipairs(source.args) do
        argAliases[#argAliases+1] = arg.uniqueKey
    end
    self:append('call', source.uniqueKey, funcAlias, argAliases)
end

--- 记录变量 var 的值来自函数调用 callSource（用于间接窄化）
--- 生成 block 层 entry: {'link', varId, callAlias, funcAlias, argAliases, returnIndex}
---@param varSource LuaParser.Node.Var | LuaParser.Node.Local
---@param callSource LuaParser.Node.Call
---@param returnIndex integer 该变量是 call 的第几个返回值（1-based）
function T:appendLink(varSource, callSource, returnIndex)
    local id = self.coder:getVarName(varSource)
    if not id then
        return
    end
    local funcKey = callSource.node.uniqueKey
    local argAliases = {}
    for _, arg in ipairs(callSource.args) do
        argAliases[#argAliases+1] = arg.uniqueKey
    end
    self:append('link', id, callSource.uniqueKey, funcKey, argAliases, returnIndex or 1)
end

--- 进入一个语句块（如 if 分支），创建新的 block 层。
function T:pushBlock()
    local block = {}
    self.blocks[#self.blocks+1] = block
    return block
end

--- 离开语句块，返回被弹出的 block。
function T:popBlock()
    return table.remove(self.blocks)
end

function T:getStack()
    return self.blocks[1]
end
