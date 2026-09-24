# Design

## `narrowEqual` 的两个返回值

`Node:narrowEqual(other)` 返回 `(narrowed, otherSide)`：

- `narrowed`：`x == other` 成立时 `x` 的取值（相等侧）
- `otherSide`：`x ~= other` 成立时 `x` 的取值（不等侧）

`W:traceByValue` 按 `revert` 决定写哪一侧；`revert` 由 `W:traceConditionUnit` 的
`rev = kind == '~=' and not revert or revert` 之类的规则算出。

## 相等侧：交集

| 自己 | 比较值 | 相等侧 | 依据 |
|---|---|---|---|
| `1 \| 2` | `1` | `1` | 成员按值拆分（原有） |
| `string` | `'a'` | `'a'` | 本类型是多值、比较值是单值，交集就是那个单值（本轮修） |
| `'generic' \| string` | `'doc.field'` | `'doc.field'` | 各成员取自己的收窄结果再并（本轮修） |
| `number` | `'a'` | `never` | 不相容（`other:canCast(self)` 为假） |
| 任意 | 多值（`any` / 同类型变量） | 自己 | 判等得不到信息（F7，原有） |

`type.lua` 的落点：

```lua
    if other:canCast(self) then
        return other, self
    end
    return rt.NEVER, self
```

`union.lua` 的相等侧从「成员整块留下」改成「成员自己的收窄结果」——
否则 `'generic' | string` 与 `'doc.field'` 比较会留下整个 `string`，
`node.type == 'global'` 之类靠反推收窄 `node` 的场景就失去精度（实测新增 3 条诊断，见 proposal）。

## 不等侧：成员还能取到别的值就保留

`x ~= other` 下，成员 `v` 只有在「它只能是 `other` 这个值」时才被排除；
多值成员（`string`）去掉一个字面量后还有别的取值，必须保留：

```lua
        if not (not v:isMultiValue() and v:canCast(other)) then
            rest[#rest+1] = v
        end
```

否则 `x: string | 'generic'` 上 `x ~= 'a'` 会被收成 `'generic'`。

## 字段反推的方向差异

`W:traceByValue` 收窄 `x.field` 之后会顺着 `parentMap` 把结论反推到基值：

```lua
    narrowed, otherSide = pvalue:narrowByField(key, narrowed)
    if revert then self:setNarrowResult(id, otherSide, narrowed)   -- 写「不等于」的成员集合
    else            self:setNarrowResult(id, narrowed, otherSide)  -- 写「能满足」的成员集合
```

- **相等方向**（写 `narrowed` = 能满足比较值的成员）：缺字段的成员本来就被 `narrowByField`
  排除在外，分类可靠 → 照常反推（`node.type == 'global'` 靠它把 for-in 循环变量收窄成 `vm.global`）
- **不等于方向**（写 `otherSide` = 不满足的那些成员）：成员缺字段时「不满足」这个分类
  不是可靠证据（`parser.object | vm.variable` 里 `parser.object` 没有 `base`），
  写回会把基值收成错的成员 → 跳过（`isFieldReadable`）

实测：对两个方向都挡（不区分方向）会多移除 4 条但新增 3 条值质量回归，故只挡「不等于」方向。

## 已排除的替代方案

见 proposal 的「试过但未采用」。
