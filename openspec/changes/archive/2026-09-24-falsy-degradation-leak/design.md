# Design

## 语义：`otherSide` 是什么

`traceAnd` / `traceOr` 内部有两条平行的「事实集合」：

- `current`：本分支（按 `revert` 展开出来的那个真假结果）下成立的事实 → 合并进外层 `current`
- `otherSide`：**另一分支**的事实 → 供外层当 seed 用（`seedOpposite`）

对 `and`：

| 追踪的 `revert` | `current` 含义 | `otherSide` 含义 |
|---|---|---|
| `false`（`and` 为真） | A 真且 B 真 | `and` 为假 = A 假 **或**（A 真且 B 假） |
| `true`（`and` 为假） | `and` 为假 | `and` 为真 = A 真 **且** B 真 |

两种情况都要求 `otherSide` 对两侧的事实做**并集**（不同键各自成立，同键取 `|` 近似）。
原实现只并「两侧都有的键」，在操作数是嵌套的 `and` / `or` 节点时必然漏键：

```lua
-- (A and B) and C，追踪 revert = true
-- 左侧 = 嵌套 and 节点 → stack1.otherSide 由它自己的合并规则算出
-- 其中 A 的键来自内层 stack1.otherSide，B 的键只在内层 stack2.otherSide
-- 「只并两侧都有」→ B 键被丢 → 外层 seed 没有 B = truthy
```

## 落点

`script/node/tracer.lua` 的 `W:traceAnd` 末尾合并处（按方向区分，取种子来源判断）：

```lua
    -- 另一侧是合取（种子取自 stack1.otherSide）时单侧独有的键也要采纳；
    -- 另一侧是析取（种子取自 stack1.current）时只并共有键
    local conjunctive = seedValue == stack1.otherSide
    for k, v in pairs(stack2.otherSide) do
        local s1 = stack1.otherSide[k]
        if s1 then
            currentStack.otherSide[k] = v | s1
        elseif conjunctive then
            currentStack.otherSide[k] = v
        end
    end
    if conjunctive then
        for k, v in pairs(stack1.otherSide) do
            if not stack2.otherSide[k] then
                currentStack.otherSide[k] = v
            end
        end
    end
```

`seedValue` 就是 `traceAnd` 里给 seed 用的那一份（`revert and stack1.otherSide or stack1.current`）；
种子取自 `otherSide` ⇒ 追踪的是「`and` 为假」，另一侧 = 「A 且 B 为真」= 合取。

`W:traceOr` 不动：它的 `otherSide` 本来就是两侧全量合并（`tableMerge`，覆盖式）。

## 为什么不一律并集

一律并集（不分方向）会挂 `test/node/tracer.lua:442`：`if x and y then … else x end` 的 else 里
`x` 从 `string | nil` 变成 `nil`——析取的另一侧（「A 假 或 A 真且 B 假」）下单侧键在另一分支
未必成立，采纳它就是过度收窄。该测试的期望是语义正确的（`else` 里 `x` 确实可能是 `string`），
所以改动必须区分方向。

## 为什么不改 seed 一侧

seed 只做「把左侧的某侧事实垫在右操作数下面」，它**没有**事实可垫时就只能穿透到
`stack1.current`（假值降解）。真正的修点是把事实补齐（上游），而不是在 seed 里
把缺的键一律置 `any`（那会连带抹掉右操作数自己的已知类型）。

## 影响面与风险

- 只改 `otherSide` 的**键集合**（合取方向多了「一侧独有」的键），不改任何 `current`
- 可能影响：`and` 之后（以及嵌套内）对外暴露的「另一分支」事实 →
  收窄测试（`test/node/tracer.lua` 的 and/or 段）与目标工程数字需逐项比对
- 不做「同名键冲突」的特殊处理：同键仍按 `|` 近似，与原有行为一致

## 已排除的替代方案

见 proposal 的「试过但未采用」。
