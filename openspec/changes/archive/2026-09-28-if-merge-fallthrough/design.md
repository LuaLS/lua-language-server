# Design

## 诊断

`W:traceIf`（`script/node/tracer.lua`）的合并循环：

```lua
for id in pairs(changed) do
    local union = {}
    for _, stack in ipairs(stacks) do
        local value = stack.current[id]
        union[#union+1] = value
    end
    local value = rt.union(union)
    self:setValue(id, value, true)
end
```

`stacks` 里只有**各分支**的栈（终止分支只贡献 `otherSide`）。没有 else 时，
「所有条件都不成立」这条路的取值没有对应的栈，于是当某个 id 只被分支赋值过，
合并结果就只剩分支里的值 —— 旧值丢失。

最小复现（`test/project/repro/branch-assign-merge.lua`）：

```lua
---@param v reproP          -- reproP: { a: integer? }
local function f(v)
    local c = v
    if c.a then
        c = G                -- reproQ: { b: integer }
    end
    return c.a               -- 现状：报 undefined-field `a`（c 只剩 reproQ）
end
```

目标工程同族（`script/vm/operator.lua:157`）：基值诊断期打印为类 `vm.global`。

## 三种候选（均已回退）

1. 该路的值 = `lastStack.otherSide[id]`（条件反面的收窄），无则用 `W:getOuterValue`
   （收窄栈 → 变量注解值）。
   - 结果：目标 291（移除 0 / 新增 21）。目标那条没修掉：那条路的 `otherSide` 里
     `c` 是 `never`（不健全的收窄），并进并集等于没加。
2. 该路的值 = 外层旧值（不用 `otherSide`）。
   - 结果：目标 309（移除 1 / 新增 40）。目标那条修掉了，但 `if not has_seen then has_seen = {} end`
     之后 `has_seen` 又被并入 `nil`，多出 `need-check-nil`。
3. 在 1 的基础上，只对**分支里真正被赋值**的 id 放宽（给 `Stack` 加 `assigned`，
   与「只被收窄」区分）。
   - 结果：目标 289（移除 0 / 新增 19）。仍净变差。

## 为什么回退

三种候选都是「按语义修对了」，但会把 **F15 一族**（`error` 没有 `never` 返回语义 ⇒
guard 之后那条路真的可能走到）同时解开：新增的 19～40 条几乎都落在
`need-check-nil` / `param-type-mismatch` 上，且都是目标工程注解层面「确实可能为 nil」的形状。
F15 的收敛方向在 2026-09-24 单独做过受控测量（`--return never` 0/0；
tracer 侧 `traceCallStatement` 278 → 281）也是净变差。

⇒ 两者必须一起做：先让「语句级调用返回 `never` ⇒ 分支终止」成立，再让
`if` 合并补上「条件不成立」那条路，否则每修一边都会把另一边的低估暴露出来。

## 下次入口（写进台账 F21）

- `otherSide` 里可能存着 `never`（`---@field a integer` + `if v.a then` 的反面 = `never`：
  那条路语义上确实不可能；但目标工程 `operator.lua` 那条条件的反面法上不该是 `never`）
  ⇒ 「按字段判等收窄基值」仍有不健全的分支。
- 同一次调试里 `sval.view()` 抛过 `view.lua:61: table index is nil`，换时序又正常
  ⇒ 与 F19 / `returns.md` F2 的「同一节点不同时机取值不同」同族。
