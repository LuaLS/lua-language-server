# 已知问题 / 待办

- **加载期内存爆炸已根治（2026-09-20）**：元凶不是 node/tracer，而是 **parser 里同一位置的注释被反复解析**。
  - **触发文件**：`d:\github\vscode-lua\server\meta\default utf8\CS.lua`（659KB / 14408 行，
    Unity+NGUI 生成的 C# 绑定 meta；`---@source <url>` 未知注解与连续 `--` 注释块、类/字段注解、
    语句交替出现）。
  - **机制**：解析注解时 `parseCatUnion` 等会 `skipSpace` 跨行看到后面的注释 → `skipComment`
    重新解析该注释并再次塞进 `curBlock.delayComments`；每条语句后都会跑一次
    `parseDelayedComments`，于是队列反复膨胀（`ast.comments` 从应有的 ~239 涨到 545519，
    同一条注释被解析 361 次）。表现是**加载/索引阶段**内存超线性增长
    （前缀 269 行 651MB → 600 行 >5GB → 整文件吃满机器）。
  - **修法**：`script/parser/ast/ast.lua` 的 `skipComment` 按注释起始位置去重
    （`self.parsedComments`）；重复遇到时短注释直接 `moveTo(comment.finish + 1)` 跳过
    （与 `parseShortComment` 的落点等价），长注释仍走 `parseComment` 但不再登记。
  - **实测**：同一文件解析 0.82s / +17.6MB / 11656 条注释（修复前 >10GB）；
    `meta/default utf8` 整目录 191 文件扫描从「9s 内被 3GB 护栏杀掉」变为
    「98s 完成，峰值 1745MB」。
  - **回归**：`test/parser/ast/cat.lua` 末尾的注释数断言（`---@source` + 连续 `--` 块 + 语句 ×20，
    断言 `#ast.comments == 200`）；修复前该形状会膨胀到 2 倍以上。
- **批量扫描时 worker 编译个别生成型 meta 会抛 `Source is nil`（2026-09-20，未解决）**：
  扫 `meta/default utf8` 全目录时，`UnityEngine.lua` 的 `makeCode` 请求在 worker 里失败
  （`coder.lua` `M:compile(nil)` → `Source is nil`，master 侧表现为
  `attempt to index a nil value (local 'result')`，该文件因此没被索引）；单独扫同一个文件不复现，
  疑似与并发/累计状态有关。属 coder 健壮性问题，需要时再深挖。
- **meta 模板语法缺口（2026-09-18 复查）**：`meta/template/{io,os,debug}.lua` 里的
  `---|>"r"`、`---|+"n"`（`|` 后的 `>` / `+` 项修饰符）会报 `miss-cat-name`，parser 未支持。
  `meta/template/basic.lua:292` 的 `(fun(t):((fun(t,k,v):any,any),any,any))|nil` 已支持
  （括号分组内的 `,` 不再让给外层列表，见提交 `13f4e624e`）。
- **meta 模板语法缺口（2026-09-18 复查）**：`meta/template/{io,os,debug}.lua` 里的
  `---|>"r"`、`---|+"n"`（`|` 后的 `>` / `+` 项修饰符）会报 `miss-cat-name`，parser 未支持。
  `meta/template/basic.lua:292` 的 `(fun(t):((fun(t,k,v):any,any),any,any))|nil` 已支持
  （括号分组内的 `,` 不再让给外层列表，见提交 `13f4e624e`）。
