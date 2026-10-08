# Tasks

## 1. 分诊（`param-type-mismatch` 88 条）

- [x] 1.1 按文件/消息形状分组：`vm/compiler.lua` 13、`vm/sign.lua` 12、`provider/provider.lua` 9、`vm/type.lua` 7 …；形状以 `parser.object` 一族为主（51 条含 `parser.object`、8 条含 `truthy`）
- [x] 1.2 代表点最小复现：`---@field [integer] Node|any` 的 `o[1]` —— **赋给 `string` 不报、传给 `string` 参数报**（对照实验）
- [x] 1.3 排除诱因：改 `ANY.truthy` preset 只把消息里的 `truthy` 变成 `any`，误报仍在（拦路成员是具体类）⇒ 回退该实验
- [x] 1.4 追加实验：`Union.__getter.truthy/falsy` 保留 `any` 成员 ⇒ 154 → 129（移除 32 / **新增 7**，全是 `json-edit.lua` 的 `t.v[k]` `need-check-nil`）⇒ 净变差，回退；该场景列「已知未覆盖」

## 2. 落地

- [x] 2.1 `define.lua` 新增 `hasAnyMember`；`assign-type-mismatch.lua` 改用共享实现（行为不变）
- [x] 2.2 `param-type-mismatch.lua` 的 `canAssign` 补放宽；验证：`--test feature.diagnostic` 绿
- [x] 2.3 `return-type-mismatch.lua` 补同样放宽；验证：同上
- [x] 2.4 测试各加「带 any 不报 + 不带 any 必报」成对两例（param / return）

## 3. 验证

- [x] 3.1 分步实测：仅 param 放宽 ⇒ 154 → 133（移除 21）；再加 return ⇒ **154 → 130（移除 24 / 新增 0）**（含上一轮 F2 的 5 条）
- [x] 3.2 全量 `bin\lua-language-server.exe --test` 绿
- [x] 3.3 本仓库面板 0（error / warning / information；hint 不管）

## 4. 记账

- [x] 4.1 新增 `facts/type-check.md`：T1（规则 + 数字 + 试过未采用）、T2（88 条分诊表与判定）；`--test tools.facts`
- [x] 4.2 `项目实践.md` 追加本轮纪要
- [x] 4.3 `openspec archive any-member-relaxation`
