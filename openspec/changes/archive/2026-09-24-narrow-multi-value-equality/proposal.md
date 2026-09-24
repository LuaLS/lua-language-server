# Proposal

## Why

上一轮（`ifguard-assigned-skip`）的结论是「从标记的生产侧入手」。生产侧的第一处就是
`narrowEqual`：**多值类型与单值比较时被判成 `never`**。

```lua
-- script/node/type.lua  M:narrowEqual 的尾部
    local l = self:findValue(kind['value'] | kind['union'])
    if l then return l:narrowEqual(other) end
    return rt.NEVER, self          -- `string == 'doc.field'` 走到这里 ⇒ 相等侧 = never
```

`---@type string` 的 `x` 与 `'a'` 相等，交集就是 `'a'`（TS 的 `x === 'a'` 也收窄成 `'a'`），
不是不可能。返回 `never` 之后它会一路泄漏成读值：

- 目标工程 `script/vm/compiler.lua:346` 的返回表里出现 `type: never`
- `if field.type ~= 'doc.field' … return nil end` 之后读 `field.type` 得到 `never`
- `script/vm/tracer.lua:102` 的 `variable.base.type ~= 'local'` 把 `variable` 收成错成员

联合体侧同一个毛病：`Union:narrowEqual` 的「不等侧」用 `arrayDiff(values, matched)` 算，
而 `matched` 现在包含多值成员（`string`）⇒ 不等侧把 `string` 整块删掉，
`x: string | 'generic'` 上 `x ~= 'a'` 会被收成 `'generic'`。

## What Changes

1. `script/node/type.lua` `M:narrowEqual`：多值类型与**单值**比较、且该单值落在本类型取值域内
   （`other:canCast(self)`）时，相等侧返回那个单值；不相容才返回 `never`。
2. `script/node/union.lua` `M:narrowEqual`：相等侧收集**各成员自己的收窄结果**
   （多值成员收窄成那个单值，不留整个 `string`）；不等侧改成「成员还能取到别的值就保留」，
   只有「恰是该值的单值成员」才排除。
3. `script/node/tracer.lua` `W:traceByValue` 的字段反推：「不等于」方向写回的是
   「字段不等于比较值」的成员集合，成员缺这个字段时（`parser.object | vm.variable` 里
   `parser.object` 没有 `base`）按字段分类不是可靠证据，跳过写回（新增 `isFieldReadable`）。

## Capabilities

### New Capabilities

### Modified Capabilities

- `narrowing`: 判等的相等/不等两侧取值（多值类型与单值比较、联合体的不等侧）

## Impact

- `script/node/type.lua`、`script/node/union.lua`、`script/node/tracer.lua`（3 处）
- 判等收窄的取值会变宽/变准 → 目标工程诊断基线需完整比对与逐项分诊

## 判据（先量后改）

- 基线：目标工程 277 条（上一轮落地后；`tmp/scan-before-falsy.txt` 为 278，含 change #3 的收益）
- 目标：净减少且新增项可逐项分诊
- 全量 `bin\lua-language-server.exe --test` 必须保持绿

## 实测结论（2026-09-24，落地保留）

| 项 | 结果 |
|---|---|
| 全量 `--test` | 绿（新增钉：`test/node/narrow.lua` 的「多值类型与单值比较」3 组 + 联合体不等侧；`test/node/tracer.lua` 的「成员缺字段时 `~=` 反推不写回」） |
| 目标工程（对比 278） | 278 → **276**（移除 2 / 新增 0）：移除 `vm/vm.lua:75:41`（`parser.object \| nil` 的实参误报）+ 上一轮记的 `c99.lua:66`；**本轮净 −1、新增 0** |
| 标记泄漏 | 诊断消息里的 `type: never` 9 处 → 8 处（`vm/compiler.lua:346` 的返回表里 `type: never` 变成 `type: string`） |
| 回归能力 | 去掉 `isFieldReadable` 这层判断，`test/node/tracer.lua` 新增的那条立刻退回 `never` |

## 试过但未采用（记录，不要重走）

- **只在 `union.lua` 的成员分类里改**（`string:narrowEqual('a')` 仍返回 `never`）：
  治不了根——`('generic' | string) == 'doc.field'` 仍走 `#matched == 0 ⇒ (never, self)`，
  `never` 照样作为读值泄漏
- **相等侧整块留下多值成员**（`matched` 存成员本身而不是成员自己的收窄结果）：相等侧会留下整个
  `string`，`node.type == 'global'` 不再把 `node` 收窄成 `vm.global`，
  目标工程新增 `vm/compiler.lua:945/956`、`vm/type.lua:886`（本仓库测得的净值为 +1）
- **`isFieldReadable` 对两个方向都生效**（含相等方向）：目标工程 275（多移除 4 条：`hover/label.lua:36`、
  `tools/lua51.lua:204-206`），但**新增 3 条**——`node.type == 'global'` 那类必要的反推被一起挡掉，
  `node` 不再收窄成 `vm.global`（`node.name` 退回 `'' | parser.object | nil`）→ 值质量回归，不采用
- 「一律并集取键」（`traceAnd` 的 `otherSide`）：见 change #3
- 在 `W:traceByValue` 里跳过 `truthy` 收窄：挂 `test/coder/narrow-branch.lua:47`
