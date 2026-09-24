# Proposal

## Why

用户反馈本仓库有大量警告。要求：**把「自主迭代收尾时清理本仓库警告」写进规则**，并开始清账。

本仓库自扫（`--test project.external-diagnostic --test-project=d:\github\vscode-lua-4\server`）
当时 **514 条 / 129 文件**，分类：

| code | 处 / 文件 | 主要成因 |
|---|---|---|
| `param-type-mismatch` | 214 / 73 | 大半是「实参可能是 `nil`」与注解不符 |
| `undefined-doc-name` | 101 / 11 | `@enum` 名字（`lsp/spec.lua` 67）本分支未实现；`bee.fspath` 一族 19（`3rd/bee.lua/meta` 不在本工程内） |
| `undefined-field` | 98 / 38 | `createNode` / `parseID` 的**字面量名字泛型**没解析成类 |
| `return-type-mismatch` | 59 / 40 | 未逐类 |
| `need-check-nil` | 22 / 13 | 未逐类 |
| `assign-type-mismatch` | 11 / 10 | `providers()` 的泛型赋值 5 处同因 |
| `redundant-parameter` | 6 / 4 | `converter:range(start, finish)`：`---@overload` 的**方法调用参数计数**把 self 算多一个 |
| `lowercase-global` | 3 / 3 | 一个真 bug（遗留调试全局）+ `ls` / `test` 两个刻意全局 |

## What Changes

1. **规则**：`AGENTS.md` 第 0 节新增第 6 条「自主迭代收尾必清本仓库的警告」，第 8 节「清理诊断」
   补上指向；自扫命令、判据（只清 error/warning/information；hint 不管；优先清我们自己的
   bug/缺注解，FP 归家族台账）一并写死。
2. **清账第一批**（本仓库自己的 bug / 缺注解）：
   - `script/node/tracer.lua`：删掉遗留的调试全局赋值 `branch = 'pdata3'`（`lowercase-global`）
   - `script/node/tracer.lua`：`Node.Tracer` 补 `@field scope/map/parentMap/flow/parent/parentStack/walker`
   - `script/runtime/make-args.lua`：补探针开关 `PROBE_FILE/FILTER/FLOW/VAR/CODE` 的声明
   - `test/project/probe.lua`：`show` / `showP` 补 `fun(): any` 形参注解

## Capabilities

### New Capabilities

### Modified Capabilities

（本轮不产生 spec 级行为变更：只补注解、删遗留全局、写规则）

## Impact

- `AGENTS.md`、`项目实践.md`（自扫一节 + 本轮轮次纪要）
- `script/node/tracer.lua`、`script/runtime/make-args.lua`、`test/project/probe.lua`

## 判据（先量后改）

- 自扫基线：514 条 / 129 文件（`tmp/self-scan1.txt` 报告；清账后另存
  `tmp/self-scan-baseline.txt` 供后续轮次 `--baseline` 比对）
- 目标：净减少且不新增；`bin\lua-language-server.exe --test` 全量绿

## 实测结论（2026-09-24）

| 项 | 结果 |
|---|---|
| 自扫总量 | 514 → **508**（`undefined-field` 98 → 93、`lowercase-global` 3 → 2，其余分类不变） |
| 全量 `--test` | 绿 |
| 未动项 | `param-type-mismatch` 214、`undefined-doc-name` 101、`return-type-mismatch` 59 等按上表成因分批，另开轮次 |

## 试过但未采用（记录，不要重走）

- 给 `script/tools/active-pool.lua` 的 `---@class ActivePool`（`local M = {}`，**非 `Class()` 注册**）
  加 `@field nodes LinkedTable` —— 自扫数字**没变**：本分支的类字段模型不认未注册表上的 `@field`。
  要清这类站点得先让类字段模型支持未注册的表，否则白费
- （同轮记录，属下一轮入口，不算未采用）`createNode` / `parseID` 的字面量泛型：
  `local attrName = self:parseID('LuaParser.Node.AttrName', true)` 探针读出 **`true`**（第二个实参），
  `createNode('LuaParser.Node.X', …)` 也拿不到那个类——`undefined-field` 一大簇的根因

## 下一步（按性价比）

1. `@enum` 名字支持（一处清 69 条 `undefined-doc-name`）
2. `createNode` / `parseID` 的字面量名字泛型（清 `undefined-field` 一大簇）
3. `redundant-parameter` 的 `@overload` + 方法调用参数计数（6 条）
