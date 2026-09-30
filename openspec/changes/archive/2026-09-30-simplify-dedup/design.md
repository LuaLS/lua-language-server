# Design

动机（审计表）与「试过未采用」见 `proposal.md`；相关事实：`facts/eval-context.md` E2。

## Context

`visited` 共 30 处站点（审计见 proposal）：per-eval 那类**已经是 ctx**；per-traversal 那类**必须留**；
唯一可整理的是 6 处**完全同形**的 `simplify` 覆盖体。

## Goals / Non-Goals

**Goals**：把「沿 `.value` 链委派 + visited 防环」收敛成一份实现，零行为变化。

**Non-Goals**：不动基类默认 `Node:simplify`；不动任何 per-traversal 的 `visited` 作用域；
不碰 ctx / `PROVISIONAL` / `intersection` 状态（那是 #25 的成果）。

## Decisions

### D1 放 `ls.util.simplify`，与既有 `ls.util.visited` 配对

```lua
--- 沿 `.value` 链委派简化，并用 visited 防环（per-traversal 语义，与 `m.visited` 配对）
---@param node Node
---@param visited? table<Node, true>
---@return Node
function m.simplify(node, visited)
    if node.value == node then
        return node
    end
    visited = m.visited(node, visited)
    if not visited then
        return node
    end
    return node.value:simplify(visited)
end
```

6 处覆盖体改成 `return ls.util.simplify(self, visited)`（保留各自的 `---@param` / `---@return`）。

- 备选（未采用）：上提到基类 `Node:simplify` —— 会改变依赖默认 `return self` 的类（如 `Node.Field`）✗。
- 备选（未采用）：换成 `ctx.visited` —— 把 per-traversal 变成 per-eval，吞掉合法重复访问 ✗（E2）。

### D2 只做这一处；其余站点保持原样并在台账里标明理由

审计里其余类别（局部图去重 / 渲染 / 调试）各自作用域自足，收编只会增加间接层 ✗ ⇒ 不动。
`facts/eval-context.md` E2 已记录分类，本轮不重复造台账条目，只在 `项目实践.md` 记一句。

## Risks / Trade-offs

- [helper 的 `node.value` 为 nil 时报错] → 与现覆盖体风险相同（只在 `value` 恒非 nil 的那 6 个类上调用）；
  若以后有类想复用而 `value` 可能为 nil，调用前自行判空。
- [行为变化] → 逐处对照：手写体是「`value==self` → `visited or {}` → 已访问返回 self → 标记 → 委派」，
  helper 用 `m.visited` 的「已访问→nil」等价表达 ⇒ 零变化；由目标工程 154（0/0）+ 全量 `--test` 兜底。

## Migration Plan

1. 加 helper → 2. 改 6 处 → 3. `--test` 全量 + 目标工程 `--baseline=tmp/scan-156.txt` + 面板 0
→ 4. 归档 + `项目实践.md` 一句。
