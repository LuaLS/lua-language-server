# Design

动机与现状数字见 `proposal.md`；契约见 `specs/eval-context/spec.md`；相关事实：`returns.md` F2、`narrowing.md` F27、`classes.md` F25。

## Context

现状三条并存（数字见 proposal）：`ctx.visited`（事实标准，`ls.node.resolveContext` 已存在）、
`PROVISIONAL`（值占位、写缓存字段）、`intersection.logOverflow`（兜底）。
而**求值期会失效**（`setCurrentValue → flushCache`、`addRef` 级联），失效让节点换身份 ⇒ 身份键环保护失效
⇒ 实测 147k 层爆栈。

## Goals / Non-Goals

**Goals**

- 一次求值期内不发生失效；失效统一推迟到静默点批量生效。
- 环保护只有一套语义：身份键的 `visited`（跨节点）+ `inProgress`（同节点重入）。
- 「只缓存完成态」成为硬约束（占位不进缓存、不当最终值）。

**Non-Goals**

- 不重写 node/type 系统、不动 coder/parser/meta。
- 不追求一步到位：允许"旧路径（自有 visited / PROVISIONAL 写字段）与 ctx 并存"的过渡期。
- 不在本 change 内去修 F2 / F27 的具体成因（但把它们列为验证项，见 tasks 5）。

## Decisions

### D1 **不做** `__getter.value → :getValue(ctx)` 的全量改写

**为什么**：

1. `value` 的读取点遍布代码（`node.value`、`findValue/each`、`simplify`、各处 `get`…），改签名等于全库级改动；
2. `value` 的**缓存语义是按节点**的，而 ctx 只是**求值期**状态，两者正交 —— 把 ctx 塞进签名会把"求值期"泄漏到调用点；
3. 仓库已有同类先例：`rt:lockCache()/unlockCache()`、`rt.generation` 都是**runtime 上的 ambient 状态**，ctx 沿用同一风格最一致。

**怎么做**：

```lua
-- 1) ctx 复用/扩展现有的 resolveContext 形状
---@class Node.EvalContext
---@field visited table<Node, true>
---@field inProgress table<Node, Node>  -- 正在算的节点 -> 占位值
---@field map? table<Node.Generic, Node>
---@field location? Node.Location

-- 2) runtime 持有当前求值上下文栈；与 lockCache 同处实现（用户提的点子）
function M:enterEval(ctx?)   -- push；最外层同时 lockCache()
function M:exitEval()        -- pop；最外层同时 unlockCache()（静默点批量 flush）
function M:evalContext()     -- 当前 ctx（无则在最外层新建一个空的）
function M:withEval(fn)      -- enter → pcall → exit（异常也保证出栈）

-- 3) 求值入口加一层（诊断 / hover / completion / 单个文件的一次求值）
local ctx = rt:enterEval()
local ok, err = pcall(work)
rt:exitEval()
if not ok then error(err, 0) end

-- 4) getter 内部：只有**需要环保护**的少数类读 ambient ctx
M.__getter.value = function (self)
    local rt = self.scope.rt
    local ctx = rt:evalContext()
    local placeholder = ctx.inProgress[self]
    if placeholder then
        return placeholder, false        -- 占位、不进缓存（needCache = false）
    end
    ctx.inProgress[self] = rt.PROVISIONAL
    local result = ...                   -- 原有逻辑
    ctx.inProgress[self] = nil
    return result, true
end
```

- 需要**显式** ctx 的少数方法（`simplify(visited)`、`resolveGeneric(map, ctx)`）**保持签名**，
  在 getter 里调用时用 ambient ctx「播种」（`fn(args, ctx)`），避免出现两套状态。
- 若将来某个类想更显式：局部改成 thin getter（`__getter.value = function (self) return self:getValue(self.scope.rt:evalContext()) end`），
  只对确实要环保护的那几个类做（预计 < 10 个类）。

### D2 失效时机 = 入口 `lockCache` ⇒ 静默点批量

`enterEval` 最外层 `rt:lockCache()`，`exitEval` 最外层 `rt:unlockCache()`
（`unlockCache` 本来就在锁计数归零时 `flushCacheNow()`）⇒ 不变量「求值期不失效」零成本落地，
且**天然批量**（一次求值结束才生效），不会像本轮实验那样与求值交错。

### D3 `PROVISIONAL` 迁到 `ctx.inProgress`（保留其识别语义）

- 过渡期：`PROVISIONAL` 仍可被 `==` 识别（`tracer.lua` 里已有这种判断）；
- 新代码只用 `ctx.inProgress`；**不再往 getter 缓存字段里写占位**（避免把半成品留在字段上，
  也避免它被当结果缓存 —— 这是 F2 里 `Select.value` "早算就定终身"的同类坑）。

### D4 只缓存完成态

getter 返回 `res, needCache`：返回占位/中间态时一律 `needCache = false`
（class 系统原生支持）。这条同时给出一个**附带验收点**：F2 的 `Select.value` 若在依赖未就绪时
只返回占位且不缓存，再次求值就能拿到真实结果（→ `compile.lua:3043/3044` 应随之消失）。

### D5 迁移顺序（每步独立验收，先"只加不删"）

1. **引入 ctx + ambient + 入口 lock/unlock**：不改任何求值逻辑（只建栈、加锁）→ 目标工程 154 不变、全量测试绿；
2. **把 `intersection` / `union` / `table` / `variable` 的自有 `visited` 接到 ambient ctx**
   （行为等价，只是状态统一）→ 同上；
3. **`PROVISIONAL` → `ctx.inProgress`**（含"判定正在算时返回占位且不缓存"）→ 观察 F2/F27 族是否顺带消失，记数字；
4. **加 debug 断言**「求值期不得 `flushCacheNow`」（用 `rt.cacheLocked > 0` 时不得直接 flush 作断言）→ 防回归；
5. 台账/项目实践收尾（把"环保护统一"写进事实台账，替换掉零散描述）。

### 备选（未采用）

- **全量签名改造**（D1 的备选）：成本全库级、把求值期泄漏到调用点，且 `value` 被当字段用（`findValue/each`）⇒ 不采用。
- **只加 debug 断言不做统一**：能防回归但治不了"两套语义"的根，不采用。
- **只靠 `logOverflow` 兜底**：治标（日志刷屏 + 爆栈前不保证兜住），不采用。

## Risks / Trade-offs

- [ambient 状态的隐式性] → `withEval`/`pcall` 保证出栈；加断言「求值结束时 ctx 栈已空」；
- [`lockCache` 期间推迟 flush 会短暂增大内存] → 求值期本来就短（单文件/单次请求），量一次峰值；
- [过渡期"半新半旧"两套状态并存] → 严格按 D5 顺序、每步都跑基线；新代码只用 ctx；
- [跨 worker 边界] → ctx 不跨线程传（AGENTS §4：channel 只传可序列化纯数据）；worker 内部各自建 ctx。
- [F2/F27 不会自动消失] → 本 change 只清掉"不可收敛/身份漂移"的干扰；若 F2 仍在，按 `returns.md` F2 的
  下一步入口（`addReturnList` 时机 / 依赖边）继续，本 change 让那一步**可做**。

## Migration Plan

按 D5 五步；每步：`--test` 全量 + 目标工程 `--baseline=tmp/scan-154.txt` + 本仓库面板 0。
回退用 git 单点还原；每步结论写进 `项目实践.md`。
