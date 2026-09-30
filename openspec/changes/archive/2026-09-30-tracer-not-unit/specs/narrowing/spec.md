# Spec Delta

## ADDED Requirements

### Requirement: 值位置的 `not` 节点内部读取点被走一遍

flow 里值位置的 `not` 表达式节点（coder 由 `not <exp>` 生成）SHALL 遍历其内部 unit，
使内部每个读取点（`ref`）得到该位置的值；SHALL NOT 因它是 `not` 而跳过整个子树。
SHALL NOT 对该操作数做真值收窄（值位置不是条件位置）。

#### Scenario: `not not f(arg)` 的实参读点不退化成未收窄值

- **WHEN** 代码形如 `if x then return not not f(x), x end`（`f` 的形参要求非 nil、`x` 为 `T?`）
- **THEN** `f` 的实参 `x` SHALL 读到收窄后的 `T`，SHALL NOT 报
  「Cannot assign `T | nil` to parameter `T`」；同一行作为返回值的 `x` 与它结果一致

#### Scenario: 不做真值收窄

- **WHEN** 值位置出现 `not x`（非条件位置）
- **THEN** `x` 本身的值 SHALL NOT 被收窄成真假标记；只要求其读取点被走一遍

#### Scenario: 条件位置的 `not` 行为不变

- **WHEN** `not x` 作为 `if` 的条件（`if not x then ...`）
- **THEN** 真值收窄 SHALL 与该改动前一致（走 `traceConditionUnit` 的既有路径）
