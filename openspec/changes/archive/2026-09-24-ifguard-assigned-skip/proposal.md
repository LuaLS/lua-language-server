# Proposal

## Why

`traceIf` 合并分支时，对**终止分支**（`return` / `goto` / `break` / `continue` 结尾）会把它
`otherSide`（「该分支不成立」的事实，即 guard 收窄结果）里的每个键都并成一条合成流。
这个机制是 F1/F2 的 guard 收窄所必需（`if not x then return end` 之后 `x` 要非 nil），
但它**不看存活分支是否已经给同一个键赋了值**：

```lua
---@return string?
function vm.getString(v)
    local result
    for n in node:eachObject() do
        if n.type == 'string' then
            if result then          -- 分支以 return 结尾
                return nil
            else
                result = n[1]       -- 存活分支给 result 赋了值
            end
        elseif … then
            return nil
        end
    end
    return result                    -- ← 读值是 `false | parser.object | any | nil`
end
```

`result` 的假值事实（`any.falsy` = `false | nil`）跟存活分支的赋值并在一起，
把**标记**（`false`）混成了读值。目标工程 `script/vm/value.lua:176/200/223` 的
`return-type-mismatch` 里那三个 `false` 即此。

## What Changes

`W:traceIf` 里：先收集存活分支的结果（含它们的 `changed`），再把终止分支的 `otherSide`
并进来；**已被存活分支赋值的键跳过**（以赋值为准，终止分支的假值事实不再参与）。

`otherSide` 语义与方向判定见 `design.md`。

## Capabilities

### New Capabilities

### Modified Capabilities

- `narrowing`: `traceIf` 终止分支 guard 事实的合并范围

## Impact

- `script/node/tracer.lua` 的 `W:traceIf`（一个循环拆成两段）
- 影响所有「终止分支 + 存活分支对同一变量赋值」的 if，量级未知 → 先做受控测量

## 判据（先量后改）

- 基线：目标工程 277 条（上一轮落地的 `tmp/scan-before-falsy.txt` 为 278，本轮在 277 上量）
- 目标：净减少或至少持平，且新增项可逐项分诊
- 全量 `bin\lua-language-server.exe --test` 必须保持绿

## 实测结论（2026-09-24，不采用）

| 项 | 结果 |
|---|---|
| 全量 `--test` | 绿 |
| 目标工程（对比 `tmp/scan-before-falsy.txt` 的 278） | 278 → **279**（移除 1 / 新增 2）；那 1 条移除是上一轮的 `c99.lua:66`，即**本轮净 +2、零移除** |
| 收益 | `vm/value.lua:176/200/223` 的读值从 `false \| parser.object \| any \| nil` 变成 `parser.object \| any \| nil`（`false` 消失），但那条诊断**没消失**（`parser.object` 仍不可 cast 到 `string`） |
| 代价 | 新增 `script/vm/type.lua:529:42`、`562:60`（`Cannot assign 'table \| nil' to parameter 'table'`）——`mark` 的 `mark = mark or {}` 收窄丢失，读值退回注解的 `table?` |
| 探针复核 | `vm/type.lua` 里 `var:mark@486/529/562` 变成 `table \| nil`，且 `var:uri@396`、`var:errs@394/397/398/399`、`var:n@493`、`var:child@498`、`field@399`、`unary@397/398/399` 一并变成 **`never`**（读值污染，与 F3/F7 同族）→ 明显是值质量回归，不是「暴露老问题」 |
| 处理 | 已全部回退（`git checkout -- script/node/tracer.lua`），目标工程回到 277 |

`never` 那一簇的机制未查清（`rt.union` 收到含 nil 空洞的列表时会走 `#nodes == 0 ⇒ NEVER` 这条路，
合成流被移除后某个 `changed` 键在存活分支里取不到值就会踩到），
所以**不带着不确定的污染面落地**。

## 试过但未采用（记录，不要重走）

- 本轮这条：`traceIf` 合并终止分支 guard 事实时跳过「存活分支已赋值的键」→ 净 +2、零移除，且引发
  `never` 读值污染（上表）。要重走必须先查清 `never` 簇的机制
- 「一律并集取键」（`traceAnd` 的 `otherSide` 不分合取/析取）：见 change #3，挂
  `test/node/tracer.lua:442`
- 在 `W:traceByValue` 里跳过 `truthy` 收窄：挂 `test/coder/narrow-branch.lua:47`

## 下一步（另开一轮）

`false`/`never`/`truthy` 这类**标记泄漏成读值**的家族还有多处（`parser/compile.lua:2263` 一族里
`type: never`、`args: { [1]: never }`；`vm/function.lua:444`、`vm/global.lua:74`、`utility.lua:857`、
`vm/compiler.lua:346` 的 `type: never`），下一轮应从**标记的生产侧**（`narrowEqual` / `narrowByField`
写出 `false|nil` / `never` 的地方）入手，而不是在合并处打补丁。
