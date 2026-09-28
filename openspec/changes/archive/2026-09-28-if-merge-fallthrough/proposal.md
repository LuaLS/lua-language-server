# Proposal

## Why

目标工程剩余 8 条 `undefined-field` 里的 `script/vm/operator.lua:157`：
`if c.type == 'string' or c.type == 'doc.type.string' then c = vm.declareGlobal(...) end`
之后读 `c.node` 报未定义字段 —— 分支里的赋值把循环变量的值（`parser.object`，有 `node`）顶掉了。
语义上 `if cond then v = X end` 之后 `v` 应当是两条路的并集（`旧值 | X`）。

本轮**只做受控测量**：把三种修法各量一遍，确认净变差后回退，把结论写进台账。

## What Changes

- 无代码改动（三种候选全部回退）。
- 新增最小复现：`test/project/repro/branch-assign-merge.lua`（`---@diagnostic` disable 标记现状）。
- 台账新增 F21（`facts/narrowing.md`）：`if` 分支赋值未与「条件不成立」那条路合并，
  含三种修法的实测数字与两条下次入口。

## Capabilities

### New Capabilities

（无）

### Modified Capabilities

（无 —— 行为未变更，`.openspec.yaml` 用 `skip_specs: true`）

## Impact

- 代码：无（`script/node/tracer.lua` 的改动已回退，目标工程保持 270）。
- 复现/证据：`test/project/repro/branch-assign-merge.lua`、
  `.github/skills/luals-server-dev/references/facts/narrowing.md` F21。

### 试过但未采用（实测数字，基线 270）

| 做法 | 目标工程 | 结论 |
|---|---|---|
| 合并时补上「不走分支」那条路，值取条件反面收窄（`otherSide`），无则取变量在外层的值 | **291**（移除 0 / 新增 21） | 目标那条没修掉（该路 `otherSide` 里 `c` 是 `never`），却把 F15 一族解开 |
| 同上，但该路值优先取外层旧值 | **309**（移除 1 / 新增 40） | 目标那条修掉了，但把 `has_seen` 一族（`if not has_seen then has_seen = {} end`）放宽回去 |
| 同上，且只放宽「分支里真正被赋值」的 id（给 `Stack` 加 `assigned`） | **289**（移除 0 / 新增 19） | 仍净变差 |

语义依据（本仓库自己的语义）：`if cond then v = X end` 之后 `v` 的所有可能取值 =
「走了分支」的 `X` ∪ 「没走分支」的旧值；三种修法都按这条实现，但都会把
「`error` 不是 `never` ⇒ guard 之后真的可能走到」一族（台账 F15）同时解开 ⇒ 需先收敛 F15。
