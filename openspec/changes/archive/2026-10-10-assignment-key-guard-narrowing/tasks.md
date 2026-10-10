# Tasks

## 1. 取证与实现

- [x] 1.1 保存 97 条基线、读取源码语义，确认 probe 读 key 为 string 而诊断仍报。
- [x] 1.2 增加最小诊断正负向测试，验证并定位工程差异。
- [x] 1.3 基于取证最小修复，相关节点/诊断测试通过。

## 2. 验证与记账

- [x] 2.1 目标工程基线比对：--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2；分诊新增移除。
- [x] 2.2 bin\lua-language-server.exe --test 全量绿。
- [x] 2.3 把结论上提成一条 fact 并跑 --test tools.facts，更新项目实践.md 与实测数字。
- [x] 2.4 本仓库问题面板 information 及以上清理，OpenSpec 严格验证通过。
