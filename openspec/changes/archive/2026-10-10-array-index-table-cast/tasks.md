# Tasks

## 1. 定位与修复

- [x] 1.1 检查目标语义与 type-check 台账，保存 tmp/array-index-before.txt 的 98 条基线。
- [x] 1.2 添加最小诊断与节点正负向测试，确认修复前失败并定位拦截层。
- [x] 1.3 在 Node 层最小修复，相关诊断与节点测试通过。

## 2. 验证与记账

- [x] 2.1 目标工程基线比对：--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2，检查本例及每条差异语义。
- [x] 2.2 bin\lua-language-server.exe --test 全量绿。
- [x] 2.3 把结论上提成一条 fact 并跑 --test tools.facts，更新项目实践.md 与实测数字。
- [x] 2.4 检查本仓库问题面板 information 及以上并处理本轮警告，严格验证 OpenSpec。
