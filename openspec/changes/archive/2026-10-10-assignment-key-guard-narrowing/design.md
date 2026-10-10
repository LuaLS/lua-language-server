# Design

## Context

见 proposal.md。coder 赋值左侧预编译已生成 ref；只推迟 var 写入。探针与诊断时序不同，先检查诊断入口缓存刷新与当前值读取。

## Goals / Non-Goals

**Goals:** 守卫中的键方法调用读到非 nil 值，真实无守卫情况仍报。

**Non-Goals:** 不改赋值执行顺序、全局宽松类型或旧 flow/branch。

## Decisions

- 取证确认不是 coder 漏读：诊断读 key 时 currentValue 已清，node 值 string | nil；重走恢复 string。真实诊断 File:refreshNow 已 withEval 包装，批扫直接调用没有，求值与失效交错。仅在批扫调用点补齐 withEval，不下沉到 feature 内部，不改 Node。
- 先最小化可选局部、索引键方法链和循环赋值，定位与工程之间的差异。
- 求值不允许额外反复重走导致爆栈；复用已有 eval 与 flush 机制。
- 写 currentValue 后立即置本变量 value=nil，防止锁内旧值 getter 缓存盖住写入；不调用 flushCacheNow、不提前级联。最小测试修复前失败、修复后 string/nil 两次更新均正确，普通 flush 延迟旧用例仍绿。
- 比较数字按唯一位置/code 统计，原始条数另外显示；保持基线文件原始明细以供重复诊断家族排查。

## Risks / Trade-offs

- 探针读取会改变缓存 → 分别验证独立读取与诊断 pass。
- 重算引发循环 → 最小测试与全量回归、工程基线双验；差异逐条语义分诊。
