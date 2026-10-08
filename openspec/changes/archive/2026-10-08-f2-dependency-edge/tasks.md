# Tasks

## 1. 落地

- [x] 1.1 `script/node/fcall.lua`：`matchedFuncs` 里对匹配到的函数 `f:addRef(self)`；验证：全量 `--test` 绿、文件面板无 warning
- [x] 1.2 `script/node/function.lua`：`addReturnList` 末尾 `self:flushCache()`；验证：同上
- [x] 1.3 `script/feature/diagnostic/init.lua`：pass 入口复位 `scope.rt.castDepth`（异常穿出泄漏兜底）；验证：同上
- [x] 1.4 复测不爆栈：第一次（`flushCacheNow` 里清 `castDepth`）→ 复现 `intersection.lua:151` 栈溢出；去掉该行 → 正常 `测试完毕`（保留 `Runtime:reset` 的复位）

## 2. 验证

- [x] 2.1 目标工程基线：`--baseline=tmp\scan-154.txt` ⇒ **154 → 149（移除 5 / 新增 0）**；移除的正是同族
  `compile.lua:3365(x2) / 3375 / 3411 / 3417`（与面板 `3043/3044` 同形）
- [x] 2.2 全量 `bin\lua-language-server.exe --test` 绿
- [x] 2.3 本仓库面板 0（`vscodeOperator_readProblems`，error / warning / information；hint 不管）
- [x] 2.4 面板侧（目标工程）：用户确认 `compile.lua:3043/3044` 一族**不再报**、无新问题

## 3. 记账

- [x] 3.1 台账 `facts/returns.md` F2 记「依赖边已落地 + 实测数字 + 面板待确认」；`facts/casts.md` F3 补「失效点不得清计数」的坑；`--test tools.facts`
- [x] 3.2 `项目实践.md` 追加本轮纪要
- [x] 3.3 `openspec archive f2-dependency-edge`
