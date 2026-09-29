# Proposal

## Why

用户问「`any` 取字段为什么会报 `undefined-field`」——目标工程 `missing-return-value.lua:30`
（`start = ret.start`）在报，而悬浮看到的读值是 `any`。

## What Changes

本轮**只做定位**，无引擎改动：

- 诊断期打印：provider 检查的是**基值** = `parser.object[] | nil`（不是 `any`）⇒ `exists = false` ⇒ 报；
  悬浮的 `any` 是**读节点自己的值**（tracer 的宽松路径）⇒ 「值是 any 却报未定义」的观感来自两条不同路径。
- 逐位置探针（`--probe-filter=ret@`）：同一个循环变量 `ret` 的读值随位置变化 ——
  `@25/@26` = `any`、`@30/@31`（报错处）= `parser.object[] | nil`、`@39/@40` = `never`；
  退化发生在「调用 `vm.countList(ret)` + 对结果的比较」之后。
- 归因：按注解（`returns? parser.object[]` ⇒ 元素 `parser.object | nil`，`start` 存在）不该报
  ⇒ **我们的**缺口（循环变量/元素解析），非目标工程注解问题。两个候选诱因：
  ① `ipairs(<未收窄的 parser.object[] | nil>)` 的元素/泛型 V 退化；
  ② `W:traceLink` 的间接窄化 → `W:traceCallEqual` 按形参注解反推实参，把 `ret` 写成 `parser.object[] | nil`。
- 台账 `facts/returns.md` F3 追加证据与归因（含两条「试过/待测」）。

## Capabilities

### New Capabilities

（无）

### Modified Capabilities

（无 —— 行为未变，`.openspec.yaml` 用 `skip_specs: true`）

## Impact

- 代码：无（诊断期打印已回退）。
- 目标工程基线：218（未变）；本仓库 `--test` 全绿、面板 0。

### 试过但未采用

1. 让 walker 按 flush 代数重跑 —— 目标 276 → 276；放宽触发条件会 C 栈溢出（`narrowing.md` F19）。
2. 让「参数反推」只写回该次读取、不污染变量后续读取（对齐内联 cast 的既有设计）—— **未测**，
   要量会不会丢掉 `pcall/load` 一族依赖「实参被形参收窄」的既有行为。
