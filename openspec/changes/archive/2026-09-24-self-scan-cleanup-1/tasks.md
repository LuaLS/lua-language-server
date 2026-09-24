# Tasks

- [x] 读本仓库自扫报告（514 条 / 129 文件）并分类成因（见 proposal 的表）
- [x] 规则写进 `AGENTS.md`：第 0 节第 6 条「自主迭代收尾必清本仓库的警告」+ 第 8 节指向
- [x] 清第一批：删遗留全局（`tracer.lua:381`）、补 `Node.Tracer` 的 `@field`、
      补 `ls.args` 的探针开关声明、补探针工具的形参注解
- [x] 跑全量 `bin\lua-language-server.exe --test`（绿）
- [x] 自扫复核：514 → **508**（`undefined-field` 98→93、`lowercase-global` 3→2）
- [x] 存自扫基线 `tmp/self-scan-baseline.txt` 供后续轮次 `--baseline` 比对
- [x] 记「试过但未采用」：未注册表上的 `@field` 不生效（`ActivePool`）
- [x] 同步 `项目实践.md`（自扫一节 + 第六轮纪要）
- [x] `openspec archive self-scan-cleanup-1`
