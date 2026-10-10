# Design

## Context

见 proposal.md。F4 已证明 read-site id 不能传递至右侧同变量的另一读取点；条件收窄会沿 parentMap 上行，产生持久副作用。

## Goals / Non-Goals

**Goals:** 右操作数读取同一变量时得到可靠真假事实；离开表达式即恢复原环境。

**Non-Goals:** 不重写条件收窄、动态键同一性、谓词反推或缓存机制。

## Decisions

- 临时环境按 masterVariable 或变量本身为键，嵌套右操作数按栈覆盖，traceRef 优先消费该环境；不调用 traceConditionUnit。
- 不给右侧另套普通收窄栈，保持独立变量环境；套栈与不套栈均曾出现 compile.lua:3697，不能以这项诊断断言套栈是根因。
- 收集事实时复用左侧本次 traceRef 的返回值快照，不重复 traceRef；避免额外 setCurrentValue/flush。
- 左侧仍按原路径遍历。只从直接 ref 提取值，复合式仅在 and 为真或 or 为假时合取事实，not 翻转真假方向；不对析取方向猜测。
- 收窄用节点既有 narrowEqual(TRUTHY)；未知值/纯真假标记不作为新事实。事实只写读点，不写共享收窄栈，不向基变量反推。
- 恢复类/表通道。联合体收窄结果通过当次 narrowed.values 的成员副本重建，剥离可变变量包装；不改 Union 全局行为。100 → 98（移除 2 / 新增 0），compile.lua:3697 新增误报消失。
- 取证：collect 与 apply 时收窄值不含 nil；后续读取重新展开 rawNodes 中的包装变量才回染 nil。收集器最小回归以源变量 STRING → NIL + flush 验证：无快照得到 truthy | nil，有快照保持 string | truthy。
- 试过右读点同步 id 临时值、跳过身份相同结果、移除普通临时栈：完整方案仍移除 5 / 新增 1，均不能解决 compile.lua:3697。
- 先用直接可选变量验证，再用嵌套逻辑与字段用例限制回归面。新增诊断必须逐条分诊；真实问题可接受，误报才修复或收缩，并检查移除条目没有被错误类型掩盖。

## Risks / Trade-offs

- 持久读点缓存影响后续 → 成对测试表达式之后仍报可选实参。
- 变量身份可能共享字段槽位 → 动态键不采纳；字段能力以实测决定范围。
- 求值重入 → 只用 traceRef 返回值、getStaticValue 与既有节点收窄，不读取 variable.value 触发 tracer。
- 工程规模行为 → 全量测试与目标基线语义分诊双重验收；合理新增允许，确认是误报才撤回有问题的实现。
