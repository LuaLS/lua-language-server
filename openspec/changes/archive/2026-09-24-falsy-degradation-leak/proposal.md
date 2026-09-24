# Proposal

## Why

真值收窄会给出「另一侧」的值：`rt.narrow(any):matchFalsy()` = `false | nil`（`any.falsy`）。
这在 `and` 链里是**正当的**（该分支下值确实可能为假），但它是**分支内的事实**，
不该被同一表达式的**后续操作数**继承——`A and B and C` 求值 `C` 时 `B` 必然为真。

`and` 的三段式走法（左组 / seed / 右组）本该用 seed 顶掉左侧的假值，
但 seed 的来源 `stack1.otherSide` 在**嵌套左侧**时会漏键：

```lua
-- script/node/tracer.lua  W:traceAnd（traceOr 同）
for k in pairs(stack2.otherSide) do
    if stack1.otherSide[k] then                    -- ← 只合并「两侧都有」的键
        currentStack.otherSide[k] = stack2.otherSide[k] | stack1.otherSide[k]
    end
end
```

`(A and B) and C` 里 A 位置是**嵌套的 `and` 节点**，它的 `otherSide`（「该 and 为真」的事实：
A 与 B 都为真）由上面这条规则算出，而 B 的键只出现在 `stack2.otherSide` 里 → 被丢弃。
于是外层 seed 里没有 `B = truthy`，右操作数 `C` 读 B 时穿透到 `stack1.current` 的
**假值降解**（`false | nil`），字段读取随即报「未定义字段」。

目标工程 `script/plugins/ffi/c-parser/c99.lua:66` 即此形状：

```lua
if not (decl.ids and decl.ids[1] and decl.ids[1].decl) then
```

`decl.ids[1]` 读到 `false | nil` → `66:58` 报 `Undefined field 'decl'`（台账 F5 的下一半）。

## What Changes

`traceAnd` 合并 `otherSide` 时按**方向**区分：另一侧是合取（追踪「`and` 为假」，另一侧 = 「A 且 B 为真」）
时按**并集**取键，使嵌套左侧的真值事实能传到外层 seed；另一侧是析取（追踪「`and` 为真」）时
保持原来的「只并共有键」，否则会增加过度收窄。`traceOr` 的 `otherSide` 本来就是全量合并，不动。

## Capabilities

### New Capabilities

### Modified Capabilities

- `narrowing`: `and` 的「另一侧」事实合并（嵌套操作数不漏键）

## Impact

- `script/node/tracer.lua` 的 `W:traceAnd` 末尾合并循环（1 处）
- 只影响 `and` 节点向外暴露的 `otherSide`（另一分支的事实集合），且只在合取方向；
  不改 `current` 的合并，也不改收窄本身

## 判据（先量后改）

- 基线：目标工程 278 条（`tmp/scan-before-falsy.txt`）
- 目标：净减少且新增项可逐项分诊（预期 `c99.lua:66` 消失；有新增就逐条看）
- 全量 `bin\lua-language-server.exe --test` 必须保持绿

## 试过但未采用（记录，不要重走）

- **一律并集取键**（不分合取 / 析取）：挂 `test/node/tracer.lua:442` —— `if x and y then … else x end`
  的 else 里 `x` 从 `string | nil` 变成 `nil`（析取方向单侧独有的键在另一分支未必成立）。
  该测试的期望语义正确，据此把改动收窄到合取方向
- 在 seed 里把「`stack1.current` 有、`stack1.otherSide` 没有」的键统一置为 `any`（顶掉假值）——
  等价于丢弃事实，`c99.lua:66` 之外会把 `if a and b then` 一族里 `b` 的已知类型抹平，
  治不了根（根因是嵌套左侧的真值事实被丢，而不是 seed 顶得不够宽）
- 在 `W:traceByValue` 里跳过 `truthy` 收窄 —— 上一轮已记录：挂
  `test/coder/narrow-branch.lua:47`（F2 反推依赖该标记）

## 实测结论（2026-09-24，落地保留）

基线：目标工程 278 条（`tmp/scan-before-falsy.txt`）。

| 项 | 结果 |
|---|---|
| 全量 `--test` | 绿（含新增钉：`test/node/tracer.lua` 的 `(A and B) and C` 一例） |
| 目标工程 | 278 → **277**（移除 1 / 新增 0）—— 移除的正是 `c-parser/c99.lua:66:58` 的 `Undefined field 'decl'` |
| 探针（`c-parser/c99.lua:66`） | `decl.ids[1]` 的读值从 `false \| nil` 变成 `truthy`，`decl.ids[1].decl` 为 `any` ✓ |
| 回归能力 | 把 `conjunctive` 强制为 false，钉住的 `x.a.b3` 立刻退回 `false \| nil`（`test/node/tracer.lua:1124`）→ 该钉确实盯着本缺陷 |

- 中途试过「一律并集取键」（不分合取/析取）：挂 `test/node/tracer.lua:442` ——
  `if x and y then … else x end` 的 else 里 `x` 从 `string | nil` 变成 `nil`（析取方向单侧键被误采纳）。
  这条测试是**语义正确的**，据此把改动收窄到合取方向
- 结论：`otherSide` 的键集合按「另一侧是合取 / 析取」区分处理，合取方向补全单侧键；
  与 F10 / F13-B「动态键只标记结构」一致，读值不再继承假值降解
- 遗留（候选，未验证）：`W:traceOr` 的 `current` 合并同样只并共有键，
  在「`or` 为假」的合取方向可能漏键（`if not (A or B or C)` 形状）—— 无目标工程实例，暂不动（已记 F5 遗留）
