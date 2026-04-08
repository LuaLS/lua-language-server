---
name: luals-server-dev
description: '用于开发 lua-language-server server 仓库的项目 skill。适用于修改 parser、LuaCats、Node runtime、VM/coder、tracer narrowing、language-server/LSP、completion provider、workspace scope、configuration 或 tests。包含项目架构、模块分工、代码风格、调试流程与验证命令。'
argument-hint: '请描述你要修改的子系统或功能，例如 parser 语法、tracer narrowing、completion provider、LSP 请求处理。'
---

# LuaLS Server 开发

当你在这个 server 仓库内开发，需要项目专属上下文而不是通用 Lua 建议时，使用这个 skill。

## 何时使用
- 需要新增或修改 parser、AST、LuaCats 相关行为。
- 需要新增或修改 Node runtime 类型、类型推断或 narrowing。
- 需要排查 VM coder 输出、tracer narrowing、flow 相关问题。
- 需要实现或调整 language-server、feature 下的 LSP 功能。
- 需要在 test/parser、test/node、test/coder、test/feature 中新增、迁移或修复测试。
- 在动手编辑前，需要快速了解仓库约束、代码风格和验证命令。

## 仓库入口
- 进程启动链路：`main.lua` -> `script/luals.lua` -> `script/master.lua` -> `script/language-server/language-server.lua`。
- 测试启动链路：`main.lua` 在 `ls.args.TEST` 模式下进入 `test.lua`。
- 全局启动对象：`script/luals.lua` 中初始化的 `ls`。

## 开发规则
- 从 server 根目录运行测试：`bin\\lua-language-server.exe --test <suite-or-file>`。
- 正常功能开发不要运行 `PreCompile` 或 `Compile` 任务。
- 改动保持小而聚焦，避免无关重构和整仓格式化。
- 临时调试输出统一放到 `tmp/`。
- narrowing 优先走 `script/node/tracer.lua`，不要把新 narrowing 逻辑加到 `script/vm/coder/flow.lua` 或 `script/vm/coder/branch.lua`。
- 如果 tracer 报 `No such key`，先检查 middle code 和 flow 产物，不要先加防御式绕过。

## 使用步骤
1. 先看 [architecture](./references/architecture.md)，确认你要改的能力属于哪个子系统。
2. 再看 [module map](./references/module-map.md)，确认应该落在哪些文件和扩展点。
3. 按 [workflow and style](./references/workflow-and-style.md) 中的项目约定实施修改。
4. 保持最小改动，遵守已有模块边界。
5. 运行最小相关测试，再根据需要扩展验证范围。

## 快速路由
- 改 parser 或语法：先看 [architecture](./references/architecture.md) 和 `script/parser/`。
- 改类型节点或 runtime：先看 [module map](./references/module-map.md) 和 `script/node/`。
- 改 VM、coder、tracing、flow：先看 [module map](./references/module-map.md) 和 `script/vm/`。
- 改 LSP 请求处理：重点看 `script/language-server/` 和 `script/feature/`。
- 改 completion：重点看 `script/feature/completion/`、`script/feature/text-scanner.lua` 和 completion tests。
- 增加测试或排查回归：先看 [workflow and style](./references/workflow-and-style.md) 和 `test/`。

## 高价值触发词
- "修改 parser"
- "新增 LuaCats 语法"
- "增加 node type"
- "排查 tracer narrowing"
- "检查 middle code"
- "修复 completion provider"
- "实现 LSP feature"
- "增加 feature test"
- "了解项目架构"
