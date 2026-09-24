# Proposal

## Why

`truthy` 是**收窄用的标记类型**（「该值满足真值」），它不携带成员集。作为读值暴露时会引发误报：
读它的字段必然报「未定义字段」；当作实参/返回值也会与签名不匹配。

目标工程 `plugins/ffi/c-parser/c99.lua:66` 即此形状：

```lua
if not (decl.ids and decl.ids[1] and decl.ids[1].decl) then
```

`decl.ids[1]` 被真值收窄成 `truthy`，随后 `.decl` 报未定义字段（台账 F5）。

## What Changes

标记**留在 flow 里**（不动收窄本身），只在**读取它的字段**时按 `any` 处理：
`truthy` 的字段读取返回 `any`（与 `any` / `unknown` 一致），不再返回「不存在」。

`truthy` 的类型转换本就近似 `any`（`onCanCast` 为 `other.truthy ~= never`），
所以参数/赋值侧不需要动，问题只在字段存在性判定。

## Capabilities

### New Capabilities

### Modified Capabilities

- `narrowing`: 真假标记 `truthy` 作为读值时的字段读取语义

## Impact

- `script/node/type.lua` 的 `M:get`（1 行）
- 只影响「读值恰为纯 `truthy`」的字段读取；不影响真值收窄与 F2 的反推

## 判据（先量后改）

- 基线：目标工程 278 条（`tmp/scan-before-truthy.txt`）
- 目标：净减少且新增项可逐项分诊（预计 `c99.lua:66` 移除；有新增就逐条看）
- 全量 `bin\lua-language-server.exe --test` 必须保持绿

## 试过未采用（记录，不要重走）

在 `W:traceByValue` 里跳过 `any` / `unknown` 的真值收窄 —— 会挂
`test/coder/narrow-branch.lua:47`：那个标记是 F2 反推里「确定非 nil」的证据
（`if not args or not other then return end` 之后靠它去掉反推结果里的 nil）。
所以标记必须留在 flow 里，修点只能在消费侧。

## 实测结论（2026-09-24，落地保留）

基线：目标工程 278 条（`tmp/scan-before-truthy.txt`）。

| 项 | 结果 |
|---|---|
| 全量 `--test` | 绿（含新增钉：`test/node/truthy.lua` 的「`truthy` 读字段 → `any`」） |
| 目标工程 | 278 → 278（移除 0 / 新增 0）——**读数变了但诊断没动** |
| 探针（`c-parser/c99.lua:66`） | `decl.ids[1].decl` 已从「未定义」变成 `any` ✓；但外层那条 FP 来自 `decl.ids[1]` 被写成 `false \| nil`（真值收窄的 **falsy 降解**），是另一处缺陷 |

- 结论：这一行**语义正确**（标记无成员集，读它字段恒 `any`），保留并作为 spec 增量落地；
  但目标工程那条 `c99.lua:66` 需要先修 falsy 降解那一半，另开一轮
- 下一步（新 change）：`any` 的 `.falsy`（`false | nil`）不该污染**非 falsy 位置**的读值
  （`if A and B and C` 链里，后面的操作数不应继承前面的 falsy）
