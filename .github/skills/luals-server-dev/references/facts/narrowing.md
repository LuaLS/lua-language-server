# 事实台账：flow 收窄（script/node/tracer.lua）

格式：断言（可判定的一句话）/ 证据（测试或目标工程坐标）/ 代码 / 状态。
状态取值：成立 / 未满足(open) / 已废弃。

## F1 跳转结尾的分支不参与 fall-through 合并
- 断言：`if not x then goto L end`（`break`、`continue` 同理）之后，x 的收窄保留，读值不含 nil
- 证据：test/coder/goto-narrow.lua（5 例）；test/feature/diagnostic/param-type-mismatch.lua 末 2 例
- 代码：parser `block.exits` → coder if 分支 `'exit'` 标记 → `W:traceIfChild` 认作 terminated
- 状态：成立（2026-09-22，4c47fb0ff）

## F2 反推（返回值相等 / 谓词真值）不得比实参自己的类型更宽
- 断言：`traceCallEqual` 写入实参的值必须能 cast 到实参自己的类型（`getExpectValue`）；
  实参确定非 nil 时按同名去掉反推结果里的 nil
- 证据：test/coder/narrow-branch.lua（2 例）；目标工程 provider/diagnostic.lua:257/267 等 8 处误报消失
- 代码：`script/node/tracer.lua` `W:traceCallEqual`
- 状态：成立（2026-09-21，3054c26b0）

## F3 收窄结果必须与变量自己声明的类型相容
- 断言：任何写进收窄栈的读值都要能 cast 到该变量自己的类型，不相容就丢弃（不写）
- 证据：目标工程误报 auto-require.lua:123、duplicate-set-field.lua:68/88/89、luadoc.lua:1973
  （`def == src` 两变量比较把 `def` 反推成 `{ uri: uri }`；字段比较 `a.t ~= 'x'` 反推成 `never`）
- 试过：按 canCast 过滤 exit 分支的 otherSide 三方向 —— value→outer：rm28+add25；
  outer→value：rm18+add233；只滤字面量表：rm28+add25。都会连带丢掉大量正常收窄，均不可行
- 状态：**未满足（open）** ← 修 F3 是收窄方向的下一入口

## F4 `and` / `or` 的值位置（`x = a and b`）目前不做真值收窄
- 断言：值位置只遍历操作数条目取 currentValue；右操作数拿不到左侧收窄（`x = s and #s` 里 `#s` 是 `op.len<string | nil>`）
- 证据：无测试（调研数据见 项目实践.md「2026-09-21（第二轮）」）
- 代码：`W:traceUnit` 的 `and`/`or` 分支；`traceAnd`/`traceOr` 只在 condition 位置被调用
- 状态：未满足（open，2026-09-21 调研：操作数边界要 coder 插标记，落 6 处新误报后暂缓）

## F5 真假标记 `truthy` 会作为读值出现（无成员集）
- 断言：`any` 上的真值收窄得到 `type truthy`，它没有字段 → 作为读值会引发「未定义字段」/形参不匹配
- 证据：目标工程 vm/global.lua:602、vm/type.lua:605、completion.lua:1861/1884 仍是 `truthy` 相关误报
- 代码：`rt.TRUTHY`（`script/node/runtime.lua`）；`W:traceByValue` / `W:traceCallTruthy`
- 状态：未满足（open）

## F6 `type(x) == 'string'` 一族的收窄依赖 F2 的反推，不能一刀切
- 断言：实参自己**没有**类型（`any`/`unknown`）时，反推是该族收窄的唯一来源，必须保留
- 证据：test/coder/flow.lua（`--!include type` 的两组用例：未注解 `local x`、`string|number|boolean`）
- 状态：成立（作为 F2 的边界条件；2026-09-21 实测：全局弃用反推会挂测试）
