# Design

## 做法 A：meta 里给 `error` 加 `---@return never`

- 改动：`meta/whimsical/basic.lua` + 各版本 `meta/*/basic.lua` 的 `error`
- 优点：走既有机制（`never` 返回的 overload 已在引擎里支持，见 `test/feature/hover/basic.lua`
  的 `---@overload fun(v: falsy): never` 用例），不新增引擎概念
- 风险：所有 `error(...)` 守卫的收窄都会变，量级未知 → 必须先量

## 做法 B：引擎内置「永不返回」清单

- 改动：`script/node/tracer.lua` 的分支终止判定 + 一份清单（`error` / `os.exit` 等）
- 优点：不动 meta；清单可控
- 风险：多一个 magic list；与「注解语义优先」的项目约定不一致

## 测量方案（本轮先做）

1. 存目标工程基线（`--test project.external-diagnostic --save=tmp/...`）
2. 分别实施 A / B（一次只上一个），各跑：
   - 全量 `bin\lua-language-server.exe --test`
   - 目标工程比对（`--baseline=`）
3. 记录：总条数变化、移除/新增明细、`test/` 是否有回归
4. 判据：净移除更多且新增项可逐条分诊者胜；两者相近时优先 A（少一个引擎概念）
