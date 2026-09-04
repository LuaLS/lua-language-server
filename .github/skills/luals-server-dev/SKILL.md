---
name: luals-server-dev
description: '用于开发 lua-language-server server 仓库的项目 skill。适用于修改 parser、LuaCats、Node runtime、VM/coder、tracer narrowing、language-server/LSP、workspace scope、configuration 或 tests。也适用于 completion（补全）相关的一切：字段/成员补全、word 与关键字补全、字符串枚举补全、luadoc 补全、setmetatable/metatable/__index 推导、workspaceWord/showWord 词补全、postfix、definition、hover 等 feature 行为。包含项目架构、模块分工、代码风格、调试流程与验证命令。'
argument-hint: '请描述你要修改的子系统或功能，例如 parser 语法、tracer narrowing、completion 补全（字段/word/metatable/luadoc/字符串枚举）、LSP 请求处理。'
---

# LuaLS Server 开发

当你在这个 server 仓库内开发，需要项目专属上下文而不是通用 Lua 建议时，使用这个 skill。

## 何时使用
- 需要新增或修改 parser、AST、LuaCats 相关行为。
- 需要新增或修改 Node runtime 类型、类型推断或 narrowing。
- 需要排查 VM coder 输出、tracer narrowing、flow 相关问题。
- 需要实现或调整 completion 补全：字段补全、word/关键字补全、字符串枚举、luadoc 补全、
  setmetatable/metatable/__index 推导、workspaceWord/showWord 词补全、postfix 等。
- 需要实现或调整 language-server、feature 下的其他 LSP 功能（definition、hover 等）。
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
- **新增文件可以，但尽量不要删除文件**：`del`/`rm` 等删除操作会被拦截，需用户手动确认。尽量复用已有文件或就地修改；确需清理时先征询用户。
- narrowing 优先走 `script/node/tracer.lua`，不要把新 narrowing 逻辑加到 `script/vm/coder/flow.lua` 或 `script/vm/coder/branch.lua`。
- 如果 tracer 报 `No such key`，先检查 middle code 和 flow 产物，不要先加防御式绕过。
- 术语约定："诊断"一词只表示 VSCode 问题面板中由 LSP 提供的静态分析结果（警告或错误等级），无需编译、运行。涉及诊断时应当通过工具查看问题面板，并根据最近改动研究是哪些改动导致的，而不是跑测试或清理调试输出。
- Windows PowerShell 写入文件必须指定 `-Encoding UTF8`（默认 GBK/UTF-16 LE 会破坏源码）；项目源码统一 UTF-8 无 BOM。
- 测试 harness（`TEST_INDEX` / `TEST_COMPLETION`）运行在**裸环境，无标准库**。用例若需 `string`/`table`/`ipairs`/`select` 等标准库函数，用 `--!include <name>` 宏手动导入（见 `test/include.lua` 的 `test.includeCodes`），或自行定义。用例尽量写抽象通用代码。

## 使用步骤
1. 先看 [architecture](./references/architecture.md)，确认你要改的能力属于哪个子系统。
2. 再看 [module map](./references/module-map.md)，确认应该落在哪些文件和扩展点。
3. 按 [workflow and style](./references/workflow-and-style.md) 中的项目约定实施修改。
4. 保持最小改动，遵守已有模块边界。
5. 运行最小相关测试，再根据需要扩展验证范围。

> 注：已搁置方向的调研结论见 [tree-sitter 预研记录](./references/tree-sitter-pre-research.md)（已暂停，重启前先读该文档第 5 节与第 8 节）。
>
> 注：已知问题见 [known-issues](./references/known-issues.md)。
>
> 注：assert 签名注解收窄规划见 [assert-narrow-plan](./references/assert-narrow-plan.md)。
>
> 注：Task / Await / Progress 并发系统（取消语义、让出点、进度条）见 [task-await-progress](./references/task-await-progress.md)。

## 快速路由
- 改 parser 或语法：先看 [architecture](./references/architecture.md) 和 `script/parser/`。
- 改类型节点或 runtime：先看 [module map](./references/module-map.md) 和 `script/node/`。
- 改 VM、coder、tracing、flow：先看 [module map](./references/module-map.md) 和 `script/vm/`。
- 改 LSP 请求处理：重点看 `script/language-server/` 和 `script/feature/`。
- 改长耗时任务的让出点、取消逻辑或进度条：先看 [task-await-progress](./references/task-await-progress.md)。
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
- "加进度条或取消功能"
- "长任务卡住其他请求"
