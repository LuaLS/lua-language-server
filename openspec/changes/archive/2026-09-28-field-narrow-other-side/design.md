# Design

## 诊断

`Union:narrowByField(key, value)`（`script/node/union.lua`）把成员分成两侧：

```lua
        if myValue:canCast(value)
        or (not value:isMultiValue() and value:canCast(myValue)) then
            result[#result+1] = v      -- narrowed（字段可能相等）
        else
            others[#others+1] = v      -- 另一侧（字段 ≠ 值）
        end
```

`others` 是 `result` 的**补集** ⇒ 字段是多值（`string`）的成员被判成「可能相等」而进入
`result`，同时被另一侧**整块排除** ✗。但「字段可能相等」不等于「字段只能是该值」：
`string` 去掉一个字面量后仍有别的取值 ⇒ 这些成员在「字段 ≠ 值」这一侧**必须保留** ✗。

一串 `elseif src.type == '...'` 会把这个损失累积：每个分支的假分支再丢一批 ⇒
目标工程 `completion.lua:1365` 的 `src` = `never`。

F18（`narrowEqual` 的不等侧）已经定过同一条语义（「多值成员去掉一个字面量后还有别的取值，
不能整块排除」），只是没落到**字段**判等上。

## 修法

```lua
        local canEqual = myValue:canCast(value)
            or (not value:isMultiValue() and value:canCast(myValue))
        if canEqual then
            result[#result+1] = v
        end
        -- 另一侧（字段 ≠ 值）：
        -- ① 与多值/非字面量比较（真值测试传进来的就是字段自己的类型）时按 canEqual 互补；
        -- ② 与单值比较时不能整块取补集：多值字段的成员仍要留下，
        --    只有「字段恰是该值」（单值且互相可转）的成员才排除
        local excludeFromOtherSide = canEqual
            and (value:isMultiValue()
                or (not myValue:isMultiValue() and value:canCast(myValue)))
        if not excludeFromOtherSide then
            others[#others+1] = v
        end
```

关键点：**真值测试与字面量比较要分开**。真值测试 (`if x.field then`) 的调用方传进来的
`value` 不是 `TRUTHY` / `FALSY` 标记，而是**字段自己的类型**（探针：`key=uri value=uri kind=union`），
所以判据只能是「比较值是不是单值」。

## 回归钉

`test/node/narrow.lua` 里两条断言原本**记录**旧的补集行为（`wideField` / `anyField` 成员
在另一侧被排除），本轮按新语义更新为「保留」；去掉修复立刻退回旧结果 ⇒ 是有效的判据。

## 残留（未满足，F24）

`completion.lua:1365` 的 `never` 修掉后，`src` = `vm.object`（= `parser.object | vm.generic`），
但 `vm.generic` **没有 `---@field node`** ⇒ `src.node` 读值 = `parser.object | nil` ⇒
形参 `parser.object` 仍报错。复现 `test/project/repro/union-missing-field.lua`。
方向：①目标工程补注解；②引擎侧新增「`x.type == 字面量` ⇒ 收窄到该字面量的子类」能力。
