# Spec Delta

## ADDED Requirements

### Requirement: 求值期间不做缓存失效

一次求值（值推导 / 遍历）从进入到结束期间 SHALL NOT 生效任何缓存失效
（`flushCacheNow` 及其级联）。失效 SHALL 被推迟到该次求值结束后的静默点**批量**生效。
依据：失效与求值交错会让"同一逻辑节点"换身份，基于身份的环保护失效（实测 147k 层递归）。

#### Scenario: 求值中登记的失效不打断本次求值

- **WHEN** 求值过程中某处登记了缓存失效（如写收窄值触发的 `flushCache`）
- **THEN** 本次求值 SHALL 继续用同一批节点对象完成；失效 SHALL 在该次求值结束后才生效

#### Scenario: 嵌套求值共享同一次求值期

- **WHEN** 求值 A 导致求值 B（如 `value` → `get` → `value`）
- **THEN** B SHALL 属于同一次求值期：期间不得失效，且 A 的环保护状态对 B 可见

#### Scenario: 求值异常退出不留下"永久锁"

- **WHEN** 求值过程中抛出异常
- **THEN** 求值期 SHALL 被正确退出（锁计数归零），后续求值仍能正常生效失效

### Requirement: 环保护用身份键集合表达

求值期的环保护 SHALL 用**按节点身份**记录的集合表达：
跨节点路径用 `visited`，同一节点重入用 `inProgress`；它们 SHALL 随求值上下文一路可见
（嵌套调用继承，无需逐层显式传参）。

#### Scenario: 自引用节点返回占位而不是再次求值

- **WHEN** 节点 A 的求值过程中又请求 A 的值
- **THEN** SHALL 返回未完成态占位（不得再起一次求值），且该占位 SHALL NOT 被缓存为 A 的结果

#### Scenario: 跨节点互递归能收敛

- **WHEN** `union` / `intersection` / `table` 之间形成引用环（每个都请求对方的值）
- **THEN** 求值 SHALL 终止（不依赖事后 `logOverflow` 兜底），结果 SHALL 是全部可达成员的一个稳定近似

### Requirement: 只缓存完成态

求值结果只有在**完成态**时才 SHALL 写入节点缓存；未完成态占位（`provisional` 一类）
SHALL NOT 进入缓存、SHALL NOT 作为最终值向外暴露（对外要么等算完、要么给出占位并由调用方识别）。

#### Scenario: 占位不得变成"早算就定终身"

- **WHEN** 某节点在依赖尚未就绪时被求值并返回占位
- **THEN** 之后依赖就绪、再次求值时 SHALL 得到真实结果（不得沿用占位或早期残缺结果）

## MODIFIED Requirements

无（本条为新增契约；现有行为在任务里逐步迁移，迁移期间旧路径保持可用）。
