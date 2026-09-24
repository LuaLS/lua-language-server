# Design

## 为什么在字段读取处改，而不是在收窄处

- 收窄处的 `truthy` 标记**被别处依赖**：F2 的反推用「实参已确定非 nil」去掉结果里的 nil
  （`test/coder/narrow-branch.lua:47` 钉着），把它去掉就回归
- 字段存在性判定是**纯粹的错误来源**：标记没有成员集，任何字段读都不该报「未定义」，
  按 `any` 处理既不会误导（`any` 的字段本来就是任意），也符合「标记 = 值未知但为真」的语义

## 落点

`script/node/type.lua` 的 `M:get`：

```lua
    if self.typeName == 'any'
    or self.typeName == 'unknown' then
        return self.scope.rt.ANY, true
    end
```

把 `truthy` 并入这一支即可（`any` / `unknown` / `truthy` 都是「成员集不可知」）。

## 已排除的替代方案

1. 收窄处不写标记 —— 挂 `test/coder/narrow-branch.lua:47`（上述 F2 依赖）
2. 在 `undefined-field` provider 里跳过 `truthy` 目标 —— 已试（2026-09-23）：
   目标工程数字不变（那条读值不是纯 `truthy`），治不了根
3. 让 `truthy` 变成一个「全字段 = any」的类 —— 与 1 行改动等价，但引入一个类概念，不值
