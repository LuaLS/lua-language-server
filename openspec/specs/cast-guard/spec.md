# cast-guard Specification

## Purpose
约束「类型转换判定」（`canCast`）在递归结构上的终止性：判定必须有界，超限按宽松（unknown）放行，
避免深递归耗尽栈。依据：该判定的环保护键是节点**身份路径**，而链上每层都会新建节点，
身份键无从剪枝（实测 147014 层栈溢出）。

## Requirements

### Requirement: 转换判定必须有界

任意一次「自己是否可转换为对方」的判定 SHALL 在有限层数内结束：
递归深度超过上限时 SHALL 按 unknown（宽松 `true`）返回，SHALL NOT 继续下探。

#### Scenario: 递归结构上的判定不耗尽栈

- **WHEN** 判定沿「每层新建节点」的路径持续下探（union / table / intersection 互相 canCast）
- **THEN** 判定 SHALL 在达到深度上限时收敛（按 unknown 放行），SHALL NOT 抛栈溢出

#### Scenario: 上限内行为不变

- **WHEN** 判定在深度上限内完成
- **THEN** 结果 SHALL 与不加上限时一致
