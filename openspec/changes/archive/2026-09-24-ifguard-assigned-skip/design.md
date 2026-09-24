# Design

## `otherSide` 的语义（本次依赖的前提）

`traceAnd` / `traceOr` / `traceByValue` 都往当前栈写两份事实：

- `current`：被追踪的那个真假方向下成立的事实
- `otherSide`：**相反方向**下成立的事实

`traceIfChild` 对每个分支 `traceCondition(branchCondition)`（`revert` 缺省），
所以分支栈的 `current` = 该分支成立时的事实，`otherSide` = 该分支不成立时的事实。
`traceIf` 于是把**终止分支的 `otherSide`** 当作「fall-through 路径上的事实」并进 if 之后的流
（F1 的 guard 收窄：`if not x then return end` 之后 `x` 非 nil）。

## 问题

那条 `otherSide` 是在**分支体跑完之后**读的，所以除了分支自己的条件事实，还可能带上
分支体内嵌套收窄写入的键。存活分支已经给某个键赋值时，再并进「该键为假」的事实，
就得到 `false | 赋值` 这种带标记的读值（`vm/value.lua:176` 的 `false | parser.object | any | nil`）。

## 本轮做法

1. 遍历分支：`terminated` 的先把 `otherSide` 存进 `guards`；其余进 `stacks` 并累加 `changed`
2. 用非终止分支的 `changed` 建 `assigned`
3. 再把 `guards` 里的键按 `not assigned` 补成合成流

## 实测结果（不采用）

- 目标工程 278 → 279（移除 1 = 上一轮的 c99、新增 2：`vm/type.lua:529/562`）
- 探针：`vm/type.lua` 的 `mark`（`mark = mark or {}`）收窄丢失，读值退回 `table?`；
  另有 `var:uri@396`、`var:errs@394/397/398/399`、`var:n@493`、`var:child@498` 等一簇变成 `never`
- 机制未查清：`W:traceIf` 末尾的
  ```lua
  local union = {}
  for _, stack in ipairs(stacks) do
      local value = stack.current[id]
      union[#union+1] = value          -- value 为 nil 时数组出现空洞
  end
  local value = rt.union(union)         -- rt.union 在 #nodes == 0 时返回 NEVER
  ```
  合成流被移除后，某个 `changed` 键在存活分支的 `current` 里取不到值时就会踩到这条路径
  （`rt.union` 见 `script/node/runtime.lua:243`）

## 结论

改动方向（以存活分支的赋值为准）在语义上是对的，但落地代价（`never` 污染面）不明，
且没有换来任何目标工程条目移除 → 回退，记入台账。

## 将来重走的前置条件

1. 先查清 `never` 那一簇是怎么产生的（是 `rt.union` 的空洞，还是 `changed` 键在存活分支缺值）
2. 或者在**标记的生产侧**（`narrowEqual` / `narrowByField` 写出 `false | nil` / `never` 的地方）
   先做到「标记不进读值」，那样合并处的补丁就不需要了
