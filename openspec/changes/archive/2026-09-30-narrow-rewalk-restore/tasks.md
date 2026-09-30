# Tasks

> 本轮无代码改动（两条试探都净变差、已回退）。这里的清单是**下一步修 F2 的入口**。

## 1. 定位（已完成）

- [x] 1.1 复现手段：pass 边界 flush「本次 walk 写过的收窄节点」⇒ 强制 flush 场景 156 → **193**
  （新增 32 = 面板的 `compile.lua:1290/1387/1407/3043/3044/…`）
- [x] 1.2 插桩 `W:traceVar`/`W:traceRef`：每次 walk 里 `local child` 的静态值 = `nil`，
  分支内读点被写成 `never`（`never` 不含 nil ⇒ 不报 ⇒ 批量 harness 看不到）
- [x] 1.3 插桩 `need-check-nil`：强制 flush 场景下读点 `cv=nil value=nil`
  ⇒ 读值退回 `parser.object | nil` ⇒ 报错（面板那条的真实来源）
- [x] 1.4 两条改法实测并否决：`restart` 顺手 flush 收窄节点（193 / 174）；walk 内写入 `skipFlush`
  （174，移除 10 / 新增 25，带坏 #21/#22 的族）⇒ `setCurrentValue` 的 flush 是承重的
- [x] 1.5 结论上提：`facts/returns.md` F2 追加「完整链条 + 两条实测 + 下一步入口」；
  `facts/narrowing.md` F27 追加「面板残留 + 复现手段」；`--test tools.facts` 绿

## 2. 下一步（新轮，修 F2）

- [ ] 2.1 在 `W:traceVar` 打点：`local:child` 的 `assignValue` / `getGuessValue()` /
  `matchedFuncs` 各自 view，确认「空 list ⇒ nil」（F2 原假设）还是「某条 getter 直接给 nil」（新线索）
- [ ] 2.2 按结论改 `Function.returnsPack` / `List:select` / `FCall.returns` 的兜底，
  保证**调用点**的第 1 个返回值等于推断出的 `{...} | nil`
- [ ] 2.3 验收：强制 flush 场景 **193 → 154**（普通过程 154 不回归）；全量 `--test` 绿
- [ ] 2.4 面板复验：请用户重启 LS 后确认 `compile.lua:3043/3044` 消失
- [ ] 2.5 收尾：`facts/returns.md` F2 改「成立」或续记；归档本 change 与新 change
