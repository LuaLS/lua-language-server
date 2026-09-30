# 事实台账：求值上下文与失效时机（`script/node/runtime.lua` / `node.lua`）

格式：断言 / 证据 / 代码 / 状态。

## E1 求值期不失效：入口 lock、静默点批量 flush

- 断言：一次求值（值推导 / 遍历）从进入到结束期间**不生效任何缓存失效**；失效被推迟到该次求值结束
  （最外层 `exitEval` → `unlockCache` 锁归零）后**批量**生效。失效与求值交错会让节点换身份，
  基于身份的环保护随之失效（先例见 `classes.md` F25 的爆栈）。
- 证据：`test/node/eval-context.lua`（①嵌套求值共享可见、出栈回外层；②`withEval` 内抛异常后 ctx 栈清空；
  ③求值期内 `flushCache` 被推迟：期间缓存值不变、出栈后失效生效）
- 代码：`script/node/runtime.lua` 的 `enterEval/exitEval/evalContext/withEval`
  （ctx 栈**按协程隔离**：以 `coroutine.running()` 为键的弱键表 —— LS 的 task 会交错，单一栈会弹错协程的 ctx）；
  入口锁与 ctx 同在 `enterEval/exitEval` 里配对；`flushCacheNow` 加 test 断言「`cacheLocked > 0` 不得旁路」
- 落地范围（2026-09-30 收口，**已全覆盖**产出类型求值的入口）：`script/feature/diagnostic/file.lua`
  （按文件诊断的 task body）、`script/language-server/capability/language-features/` 下的
  `hover.lua` / `completion.lua` / `go-to-definition.lua` / `go-to-references.lua` /
  `go-to-implementation.lua`（在求值调用外各包一层，不重排缩进；`---@async` 贴在**调用**上、闭包不换行、
  结果经闭包外 `local` 带出）
- 包装位置断言：SHALL 落在 **capability 调用点**（`enterEval` 的锁与 ctx 栈按 `scope.rt`），
  SHALL NOT 下沉到 `ls.feature.*` 函数内部 —— 那会让测试与内部调用路径也隐含「求值期」语义
  （已落地的 5 处均为调用点包装，保持一致）
- 状态：成立（2026-09-30；全量 `--test` 与目标工程扫描下断言**零命中**）

## E2 per-eval 与 per-traversal 的环保护必须分开

- 断言：求值期的环保护分两类，**不能混**：
  - **per-traversal**（"这一次遍历别绕回同一节点"）：`simplify` / `each` / `every` / `isTableLike` 等
    的局部 `visited`（`ls.util.visited` 9 处、手写 `visited = visited or {}` 13 处、每次新建 8 处）。
    作用域就是"这一次调用"，**由各自内部维护**；接进 ambient ctx 会让同一次求值里第二个独立遍历
    吞掉合法的重复访问（`union:each/every` 的 `visited` 还是公开 API 参数）。
  - **per-eval**（"这一趟求值里这个环已处理过"）：跨节点互递归的那部分，放 ctx：
    身份键（`ctx.visited` / `ctx.inProgress`）与**结构签名键**（`intersection` 的
    `Node.Intersection.EvalState`）。
- 断言（结构键）：`intersection` 的环保护键是 `rawSignature(rawNodes)`，**节点被重建后依然有效**，
  SHALL NOT 换成身份键（身份会随重建失效，是本轮 147k 爆栈的诱因之一）。
- 证据：`test/node/eval-context.lua`；`intersection.lua` 的 `evalState`（有 ctx 用 ctx、无 ctx 退回模块级）；
  数字：目标工程 `[Intersection] values cycle detected` 日志数 2 → 2（未增）
- 代码：`script/node/node.lua`（`Node.ResolveContext` 增 `inProgress` / `intersection`）、
  `script/node/intersection.lua`（`Node.Intersection.EvalState` + `evalState`）
- 收编（2026-09-30，`ls.util.simplify` / `ls.util.visited`）：11 处完全同形的 `simplify` 覆盖体
  （`call/fcall/field/index/list/param_of/select/spread/subtract/ternary/variable`）各收敛成一行，
  另 2 处线程式手写守卫（`union:isTableLike`、`variable:hasAssignedField`）换用 `ls.util.visited`；
  两轮净 **-75 行**、目标工程 154（0/0）。**其余手写 `visited` 形态不同/作用域自足，不收编**
  （`class.lua` 按名去重、`completion/string.lua` 别名链、`node.lua` 链式循环、`runtime-helper.lua` 队列、
  `variable.lua` 的局部递归、`union.lua:124` 集合去重）
- 状态：成立（2026-09-30）

## E3 占位只放 ctx，不进缓存（只缓存完成态）

- 断言：同一节点重入时的「未完成态占位」SHALL 放在 `ctx.inProgress`（身份键，生命周期=一次求值期），
  SHALL NOT 写进 getter 缓存字段；占位作为结果返回时 `needCache = false`（只缓存完成态）。
  这样求值中途异常也不会把"半成品"永久留在缓存里。
- 证据：`test/node/eval-context.lua`（③）；`test/node/tracer.lua` 的收窄/反推用例
- 代码：`script/node/variable.lua` 的 `M.__getter.value`（唯一把占位写缓存字段的地方，已迁移；
  无 ctx 时退回旧写法保持行为一致）；`rt.PROVISIONAL` 仍作为**类型/识别标记**保留
  （`runtime.lua` 的 preset、`tracer.lua:387/441`、`union.lua:155/163` 的检查不动）
- 状态：成立（2026-09-30）；**未解决**：`Select.value` / `FCall.returns` 这类值节点的"早期结果被缓存"
  仍存在（见 `returns.md` F2 —— 那两条的 stale 值不在 `Variable.value`，本轮未顺带修掉）

## E4 面板/诊断的缓存陷阱：跨文件改动不会让已缓存文件重算

- 断言：`vfile.diagnostic` 的结果按 `calculated && version == vfile.version` 命中缓存；
  改**别的文件**（如 `node.lua`）不会让已分析过的文件（如 `intersection.lua`）重算
  ⇒ 本仓库问题面板会出现**旧缓存告警**。排查面板时先确认是不是缓存，必要时 touch 该文件触发重算。
- 证据：2026-09-30 实测 —— 修好 `node.lua` 的 `---@field` 后 `intersection.lua` 仍报 `inject-field`，
  touch 该文件后消失；目标工程侧同一现象见 `项目实践.md` 第二十四轮（缓存 30 条 vs 重算 63 条）
- 代码：`script/feature/diagnostic/file.lua` 的 `refreshNow`（缓存判断在 task 体内）
- 状态：成立（2026-09-30）
