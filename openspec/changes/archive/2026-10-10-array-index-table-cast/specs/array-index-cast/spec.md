# Spec Delta

## Purpose

定义数组作为整数索引表传递时的类型兼容性，使两种等价注解得到一致的静态诊断，同时保留元素类型不符及不同键域的真实错误，避免用泛化放宽掩盖问题。

## ADDED Requirements

### Requirement: 数组可转换为兼容的整数索引表

T[] SHALL 可转换为整数索引值类型与 T 兼容的表；元素类型不兼容 SHALL 报类型不匹配，SHALL NOT 因源数组身份拒绝等价整数索引表。

#### Scenario: any 数组传递给整数索引泛型表

- **WHEN** any[] 传给 table<integer, any> 形参
- **THEN** SHALL NOT 报 param-type-mismatch

#### Scenario: 错误元素不能转换

- **WHEN** number[] 传给 table<integer, string> 形参
- **THEN** SHALL 报 param-type-mismatch

#### Scenario: 非整数键域不当作等价数组

- **WHEN** string[] 传给 table<string, number> 形参
- **THEN** SHALL 报 param-type-mismatch
