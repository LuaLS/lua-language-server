# Proposal

## Why

目标工程剩下的 `undefined-field`（10 条）里有两处是同一个成因：
**动态键标记 `unknownkey` 作为「读值的基」时，字段读取被判成 `never`**。

`unknownkey` 是 `t[expr] = v`（键无法在编译期解析）写出来的「结构未知」成员。
`for k in pairs(t)` 遍历这类表时，**键的类型就是 `unknownkey`**，于是：

```lua
for cache in pairs(vm.cacheTracker) do
    if cache.dead then        -- `cache` 的类型是 unknownkey ⇒ 报 Undefined field `dead`
```

`unknownkey` 与 `PROVISIONAL` 是同一类「行为与 any 一致、身份独立」的标记
（两者的 `onCanCast` / `onCanBeCast` 配置一模一样），但 `PROVISIONAL` 挂了
「任意字段 → any」的类（`anykv`），`unknownkey` 没挂 ⇒ 字段读取走 `extendsValue:get`，
落到空的继承表上返回 `never` ✗。

## What Changes

`script/node/runtime.lua`：`self.UNKNOWNKEY:addClass(anykv)`（与 ANY / UNKNOWN / PROVISIONAL / TRUTHY 一致）。
一行，复用运行时既有的「字段不可知」机制，不在 `Type:get` 里加特判。

## Capabilities

### New Capabilities

### Modified Capabilities

- `narrowing`: 动态键标记（`unknownkey`）作为读值时的字段读取语义

## Impact

- `script/node/runtime.lua`（1 行）
- 只影响「读值恰为 `unknownkey`」的字段读取；动态键的写入/读取结构语义（F9/F10/F12）不动

## 判据（先量后改）

- 基线：目标工程 **276** 条（`tmp/scan-round8.txt`）
- 目标：净减少且新增项可逐项分诊；全量 `--test` 保持绿；本仓库面板保持 0

## 实测结论（2026-09-24）

| 项 | 结果 |
|---|---|
| 目标工程 | 276 → **274**（移除 2 / 新增 0）：`service/service.lua:104`（`cache.dead`）、`test/parser_test/perform/init.lua:42`（`path:string()`） |
| 全量 `--test` | 绿（新增钉：`test/node/get.lua` 的「`unknownkey` 自己作为基 → 字段恒 `any`」；去掉这一行该钉立刻退回 `never`） |
| 本仓库面板 | **0**（不变） |

## 试过但未采用（记录，不要重走）

- 在 `script/node/type.lua` 的 `M:get` 里把 `unknownkey` 并进 `any/unknown/truthy` 那一支：
  同样是 276 → 274，但那是「特判」，与运行时既有的 `anykv` 机制重复 ⇒ 改走 `addClass(anykv)`

## 下一步

`undefined-field` 还剩 8 条（`core/diagnostics/missing-return-value.lua:30/31`、
`core/hover/description.lua:263/264`、`parser/compile.lua:3451`、`plugins/ffi/init.lua:88/348`、
`vm/operator.lua:157`），下一个入口是逐条探针定位它们的值来源。
