# Spec Delta

## ADDED Requirements

### Requirement: 收窄当前值写入在同一求值期立即可见

显式收窄当前值写入 SHALL 立即替换本变量读取使用的值缓存；普通缓存失效及依赖级联 SHALL 仍延迟到求值期结束，SHALL NOT 为更新当前值而提前全局失效。

#### Scenario: 已缓存可选值随后收窄

- **WHEN** 求值期内先读 string | nil，再将当前值写为 string
- **THEN** 同期再次读取 SHALL 得到 string；再写 nil 后 SHALL 得到 nil

### Requirement: 索引赋值的键读取继承所在守卫的事实

在非 nil 守卫内计算索引赋值的键表达式时，变量读取 SHALL 使用该位置的收窄事实，SHALL NOT 因赋值左侧位置或诊断求值顺序退回可选类型。

#### Scenario: 已守卫的可选字符串作为方法接收者

- **WHEN** key 为 string?，代码 if key then target[key:upper()] = value end
- **THEN** 键表达式 SHALL NOT 报 need-check-nil

#### Scenario: 无守卫仍报告

- **WHEN** key 为 string?，直接 target[key:upper()] = value
- **THEN** SHALL 报 need-check-nil
