# 项目实践：清理目标工程的诊断

## 上下文

- **目标工程**：`D:\github\vscode-lua\server`（上游 master 架构，不是本仓库）
- **本仓库**：`D:\github\vscode-lua-4\server`（4.0 重构分支，长期目标是替代上游）
- 加载目标工程：
  - `test\project\external.lua` —— 只加载/索引
  - `test\project\external-diagnostic.lua` —— 加载并输出诊断报告（配合 `--test-project`）
- **当前阶段（2026-09 起）**：用本仓库的 LS 去扫目标工程，逐条清理诊断。目的有两个：
  1. 找出本仓库的**误报**并修掉（对齐本仓库自己的语义与用户预期）；
  2. 反过来检查目标工程的注解/用法是否本身有问题（注解写错也会被诊断暴露）。
- 这个实践会持续一段时间，**每次会话都应先读本文件**。

## 遇到诊断时的处理顺序（重要）

**先判断语义，再怀疑实现。不要一上来就调试 LS（tracer / coder / 类型系统）。**

1. 读代码上下文，先确认写法/注解本身是否正确：
   - 可选字段有没有写 `?`（`---@type { a: integer, b?: integer }`）；
   - `---@type` / `---@param` / `---@return` 与实际赋值、返回值是否一致；
   - 是否缺少 `---@async`（异步上下文）、`---@overload`（重载）、`---@class` 等标记；
   - 是否依赖跨文件推断才成立。
2. **不要用上游 master 做对照**（不跑 master 的二进制、不拿 master 的输出当"应该报/不该报"的判据）。
   判断只基于本仓库自己的语义、现有测试与目标工程代码本身：
   - 写法/注解本身有误 → 先改代码或注解（此时本仓库的注解语义就是判据）；
   - 只有我们报、且按本仓库自己的语义就不该报 → 才是本仓库的候选 bug，进入实现排查。
3. 确认是误报后，再按 skill 的 references 定位子系统，并补上回归测试。
4. **诊断数量只用于筛查，不是方案去留判据（2026-10-10 用户明确）**：新增诊断先逐条做语义判断；暴露真实代码/注解问题属于合理副作用，可以接受。新增是误报才排查修复；原诊断消失也须确认不是被错误类型（如 never/any）掩盖。不能仅凭「新增非零」回退或收缩语义。

### 案例：`script/config/env.lua` 的 assign-type-mismatch

- 现象：`---@type { name: string, key: string, converter: fun(value: string): any }[]` 要求每个元素都有
  `converter`，而 10 个元素里 9 个没有 → 我们报 `assign-type-mismatch`。
- 结论：**注解写错**——`converter` 应写成 `converter?`，已由维护者改正。
  （这次没有改我们的 cast 语义，差异记录在"已知未决"。）

## 常用命令（在 `server` 根目录执行）

> 命令里的目标工程路径 `d:\github\vscode-lua\server` 只是当前机器的实际路径，换机器一律用
> `--test-project=<目标工程实际路径>`；本仓库内的路径（`tmp\...`、`test/...`）都是相对仓库根的。

- 全量测试：`bin\lua-language-server.exe --test`
- 单套测试：`bin\lua-language-server.exe --test feature.diagnostic.param-type-mismatch`
- 扫目标工程（外部诊断报告，输出各诊断码计数 + 样本行）：
  `bin\lua-language-server.exe --test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2`
  - 样本行格式 `文件:行:列 | 源码行 | 消息`；多行消息会占多行，按行 grep 会被截断，必要时读原始区段
  - **基线对比**（改前/改后各跑来确认"只修不破"）：
    `--save=tmp\scan-a.txt` 存基线，之后加 `--baseline=tmp\scan-a.txt` 直接打印
    `基线 N 条 → 当前 M 条：移除 x / 新增 y` 与逐条 `- ` / `+ ` 行（key 是 `文件:行:列|code`）。
- 探针（看某个变量读出来的类型 / 看某函数的收窄 flow，取代临时往测试里塞 `dumpNodes` 调试块）：
  `bin\lua-language-server.exe --test project.probe --test-project=d:\github\vscode-lua\server --mem-limit=2 --probe-file=duplicate-set-field.lua --probe-filter=def@68`
  `--probe-flow=<flow key 片段>` 则打印匹配的 `coder.tracerFlowMap`（含操作数标记、appendVar/appendRef 顺序）。
- 想把某个小写法单独拿出来复现：把它放进本仓库 `tmp/` 下的临时目录，用
  `--test project.external-diagnostic --test-project=<那个临时目录>` 扫一遍即可（不要动目标工程）。

## 事实台账（2026-09-22 起）

散落在 skill/日志里的「实测结论」改由 `.agents/skills/luals-server-dev/references/facts/<能力>.md` 承载，
每条：`断言 / 证据 / 代码 / 状态`（状态：成立、未满足(open)、已废弃；`试过:` 记被否决的方案与实测数字）。
规则：
- 开工前先读对应能力的 facts（`状态: open` 就是下一轮入口，`试过:` 防止重走）；
- 每轮结束时把结论**上提**成一条 fact，[诊断实践纪要](diagnostic-history.md)只留时间线与摘要；
- `--test tools.facts` 会校验 `证据：` 里的 `test/*.lua` 真实存在（台账引用不许烂）；
- 台账不写「需求/设计意图」，只写**实测出来的事实与反例**。

## 约定

- **判断"该不该报"只依据本仓库自己的语义、现有测试与目标工程代码本身**：
  不跑上游 master 的二进制、不拿 master/其他实现的输出当判据（这条是硬规则，见 `AGENTS.md` §0）。
- 用户说「**继续**」时的默认动作：扫**目标工程**（不是本仓库自扫）→ 挑一个「确认是我们实现 bug
  且比较好修」的误报 → 修掉并补回归测试 → 再读**本仓库问题面板**（`vscodeOperator_readProblems`，
  `minSeverity=information`）确认警告没有新增（目标：0）。
- 本仓库自扫（`--test project.external-diagnostic --test-project=<本仓库>`）**一律不跑**
  （2026-09-24 用户明确：规则集不同、结果对不上，纯浪费时间）；本仓库只看**问题面板**。
- 临时文件一律放本仓库 `tmp/`；**不要**在目标工程里留下文件。
- 删除文件用 git 命令（`git rm` / `git clean -fdx -- <路径>`），不要用 `del`。
- 目标工程的改动只允许是"修注解/修代码"这类正当修复，不做无关改动。
