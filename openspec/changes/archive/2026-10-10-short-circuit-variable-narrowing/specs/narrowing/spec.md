# Spec Delta

## ADDED Requirements

### Requirement: 值位置短路右侧继承可靠真假事实且不外泄

值位置 `and` 的右操作数 SHALL 继承左侧变量（基础值、类、表）的真值收窄事实；`or` 的右操作数 SHALL 继承对应的假值事实。嵌套逻辑仅传递保证成立的事实，SHALL NOT 把临时事实扩散到表达式之后或无关变量。联合体收窄结果 SHALL 基于当次已解析成员形成快照，SHALL NOT 因源包装变量后续变化重新混入 nil。动态键的新增收窄不在本轮范围内。

#### Scenario: 可选变量在 and 右侧作为实参

- **WHEN** `x` 为 `string?`，代码是 `return x and f(x)`，f 接受 string
- **THEN** 右侧 x SHALL 不含 nil，SHALL NOT 报 param-type-mismatch

#### Scenario: 表达式之后仍需判空

- **WHEN** `x and f(x)` 之后直接调用 f(x)，且无其它守卫
- **THEN** 后一次调用 SHALL 仍报可选实参不匹配

#### Scenario: or 右侧与 not 的事实

- **WHEN** `not x or f(x)` 中 x 为 string?
- **THEN** f 的实参 SHALL 是 string，SHALL NOT 报可选实参不匹配

#### Scenario: 不推断析取的单个变量

- **WHEN** `(x and flag) or f(x)` 中 x 为 string? 且 flag 可为假
- **THEN** f(x) SHALL 仍报告可选实参，不把左侧为假误解为 x 为真

#### Scenario: 当次联合体成员不被后续包装变量污染

- **WHEN** 真值收窄返回联合体，成员含可变变量包装，写入读点后源变量改变并触发缓存刷新
- **THEN** 当次收窄快照 SHALL 保留已解析类型，SHALL NOT 从包装变量重新读入 nil

#### Scenario: 类与表短路字段读取

- **WHEN** x 为可选类或表，表达式为 x and x.finish
- **THEN** 右侧字段读取 SHALL 不报 need-check-nil；无守卫访问 SHALL 仍报告

#### Scenario: 真实不匹配保留

- **WHEN** x 为 string? 而 `x and f(x)` 中 f 要求 number
- **THEN** SHALL 仍报 param-type-mismatch
