# 已知问题 / 待办

- **加载/索引期类型解析无界增长（2026-09-18 实测，未解决）**：
  - **触发文件**：`d:\github\vscode-lua\server\meta\default utf8\CS.lua`（659KB / 14408 行，Unity+NGUI
    生成的 C# 绑定 meta；20+ 个类互引、每类约 30 个字段、含 `BetterList<UIScrollView>` 泛型自引用）。
  - **现象**：`--test project.external --test-project=<含该文件的目录>` 在**加载/索引阶段**（不跑诊断）
    内存随行数超线性增长：前缀 250 行 82MB → 268 行 126MB → **269 行 651MB**（该行是
    `function CS.UIScrollView.RestrictWithinBounds(instant) end`）→ 600 行 43s 内 >5GB → 整文件吃满机器。
    进程能跑完，不是死循环，但峰值无界。
  - **定位线索**：删掉该类 7 个 `UIScrollView.*` 自引用字段后 619MB → 225MB；手工合成
    （单类 + 60 个自引用字段 + 方法）不复现（58MB）→ 是**跨类传递解析的规模效应**，不是单个构造。
  - **覆盖面**：`Intersection.values/hasGeneric` 的签名在算集与深度护栏覆盖不到这条链，
    属「类型求值无深度守卫」族；根治需先定位具体解析链（load/index 侧的类/字段/泛型解析），
    可用 `tmp/prefix-sweep.ps1` + 调试器采样。
  - **临时规避**：扫描带 `--mem-limit=2`（默认 10GB 太高）；把这类工具生成的巨型 meta 加进
    `Lua.workspace.ignoreDir`。测量与复现脚本见 skill 的
    `references/workflow-and-style.md`「批量扫描与内存护栏」。
- **meta 模板语法缺口（2026-09-18 复查）**：`meta/template/{io,os,debug}.lua` 里的
  `---|>"r"`、`---|+"n"`（`|` 后的 `>` / `+` 项修饰符）会报 `miss-cat-name`，parser 未支持。
  `meta/template/basic.lua:292` 的 `(fun(t):((fun(t,k,v):any,any),any,any))|nil` 已支持
  （括号分组内的 `,` 不再让给外层列表，见提交 `13f4e624e`）。
