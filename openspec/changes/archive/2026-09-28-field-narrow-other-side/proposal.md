# Proposal

## Why

目标工程 `script/core/completion/completion.lua:1365`（`vm.getDefs(src.node)`）报
`Cannot assign parser.object | nil to parameter parser.object`，且 `src` 在一串
`elseif src.type == '...'` 的第 4 个分支里被收窄成 `never`。

成因：**字段判等收窄的「另一侧」**（`x.field ≠ 值`）用了 `narrowed` 的**补集** ——
`field` 是多值（`string`）的成员本来还能取到别的取值，却被整块排除 ⇒ 每个 `elseif`
再丢一批 ⇒ 分支里 `src` = `never`（`never` 的字段读退回注解并集、带 nil ⇒ 形参误报）。
这与 F18（`narrowEqual` 的不等侧）是同一条语义，只是没落到**字段**判等上。

## What Changes

- `script/node/union.lua` `Union:narrowByField`：另一侧（字段 ≠ 值）不再整块取补集 ——
  ①「没有该字段」的成员保留（F18 已定）；②「字段是多值（`string` / `any` 一类）因而还能取到
  别的取值」的成员也保留；只有「字段恰是该值」（单值且互相可转）的成员才排除。
  真值测试 `if x.field then` 传进来的「比较值」是**字段自己的类型** ⇒ 那种情况仍按
  `canEqual` 互补（行为不变）。
- 更新 `test/node/narrow.lua` 里两条记录旧补集行为的断言（多值成员 / `any` 成员在另一侧保留）。
- 复现落库：`test/project/repro/or-falsy-drop-member.lua`（已修）、
  `test/project/repro/union-missing-field.lua`（残留，见下）。
- 台账新增 F23（成立）、F24（未满足）。

## Capabilities

### Modified Capabilities

- `narrowing`: 字段判等收窄的「另一侧」成员判定（F18 的字段版）。

## Impact

- 代码：`script/node/union.lua`（`narrowByField`）。
- 目标工程诊断基线：**260 → 259（移除 1 / 新增 0）**：`vm/compiler.lua:269`。
- `--test` 全量绿（含更新后的 `test/node/narrow.lua` 断言）；本仓库问题面板 0；复现目录 0 诊断
  （`union-missing-field.lua` 那条是**已知未满足**，文件里以 `---@diagnostic` 标注）。

### 试过但未采用（实测）

先把真值测试单独按 `TRUTHY` / `FALSY` 标记 gate（那种情况保持互补）——
探针显示真值测试传进来的「比较值」不是标记，而是**字段自己的类型**
（`[nbf] key=uri value=uri kind=union`）⇒ gate 不生效，目标 260 → 260（移除 1 / 新增 1：
多出 `parser/guide.lua:488` 的 `Cannot assign { uri: uri } | parser.object to parameter parser.object`）。
改成「比较值是**单值**时才允许整块取补集」⇒ 260 → 259（移除 1 / 新增 0）。
