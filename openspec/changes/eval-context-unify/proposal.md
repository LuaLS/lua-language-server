# Proposal

## Why

求值期的**环保护**现在有三套并存的写法，边界不清：

| 机制 | 分布 | 语义 |
|---|---|---|
| `visited` / `ctx` | 几乎每个节点类（`node.lua:24`、`union.lua:22`、`variable.lua:20`、`intersection.lua:10`，`table/field/index/call/class/list/function/select/spread/param_of` 各 9…）；已有入口 `ls.node.resolveContext`（`node.lua:607`） | 「**这次遍历**访问过谁」——路径语义 |
| `PROVISIONAL` | 只有 4 个文件（`runtime.lua` 定义、`union.lua:5`、`tracer.lua:4`、`variable.lua:1`） | 「**这个值**还没算完」——值占位（写进 getter 缓存字段） |
| `logOverflow` | `intersection.lua` | 交集/并集互递归的兜底（我们每天都能看到它打日志） |

更关键的是**求值期会发生失效**：`Node.Variable:setCurrentValue` → `flushCache()`、以及 `addRef` 级联，
都可能在一次求值**进行中**把缓存清掉。清缓存会**重建等价节点**（交集/并集每次 `get` 都新造节点），
而 `visited`/占位是**按身份**记录的 ⇒ 环保护失效 ⇒ 本轮实测 **147k 层爆栈**
（`intersection.lua:19`，`classes.md` F25「试过 #2」是同一现象）。

这两轮定位 F2 / F27 时反复撞在同一处：**求值期失效让"同一逻辑节点"换身份**，于是环保护、缓存、
依赖边全都失真。所以先把「求值上下文 + 失效时机」这两条地基统一掉，再谈具体 bug 的修法。

## What Changes

- 统一 `Node.EvalContext`（复用并扩展 `ls.node.resolveContext`）：`{ visited, inProgress, map?, location }`，
  由 runtime 持有**当前求值上下文栈**（ambient），嵌套求值自然继承。
- **求值入口统一 `rt:lockCache()` … `rt:unlockCache()`**：失效推迟到求值结束后的**静默点**批量生效
  （`unlockCache` 本来就会 `flushCacheNow`）。这是不变量「求值期间不做失效」的最省实现。
- 环保护统一到身份键集合：跨节点路径用 `ctx.visited`，同节点重入用 `ctx.inProgress`；
  `PROVISIONAL` 的**语义保留**（未完成态占位、可识别），但逐步从「写进缓存字段」迁到 `ctx.inProgress`。
- **不改 `value` 的签名**（见 design D1）：`value` 仍按节点缓存，ctx 只在求值期可见；
  只有少数确实需要环保护的 getter 读 ambient ctx，必要时用「thin getter → `self:getValue(ctx)`」局部改写。
- 加 debug 断言：求值期不得发生 `flushCacheNow`（防回归）。

## 基线（改前 → 改后）

- 目标工程 `d:\github\vscode-lua\server`：**154 → 154**（本轮是地基重构，不应有行为变化；
  基线 `tmp/scan-154.txt`）
- 全量 `bin\lua-language-server.exe --test` 绿；本仓库问题面板 0
- 附带验收（若顺带生效）：`compile.lua:3043/3044`（F2 的 stale nil）与 F27 族不再出现 —— 单独记数字

## 语义依据

- 环保护需要表达「**谁**在这次求值里」（路径/正在算），这是 `visited`/`inProgress` 的语义强项；
  `PROVISIONAL` 是**值层面**的占位，无法表达路径，且写在缓存字段里会把半成品留下（`tracer.lua` 里
  已经有 `r ~= rt.PROVISIONAL` 这类"识别中间态"的补丁）。
- 「求值期间不失效」的依据是本轮实测：失效与求值交错 ⇒ 身份被重建 ⇒ 147k 爆栈；
  而**首次求值**（同样没有缓存）是单调建立、身份一致 ⇒ 收敛。
- 「只缓存完成态」：占位/中间态一旦进缓存，就会像 F2 的 `Select.value` 那样"早算就定终身"。

## 试过但未采用（有实测，别重走）

1. 在 flush / 依赖边上加力（`addReturnList → flushCache()`、`f:addRef(call)` + 清缓存）：
   批量 **0/0** 或 **147k 层爆栈**（`intersection.lua:19`）—— 清缓存与求值交错 ⇒ 不收敛
2. 只依赖 `intersection` 的 `logOverflow` 兜底：治标（日志刷屏、且爆栈前不保证能兜住）
3. 把 `Select.value` 的 nil 结果「不缓存」：批量 154 → **移除 9 / 新增 34** ✗（取值时机被改变）

## Capabilities

### New Capabilities

- `eval-context`: 求值上下文与失效时机的不变量（求值期不失效 / 只缓存完成态 / 身份稳定 /
  正在算不得再起求值）。这是本仓库内部行为契约，但可用「不再爆栈、值不残缺、诊断稳定」验收。

## Impact

- `script/node/runtime.lua`（EvalContext 栈、lock/unlock 入口）、`script/node/node.lua`（`resolveContext` 扩展）、
  `script/node/intersection.lua` / `union.lua` / `table.lua` / `variable.lua`（接入 ctx、`PROVISIONAL` 迁移）、
  `script/feature/*`（诊断/hover/completion 入口加 lock/unlock）。
- 不涉及 coder / parser / meta；不改 `value` 签名与缓存语义。
