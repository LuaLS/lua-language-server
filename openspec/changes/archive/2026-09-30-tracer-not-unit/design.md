# Design

背景与动机见 `proposal.md`；行为契约见 `specs/narrowing/spec.md`；相关事实见 `facts/narrowing.md` F4 / F27。

## Context

- coder 侧：`script/vm/coder/exp.lua` 的 unary provider 对 `not` 调
  `coder:getTracer():openNode('not')`，把 `not <exp>` 包成一个 flow 节点；
- walker 侧：`script/node/tracer.lua` 的 `W:traceUnit` 按 `unit[1]` 分派，
  已有 `and` / `or` 分支（遍历内部 unit，让内部 ref 拿到 `currentValue`），**没有 `'not'`**；
- 条件位置走的是另一条路（`W:traceCondition` → `W:traceConditionUnit` 的 `'not'` 分支，
  负责 `not` 的真值反相），与本改动互不影响。

实测的 flow 形状（`--probe-flow`，目标工程 `plugins/astHelper.lua` 的 `addClassDocAtParam`）：

```lua
{ "if", {
    "return",
    { "condition", { "ref", "arg@70:11", "var:arg@71:8-71:10" } },
    { "not", { "not",
        { "ref", "_M@3:7", ... },
        { "ref", "arg@70:11", "var:arg@72:44-72:46" },   -- ← 实参读，从没被走
        ...
        { "call", "call@72:24-72:58", ... },
    } },
    { "ref", "arg@70:11", "var:arg@72:61-72:63" },       -- ← 返回值读，正常收窄
} }
```

## Goals / Non-Goals

**Goals**：值位置 `not` 的子树的读取点被走一遍，读值不再退化成兜底值。

**Non-Goals**：不给值位置 `not` 加真值收窄；不改条件位置 `not` 的既有语义；
不涉及 F27 的 flush 路径。

## Decisions

### D1 复用 `and`/`or` 的既有分支，而不是新写一套

`W:traceUnit` 里 `'and' or 'or'` 分支的写法（遍历 `unit[2..]`，对 table 元素递归 `traceUnit`）
正是本场景需要的：只求「让内部 ref 得到 `currentValue`」，不求收窄。
把条件从 `tag == 'and' or tag == 'or'` 扩成 `... or tag == 'not'` 即可，
注释一并说明「值位置不做真值收窄」。

- 备选（未采用）：在 `openNode('not')` 时不生成 flow 节点 —— 会丢掉条件位置的既有能力，
  且 coder 分不清「值位置 / 条件位置」。
- 备选（未采用）：在 `explore`/provider 侧修 —— 治标，且其它读值通路（hover / completion）同样陈旧。

## Risks / Trade-offs

- [给 `not` 的操作数引入额外读取] → 只是走一遍既有 ref、写 `currentValue`，不做收窄；
  目标工程实测：移除 2 / 新增 0（`tmp/cmp-not-unit2.txt`），扫描耗时 10.41s（无回归）。
- [与条件位置 `not` 混淆] → 两条路不同：条件位置由 `traceCondition` 处理，
  `traceUnit` 只处理值位置的裸 `not` 节点；用例里对条件 `if not v then` 的既有断言不动。
- [测试覆盖不足] → `test/node/tracer.lua` 的用例已实测「撤掉修法立刻红」
  （`expected: integer, actual: integer | nil`）。

## Migration Plan

1. 已存基线 `tmp/scan-156.txt`（156，含上一轮的 F27 修法）。
2. 改 `W:traceUnit` → 加用例 → `--test node.tracer` → 目标工程比对（→ 154）→ 全量 `--test` → 面板。
3. 收尾：facts 记一条（与 F4/F27 区分），归档 change，更新 `项目实践.md`。
