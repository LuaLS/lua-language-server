# Spec Delta

## ADDED Requirements

### Requirement: 收窄值被 flush 清掉后按需重算

`Node.Variable` 上由 walker 写入的收窄值属于**临时缓存**，`rt:flushCacheNow()` 清掉它之后，
该读取处 SHALL 能在**非嵌套时刻**（当前没有任何 walk 正在进行）触发一次重走，
使读值重新得到收窄结果；SHALL NOT 因 flush 永久退化为 `getStaticValue()` / `getGuessValue()` 兜底值。

#### Scenario: 守卫后的读值不再退化成未收窄值

- **WHEN** 同一文件的分析过程中发生过 flush（收窄值被清），随后消费者读一个此前已被收窄的局部变量
- **THEN** 该读值 SHALL 是收窄后的类型（例：`if x and x < n then ... f(x)` 里 `x` 是 `integer`），
  SHALL NOT 是静态兜底值（`integer | nil`）

#### Scenario: 嵌套 walk 中不重走

- **WHEN** 重算请求发生在另一次 walk 内部（`walkingDepth > 0`）
- **THEN** SHALL NOT 重走（维持旧行为）；读值允许暂时是兜底值，但 SHALL NOT 触发栈溢出或无限递归

#### Scenario: 同一次读取只重走一次

- **WHEN** 一个读取处在一次取值中检测到收窄值丢失
- **THEN** SHALL 至多触发一次重走；重走完成后该读值 SHALL 是收窄结果
  （SHALL NOT 形成「走完→flush→再走」的往复）

### Requirement: 收窄值失效的既有语义不改变

`rt:flushCacheNow()` SHALL 继续清除收窄值（它依赖 flow 与其它节点的值，清掉是正确行为）。
本要求只改变「清掉之后不再重算」这一点，SHALL NOT 把收窄值移出 flush 范围或改变 `class.flush` 语义。

#### Scenario: 依赖变化后收窄值仍会失效

- **WHEN** 收窄值所依赖的节点发生变化并触发 flush
- **THEN** 旧收窄值 SHALL 被清除，随后按本 spec 的第一条要求重算，而不是沿用旧值
