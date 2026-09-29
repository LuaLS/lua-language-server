# Design

背景与动机见 `proposal.md`；行为契约见 `specs/narrowing/spec.md`；事实与证据见 `facts/narrowing.md` F27。

## Context

收窄值的生命周期（代码坐标见 proposal）：

1. coder 为每个函数/文件发一个 `Node.Tracer`（`script/vm/coder/tracer.lua:8`），
   `rt.tracer(r, p)` 里带 `map`（alias → 节点）；
2. 读取变量时 `Node.Variable.__getter.value`（`script/node/variable.lua:1034`）触发
   `self.tracer:trace()` → `Node.Tracer.walker`（getter，`script/node/tracer.lua:51`）
   → `W:start(flow)`，**`started` 之后就不再走**；
3. walk 里 `W:traceRef` 把该读点的收窄值 `node:setCurrentValue(value)` 写回节点
   （`script/node/tracer.lua:432-434`）；`setCurrentValue` 先 `flushCache()` 再写
   （`script/node/variable.lua:1012`）；
4. `currentValue` 是 **getter 字段**（有 `M.__getter.currentValue` 声明），
   所以 `rt:flushCacheNow()` → `class.flush(node)` 会把它清掉（`script/node/runtime.lua:568`）；
5. 清掉之后没有任何机制把值写回来 ⇒ `__getter.value` 落到 `getStaticValue()` / `getGuessValue()`。

实测（本轮）：目标工程扫描 3212 次 walk，其中嵌套 668 次，**健康路径 maxDepth = 10**。
这说明嵌套 walk 本身是常态但很浅；前两次尝试爆栈（1996+ 层）是「重走」被放开后
**在嵌套链里互相触发**造成的。

## Goals / Non-Goals

**Goals**

- 收窄值被 flush 清掉后，消费者读取时能触发一次重算，读值不再退化成未收窄值。
- 重算只在非嵌套时刻发生；同一次取值最多触发一次。
- 保持既有语义：flush 仍清收窄值，`class.flush` 不动。

**Non-Goals**

- 不改 `class.flush` / `currentValue` 的 flush 归属（尝试 3 已证伪）。
- 不改诊断 provider 的取值方式（修的是读值通路，不是消费者）。
- 不追求「嵌套 walk 里也立刻重算」：spec 明确允许嵌套时维持旧行为。
- 不动 F19 的循环/重赋值语义（只在收尾看是否连带）。

## Decisions

### D1 触发点放在「诊断 pass 边界」，不放在 `value` getter 里（本轮实测的关键取舍）

先在 `Node.Variable.__getter.value` 里按需 `retrace`（见 D4 的实测）会爆栈：**求值环**
（`__getter.value` → `mergeValueResults` → `Table:addChilds` → … 回到 `__getter.value`）
本该命中缓存而终止，重走把环重新喂活 ⇒ 栈深 1981 层。

改成在 **pass 边界**（`ls.feature.diagnostic(uri)` 拿到 vfile 之后、跑 provider 之前）
作废该文件所有 tracer 的 walk 结果：每个 tracer 每 pass 至多重走一次，且触发点在求值链之外。

```lua
-- script/feature/diagnostic/init.lua
local coder = vfile and vfile.coder
if coder and coder.map then
    for _, node in pairs(coder.map) do
        if node.kind == 'tracer' then
            ---@cast node Node.Tracer
            node:restart()
        end
    end
end
```

代价：每个文件每个 pass 的收窄重算一次。实测扫描耗时 10.3s → 10.56s（无回归）。

### D2 `restart` 的实现细节与护栏

```lua
-- Node.Tracer：walker 实例仍由 getter 持有，只记录「建过没」
M.__getter.walker = function (self)
    local walker = New 'Node.Tracer.Walker' (self.scope, self.map, self.parentMap, self)
    self.hasWalker = true
    return walker, true
end

function M:restart()
    if not self.hasWalker then
        return          -- 没建过 = 本来就是从头走，不建多余对象
    end
    self.walker:restart()
end

-- Node.Tracer.Walker
function W:restart()
    if self.walking then
        return          -- 走的过程中不动，避免把当前这次走坏
    end
    self.started = nil
end

function W:start(block)
    if self.walking then return end       -- 同一 walker 不重入
    if self.started then return end
    self.started = true
    self.walking = true
    ...
    local ok, err = xpcall(self.traceBlock, debug.traceback, self, block)
    self.walking = nil
    if not ok then
        self.started = nil                -- 异常不留脏状态（否则这个 tracer 之后走不动）
        error(err, 0)
    end
end
```

模型：`started` = 「这次 pass 已经算过了」；`restart()` = 「作废，下次读取重算」；
`walking` = 「正在算，别动它」。收窄值本身仍在 `Node.Variable.currentValue`（getter 字段，
`class.flush` 照旧清）—— 语义没变，只是清完能重算。

### D3 备选与取舍

- **把收窄值挪出 flush 集合**（自定义非 getter 存储）：会改变「依赖变化即失效」的语义
  （spec 第二条明确不这么做），且尝试 3 已证明删 getter 声明会直接破坏 class 机制。
- **消费者侧（provider）自己强制重走**：能修一部分，但 hover / completion 等其它读值通路仍陈旧，
  且把引擎问题留在消费者，不采用。
- **不修**：36 条（含 F19 一族），代价是每条都要目标侧 cast。

### D4 第四次尝试：惰性嗅探 + 顶层 `retrace`（**已实现，实测仍爆栈，已回退**）

按 D1–D3 实现后实测：

- 护栏生效：`walkDebug` 显示 `walks=1000 nested=125 **maxDepth=10**`（与基线同量级），
  前三次那种「嵌套 walk 深到 1996 层」的爆栈**没有出现**；
- 但仍然 `C stack overflow`（`table.lua:97`，栈里 `skipping 1981 levels`）：
  链是 **求值环**（`Node.Variable.__getter.value` → `mergeValueResults` → `Table:addChilds`
  → … → 又回到 `__getter.value`），不是 walk 嵌套。
  ⇒ 强制重走会把求值环「重新喂活」：环上本可命中的缓存被 flush/重算，于是环继续加深到爆栈。
- 结论：**「重走」这条路线与求值环不兼容**，不是护栏不够，而是方向问题。
  若还要做，必须让重算发生在求值环**之外**（例如诊断 pass 开始时就地重算一次、
  而不是在 `value` getter 里按需触发），并且要有「每个 tracer 每次 pass 至多一次」的节流。

本轮因此**不采用代码改动**（`git checkout` 回退，工作区干净）。

### D5 剩下的候选（未实测，供下一轮选）

1. **收窄值双写**：`setCurrentValue` 时同时写一个不参与 `class.flush` 的兜底字段，
   `getCurrentValue()` 在 `currentValue` 为空时用它。风险：兜底值可能陈旧（与 spec 第二条冲突），
   需要明确「什么情况下允许用旧值」。
2. **pass 级重算**：在 `ls.feature.diagnostic(uri)` 开始处（求值链之外）对涉及文件的 tracer 逐个
   `restart` 一次，让后续读取自然重算；代价是每个 pass 全量重走（需量耗时）。
3. **目标侧 stopgap**：给 15 处读点加 `--[[@as ...]]`（治标、不推荐，但可立即清掉误报）。

- **把收窄值挪出 flush 集合**（自定义非 getter 存储）：会改变「依赖变化即失效」的语义
  （spec 第二条明确不这么做），且尝试 3 已证明删 getter 声明会直接破坏 class 机制。
- **消费者侧（provider）自己强制重走**：能修 15 条，但 hover / completion 等其它读值通路仍陈旧，
  且把引擎问题留在消费者，不采用。
- **不修**：15 条 `param-type-mismatch` + 疑似 F19 的 29 条 `need-check-nil`，代价是每条都要目标侧 cast。

## Risks / Trade-offs

- [重走把栈打爆] → 只在 `walkingDepth == 0` 重走；先用 `walkDebug` 量 maxDepth 与 walk 次数
  （基线 3212 / 668 / 10），改后对比，深度数量级不得上升。
- [O(n²) 重走] → 只对「写过收窄值又被清掉」的读点触发；量 walk 次数增幅。
- [收窄值刷新后与旧值不同（语义变化）] → 基线比对只看「移除 / 新增」，新增 > 0 就逐个看是否值质量回归。
- [异常路径留下脏状态] → walk 用 `xpcall` 包一层，失败时清 `started`/`walking` 后原样抛出。
- [同一文件多次 flush 造成抖动] → 一次取值最多触发一次重走（嗅探在取值内部，判完即用）。

## Migration Plan

1. 已存基线 `tmp/scan-199.txt`（199）。
2. 按 tasks 实现：`_walker` 持久化 → 护栏（`walking`/`walkingDepth`/`restart`）→
   变量侧嗅探字段与 `retrace` 调用 → `test/node/tracer.lua` 用例。
3. 每步 `--baseline=tmp/scan-199.txt` 比对；`walkDebug` 对比 walk 次数与 maxDepth。
4. 收尾：全量 `--test` 绿、目标 199 → 184、面板 0、F27 更新为「成立」并跑 `--test tools.facts`，
   归档 change 并更新 `项目实践.md`。回退用 git 单点还原。
