# Spec Delta

## ADDED Requirements

### Requirement: 求值入口整段包在一次求值期内

产出类型求值的 LSP 入口 SHALL 把该入口内的整段 feature 求值放在**同一次求值期**内执行：
求值期间登记的缓存失效 SHALL 推迟到该请求的求值期结束后生效。
已包住的入口集合：hover、completion、按文件诊断、definition、references、implementation。
依据：这些入口的 provider 会读 `vm:getNode` / `variable:getEquivalentLocations` / `node.value`
等即触发求值；不包住时失效可在求值中途生效，节点换身份会让基于身份的环保护失效
（实测先例：147k 层递归，见 `facts/returns.md` F2）。

#### Scenario: 跳转请求期间的失效不打断本次求值

- **WHEN** `textDocument/definition` / `references` / `implementation` 的 provider 在求值中途
  登记了缓存失效（如写收窄值触发的 `flushCache`）
- **THEN** 该请求 SHALL 用同一批节点对象完成本次求值；失效 SHALL 在该请求的求值期结束后才生效

#### Scenario: 请求求值异常退出不留下永久锁

- **WHEN** 跳转入口的求值过程中抛出异常
- **THEN** 求值期 SHALL 被正确退出（锁计数归零），后续请求仍能正常生效失效
