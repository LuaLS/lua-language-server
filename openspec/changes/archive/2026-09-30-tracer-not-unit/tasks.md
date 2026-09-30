# Tasks

> 基线 `tmp\scan-156.txt`（156）；命令模板（根目录，`--mem-limit=2` 必带，不并发）：
> `bin\lua-language-server.exe --test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-156.txt`

- [x] 1.1 定位：探针确认实参读点 `currentValue = nil`、返回值读点正常；`--probe-flow` 看到 ref 嵌在 `{'not', ...}`；
  `W:traceRef` 插桩证明该别名从未被走
- [x] 1.2 改 `script/node/tracer.lua` 的 `W:traceUnit`：`'and' / 'or'` 分支扩到 `'not'`
- [x] 1.3 回归测试：`test/node/tracer.lua` 加用例（`not not v` 内的读点在守卫内应得 `integer`）；
  验证：撤掉修法立刻红（`expected: integer, actual: integer | nil`）—— 已实测
- [x] 1.4 目标工程比对：**156 → 154（移除 2 / 新增 0）**（`tmp/cmp-not-unit2.txt`）；
  两条为 `plugins/astHelper.lua:72`（用户报的）与 `core/diagnostics/undefined-doc-name.lua:26`
- [x] 1.5 全量测试绿：`bin\lua-language-server.exe --test`；`--test node.tracer` 绿
- [x] 1.6 本仓库问题面板 0
- [x] 1.7 `facts/narrowing.md` 记一条（值位置 `not` 子树必须走一遍；与 F4 / F27 区分），
  `--test tools.facts` 绿
- [x] 1.8 归档 `openspec archive tracer-not-unit`，更新 `项目实践.md` 第二十三轮
