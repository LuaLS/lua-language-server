# Proposal

## Why

`Node.Variable.currentValue`（walker 写回的收窄值）是 **getter 字段**，`rt:flushCacheNow()`（`class.flush`）
会清掉它；而 `Node.Tracer.Walker:start` 的 `started` 守卫让每个 walker **一生只走一次**
⇒ flush 之后同一读取点不再重算，`Node.Variable.__getter.value` 落到 `getStaticValue()` / `getGuessValue()`
兜底，读值退化成**未收窄**的类型。

用户看到的症状就是这一类：目标工程 `script/parser/compile.lua:459` 报
`param-type-mismatch`「Cannot assign `integer | nil` to parameter `integer`」，
而代码本身有 `if nestOffset and nestOffset < finishOffset then` 守卫（语义判断：写法没问题）。

证据（详见 `facts/narrowing.md` F27）：

- 探针：该读点 view = `integer`（dump 时 walker 才首次走）
- 插桩 `param-type-mismatch`：`rawKind=variable tracer=true cv=nil value=select view=integer | nil`
  （有 tracer，但 `currentValue` 为 nil；`.value` 退化到静态值 —— `local nestOffset = sfind(...)`
  被编译成 `rt.select(call, 1)` ⇒ `integer | nil`）
- 插桩 `W:traceRef`：walker 确实算出过 `integer` 并写回，说明**值后来被清掉了**

规模：199 条里 `param-type-mismatch` 有 **15 条**属这一类（实参是「有 tracer 但 `currentValue` 为 nil」的变量）。
F19 的 29 条 `need-check-nil` 症状同形（「退回未收窄的 guess」），很可能同根因。

## What Changes

- **在诊断 pass 边界（求值链之外）作废一次 walker**：`ls.feature.diagnostic(uri)` 拿到 vfile 后，
  遍历该文件 coder 的 tracer 节点逐个 `restart()`，让本 pass 后续的读取自然重算收窄值。
- `Node.Tracer:restart()` / `W:restart()`：作废已有 walk 结果（只清 `started`），
  复用同一 walker 实例；`hasWalker` 普通字段记录「建过 walker 没」（不建多余对象）。
- `W:start` 加 `walking` 护栏（同一 walker 不重入）+ 异常清理（不留 `walking`/`started`）。
- 不动 `class.flush` 语义：收窄值仍是临时缓存、仍会被清，只是清完能重算。

## 基线（改前 → 改后）

- 目标工程 `d:\github\vscode-lua\server`：**199 → 156（移除 36 / 新增 0）**（已达成）
  （基线 `tmp/scan-199.txt`，比对 `tmp/cmp-final3.txt`；扫描耗时 10.3s → 10.56s，无回归）
- 实际移除比预估的 15 条多 21 条：**F19 那一族也被带掉**（`parser/compile.lua` 的
  `child.start/finish/parent` 等 `need-check-nil`，`3043/3044/3048/3051/3052/3053/3112/3113/…`），
  与 F19「读值退回未收窄的 guess」同根因的判断一致。

## 语义依据

- 收窄是**临时缓存**：它由 flow + 其它节点的值算出，所以 flush 时清掉是对的；
  但「清掉之后不再重算」不是语义，是缺陷 —— 读取方（诊断/悬停/补全）拿到的是**未收窄**的值。
- 本仓库自己的事实：`facts/narrowing.md` F27（本轮记录）、F19（症状同形）。
- 复现条件：真实工程（中途发生 flush）才触发；把结构抄进 `tmp/repro-nest/` 的独立文件**不报**
  ⇒ 纯收窄逻辑没问题，问题在缓存失效路径。

## 试过但未采用（有实测，别重走）

1. **去掉 `started` 守卫**（无条件重走）：`C stack overflow`（`variable.lua:1180`）——
   walk 里重入，栈深 ~21k。
2. **flush 时作废 walker**（`Node.Tracer:invalidateWalker` + `runtime.lua` 的 `flushOne` 钩子 +
   `_walker` 持久化 + `walkingDepth` 只在顶层重走）：仍 `C stack overflow`
   （`variable.lua:1038` / `table.lua:97`）；**把钩子改成 no-op 也照样爆**
   ⇒ 爆栈不是作废时机单点问题，而是「重走被允许后嵌套链变深」（实测健康路径 maxDepth 只有 10）。
3. **让 `currentValue` 不被 flush**（删 `M.__getter.currentValue` 声明）：
   `intersection.lua:19 stack overflow`（getter 字段声明删掉后 class 机制本身失效）。
4. **惰性嗅探 + 在 `value` getter 里按需 `retrace`**（实现了完整一版，已回退）：
   护栏生效（`walkDebug`：walks=1000 / nested=125 / **maxDepth=10**），但仍 `C stack overflow`
   （`table.lua:97`，`skipping 1981 levels`）—— 这次爆的是**求值环**
   （`__getter.value` → `mergeValueResults` → `Table:addChilds` → … 回到 `__getter.value`）：
   在 getter 里重走会把本该命中缓存的求值环「重新喂活」。**采纳的版本改到 pass 边界触发**，
   每个 tracer 每 pass 至多重走一次 ⇒ 实证不爆栈（本条是本轮的关键教训）。
5. **目标侧绕行**（给 15 处读点加 `--[[@as ...]]`）：治标、且是拿 cast 迎合实现，不采用。

## 状态

**已落地**：`script/node/tracer.lua`（`restart`/`hasWalker`/`walking` 护栏）、
`script/feature/diagnostic/init.lua`（pass 边界作废）、`test/node/tracer.lua`（两个用例：
flush 后 restart 能重算 / 不 restart 则退化成 `integer | nil`）。
目标工程 199 → 156、全量 `--test` 绿、本仓库面板 0。

## Capabilities

### Modified Capabilities

- `narrowing`: 新增要求 —— 收窄值被 flush 清掉后，读取处 SHALL 能在非嵌套时机触发重算，
  使读值不退化到未收窄的静态/猜测值。

## Impact

- `script/node/tracer.lua`：`W:start` 的 `started`/`walking`/`walkingDepth`、`Node.Tracer` 的按需重走入口。
- `script/node/variable.lua`：`setCurrentValue` 标记「这里写过收窄值」、`__getter.value` 检测并触发重算。
- 诊断 / 悬停等消费者不变（它们读 `Node.Variable.value`，修好之后自然是收窄值）。
- 测试：`test/node/tracer.lua`（收窄值在 flush 后的重算）；目标工程基线 199 → 184。
