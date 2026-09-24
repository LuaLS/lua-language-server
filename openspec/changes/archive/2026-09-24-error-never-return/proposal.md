# Proposal

## Why

目标工程 `tools/lua51.lua:201/202/203` 三条 `Need check nil` 的根因是：

```lua
mod, err = findTable(name)
if not mod then
    error('name conflict for module ' .. err)
end
-- 之后 mod._M / mod._NAME / mod._PACKAGE 报 Need check nil
```

`error(...)` 在我们的 meta 和目标工程的 meta 里都没有 `never` 返回标注，
于是这一支不算「终止分支」，`mod` 合并后仍是 `table | nil`（台账 F15，2026-09-23 定位）。

## What Changes

给 `error` 补上 `never` 返回语义，让「以 `error(...)` 结尾的分支」不参与 fall-through 合并。
两个候选做法（详见 design.md）：

- 做法 A（数据层）：在我们的 meta（`meta/whimsical/basic.lua` + 各版本 `basic.lua`）给 `error`
  加 `---@return never`。影响面是所有 `error(...)` 守卫的收窄，量级未知。
- 做法 B（引擎层）：维护一份「永不返回」内建清单（`error`、`os.exit` 之类），不动 meta。
  更 hack，但影响面可控。

本轮先做**受控测量**：两条都量一次（全量 `--test` + 目标工程基线比对），用数字决定采用哪条。

## Capabilities

### New Capabilities

- `narrowing`: 流收窄语义——判等/真值/动态键的收窄规则，以及分支是否参与后续合并的判定

### Modified Capabilities

## Impact

- 做法 A：`meta/whimsical/basic.lua` 与各版本 `meta/*/basic.lua`
- 做法 B：`script/node/tracer.lua`（分支终止判定）与「永不返回」清单的落点（待定）
- 任何 `error(...)` 守卫的收窄都会变 → 目标工程诊断基线可能大幅变动，需完整比对与逐条分诊

## 实测结论（2026-09-24，不采用）

基线：目标工程 278 条（`tmp/scan-before-error-never.txt`）。

| 做法 | 改动 | 目标工程 | 结论 |
|---|---|---|---|
| A（meta 给 `error` 加 `---@return never`） | `meta/template/basic.lua` + `meta/whimsical/basic.lua` | 278 → 278（0 / 0） | **惰性**：分支终止只看 `block.exits`（goto/break/continue）这类语法信息，不看类型 |
| A + B′（tracer 在语句级调用处判「返回 never ⇒ 该分支不落地」） | 上表 + `script/node/tracer.lua`（`traceCallStatement` + `traceIfChild` 保留标记） | 278 → **281**（移除 1 / 新增 4） | **不采用**：净变差；且目标工程自己的 meta 里 `error` 没有 `never`，会盖住我们的注解，`tools/lua51.lua:201-203` 那三条并没修掉 |

- 唯一收益：`core/completion/completion.lua:1645` 一条移除
- 新增 4 条（`parser/compile.lua:1664/1677/1683/4204`）都是「本该非 nil 的值变回 `... | nil`」，属净噪声
- 结论：`error` 这一类「永不返回」判定**先不做**；若将来要做，需要同时解决「目标工程 meta 覆盖 + 先量后改」两件事，
  且先在 `test/` 里钉出终止语义的回归
