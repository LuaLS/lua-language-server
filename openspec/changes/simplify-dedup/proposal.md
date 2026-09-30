# Proposal

## Why

引入求值上下文（change #25）后，值得回头审计「各处自己传 `visited`」还有多少是必要的。
审计结论（30 处 `visited` 站点，逐处看所在函数与用途）：

| 类别 | 站点 | 结论 |
|---|---|---|
| per-eval（跨节点互递归） | `ctx.visited` 家族：`param_of:41`、`select:102`、`spread:137`、`table:578`、`tuple:197`、`union:372`（都是 `resolveGeneric`） | **已经是 ctx**，无需改 |
| per-traversal（每次遍历的环保护） | `simplify(visited)` ×6、`isTableLike(visited)` ×3、`each/every/findValue(..., visited)` ×3 | **不能去掉**：作用域是"这一次调用"，共用会吞掉同一次求值里第二个独立遍历的合法重复访问（`facts/eval-context.md` E2） |
| 各自局部的图去重 | `runtime-helper.lua:9`、`variable.lua:1103/1269/1320`、`union.lua:124` | **不能去掉**：有的就是局部算法（如 `insertValue` 的集合去重） |
| 渲染/调试专用 | `table.lua:706-734`（viewer）、`view.lua`（引用计数）、`tools/inspect.lua` | 另一套机制，不动 |

⇒ 「以前独立的 visited 传递」**绝大部分是必要的**，能被 ctx 取代的只有 `resolveGeneric` 那一类（且已经是 ctx）。
唯一值得整理的是**完全同形的样板**：`simplify` 的 6 处覆盖体（`param_of` / `select` / `spread` /
`subtract` / `ternary` / `variable`）各自复制了一份

```lua
function M:simplify(visited)
    if self.value == self then return self end
    visited = visited or {}
    if visited[self] then return self end
    visited[self] = true
    return self.value:simplify(visited)
end
```

而基类 `Node:simplify`（`node.lua:317`）只是 `return self`（其它类依赖这个默认 ✗ 不能改基类语义）。

## What Changes

- `script/utility.lua` 新增 `ls.util.simplify(node, visited)`（与既有的 `ls.util.visited` 配对）：
  「沿 `.value` 链委派、用 visited 防环」的**唯一实现**。
- 上面 6 处覆盖体改为 `return ls.util.simplify(self, visited)`（保留各自的注解）。
- 不动基类默认、不动其它任何 `visited` 站点；`PROVISIONAL` / ctx / intersection 状态一律不碰。

## 基线（改前 → 改后）

- 目标工程：**154 → 154（removed 2 / added 0）**（基线 `tmp/scan-156.txt`；纯样板收敛，零行为变化）
- 全量 `bin\lua-language-server.exe --test` 绿；本仓库面板 0
- 行数：6 处 × 8 行 → 6 行 + helper ~12 行（净约 **-28 行**）

## 语义依据

- `ls.util.visited` 的语义是「已访问→nil；否则标记并返回集合」⇒ 用 `if not visited then return node end`
  与原先手写的 `if visited[self] then return self end` **等价**（`facts/eval-context.md` E2 的另一半：
  这类守卫是 per-traversal 语义，收编实现但不改作用域）。
- 不动 `Node:simplify` 基类默认：改成"沿 value 委派"会让**其它**依赖默认行为的类（如 `Field`）换语义。

## 试过但未采用（有实测，别重走）

- 把「沿 value 委派」上提到基类 `Node:simplify`：会改变依赖默认 `return self` 的类的行为 ✗（如 `Node.Field`）
- 把这些 `visited` 换成 `ctx.visited`（per-eval 化）：同一次求值里第二个独立遍历会吞掉合法的重复访问 ✗
  （`facts/eval-context.md` E2 已定；`union:each/every` 的 `visited` 还是公开 API 参数）

## Capabilities

### Modified Capabilities

无（纯样板收敛，行为等价；`skip_specs: true`）。

## Impact

- `script/utility.lua`（新增 helper）、6 个 node 文件（覆盖体改成一行）；
- 验收：目标工程 154（0/0）+ 全量 `--test` + 面板 0。
