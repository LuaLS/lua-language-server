# Tasks

## 1. 取证与实现

- [x] 1.1 读取 F4 与失败记录，保存目标工程基线到 tmp/short-circuit-before.txt。
- [x] 1.2 添加短路成对诊断测试，验证修复前失败、真实不匹配仍报。
- [x] 1.3 实现右操作数限定的变量身份通道，验证相关诊断套件通过且不外泄。

## 2. 验证与记账

- [x] 2.1 目标工程基线比对：--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2，确认本例移除且新增 0；否则撤回实现。
- [x] 2.2 bin\lua-language-server.exe --test 全量绿。
- [x] 2.3 把结论上提成一条 fact 并跑 --test tools.facts，更新项目实践.md 与提案实测数字。
- [x] 2.4 读取本仓库问题面板 information 及以上并处理本轮问题，验证为 0；严格验证 OpenSpec 变更。

## 3. 按语义重新分诊完整方案

- [x] 3.1 阅读 compile.lua:3697 的赋值及控制流，核实 lastVar/lastValue 能否为 nil，记录新增诊断语义结论。
- [x] 3.2 保存当前基础值基线，重放完整方案并检查新增与额外移除条目；真实新增允许，误报与错误类型掩盖不得接受。
- [x] 3.3 用最小回归验证分诊结论，按结果修正实现或保持基础值范围；全量 --test 与目标基线比对验证。
- [x] 3.4 更新事实与轮次记录，跑 --test tools.facts、OpenSpec 严格验证，并核对本仓库 information 及以上问题面板。
