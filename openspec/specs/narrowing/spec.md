# narrowing Specification

## Purpose

流收窄（flow narrowing）的系统行为：判等 / 真值 / 动态键判定的收窄结果，
以及收窄标记（`truthy` / `falsy`）作为读值暴露时的语义。
事实台账（`.github/skills/luals-server-dev/references/facts/<能力>.md`）是证据层，
本目录逐步承接其「已成立」的结论（迁移中，2026-09-24 起）。

## Requirements

### Requirement: 真假标记 `truthy` 作为读值时不产生字段存在性误报

`truthy` 是收窄标记（不携带成员集）。当读值恰为 `truthy` 时，其字段读取 SHALL 按 `any` 处理，
SHALL NOT 报「未定义字段」。

#### Scenario: 对 `truthy` 读值取字段

- **WHEN** 某表达式被真值收窄成 `truthy` 后立即读它的字段（`if x then x.field end` 一类）
- **THEN** 该字段读取 SHALL 得到 `any`，且不报 `undefined-field`

#### Scenario: 真值收窄本身不受影响

- **WHEN** `if not args or not other then return end` 之后用 `args` 做实参反推（F2）
- **THEN** `args` 的 `truthy` 标记 SHALL 保留，反推结果里的 nil SHALL 仍被去掉
