# Proposal

## Why

目标工程 `script/core/completion/completion.lua:270` 的
`text:sub(lines[firstRow], lastOffset)` 报 `Cannot assign integer | nil to parameter integer`：
`lines[firstRow]` 的键不可静态解析（`firstRow` 是变量）⇒ 走动态键路径，
而那条路的基值取的是**槽位**值（`getCurrentValue()` 会被 flush 清掉，
退回 `getStaticValue()` = 守卫收窄前的 `integer[] | nil`），
于是 `Union:get(unknownkey)` 把「基值可能为 nil」那层 nil 计进了元素类型。

## What Changes

- `script/node/variable.lua` `Variable:getDynamicKeyValue`：取元素前先丢掉基值联合体里
  **恒假**的成员（`nil` / `false`，运行期不能被索引）。元素类型自身含 nil（`(integer|nil)[]`）
  不受影响；基值恒假时保持原样。
- 最小复现落库：`test/project/repro/array-index-nil.lua`。
- 台账新增 F22（含「无 harness 回归钉」的说明）。

## Capabilities

### New Capabilities

- `dynamic-key-read`: 动态键读取（`t[expr]`）的取值语义（按基值求元素）。

### Modified Capabilities

（无）

## Impact

- 代码：`script/node/variable.lua`（`getDynamicKeyValue` + 小助手 `dropFalsyMembers`）。
- 目标工程诊断基线：**270 → 260（移除 10 / 新增 0）**：
  `core/completion/completion.lua:270`、`parser/guide.lua:817`、
  `vm/compiler.lua:758 / 873 / 1345 / 1378 / 1447 / 1485`、`vm/global.lua:74`、`vm/sign.lua:274`
  （都是 `数组[i]` 的读值里掺了「基值可选」那层 nil）。
- `--test` 全量绿；本仓库问题面板 0；复现目录 0 诊断。

### 试过但未采用（实测）

1. 在 `traceRef` 的动态键分支改用**基值的 flow 值**（给 `getDynamicKeyValue` 加 `baseOverride`，
   并用 `nodeID[baseNode]` 找基值的逻辑变量名）—— 动态键子变量是在 `getChild` 里
   **转发到值链上的变量**，其 `parent` 不在 flow 里 ⇒ `baseID = nil`，行为不变（0/0），已回退。
2. 给动态键读登记 `parentMap`（让 walker 走 `deriveFieldValue` 从基值 flow 值派生）——
   需要 coder 侧配合（键非字面量；`parentMap` 的值要保持纯数据以免破坏 worker 边界），
   未做：方案 1 已 0/0 说明这条不是必需。

语义依据（本仓库自己的语义）：`t[expr]` 的读值只在**可索引**的成员上有意义；
恒假成员（`nil` / `false`）运行期索引会报错，它们的元素类型不是「元素类型」的一部分。
基值可能为 nil 这件事，由读点上基值的 flow 值（已收窄）负责。
