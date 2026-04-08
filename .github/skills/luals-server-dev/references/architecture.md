# 架构总览

## 启动流程
- `main.lua` 负责设置 GC、加载 `luals` 与 `master`，然后根据参数进入 `test.lua` 或启动 language server。
- `script/luals.lua` 负责创建全局 `ls` 表，并挂载核心工具、async/event-loop、JSON 模块与 inspect 能力。
- `script/master.lua` 负责设置 master 线程名、初始化 runtime 状态、配置日志并定时输出状态信息。
- `script/language-server/language-server.lua` 负责创建 server、启动 transport、分发任务并维护生命周期状态。

## 主要分层
- `script/parser/`：lexer、parser、AST 构建。语法和 LuaCats 解析改动通常放这里。
- `script/node/`：语义类型节点系统与 runtime helper。新增 node 模块必须在 `script/node/init.lua` 注册。
- `script/vm/`：virtual file、coder pipeline、contribute 系统以及类型执行相关逻辑。
- `script/scope/`：workspace/document 的归属、reload 生命周期和 scope 级服务。
- `script/feature/`：面向用户的语言特性，如 completion、definition 等 LSP 功能。
- `script/language-server/`：LSP transport 接入、client capability 协商、请求分发。
- `script/config/`：项目和 workspace 配置。
- `script/file/`、`script/filesystem/`、`script/runtime/`、`script/tools/`：底层平台、运行时与工具基础设施。

## 数据流
1. 文件内容先由 scope/document 管理层追踪。
2. parser 将源码编译成 AST。
3. VM coder 把 AST 转成 middle code 和 flow metadata。
4. runtime 与 tracer 基于这些信息构建语义值和 narrowing 结果。
5. feature 模块查询 VM/Node 模型，最终回答 LSP 请求。

## 重要边界
- parser 改动应停留在 parser/AST 模块，不要把语法逻辑塞进 feature。
- 新的语义值类型应放在 `script/node/`，并通过公开的 Node 接口暴露能力。
- flow-sensitive reasoning 优先走 `script/node/tracer.lua`。
- LSP 协议路由属于 `script/language-server/`，具体功能行为属于 `script/feature/`。

## 核心入口文件
- `main.lua`
- `script/luals.lua`
- `script/master.lua`
- `script/language-server/language-server.lua`
- `script/parser/compile.lua`
- `script/node/init.lua`
- `script/vm/init.lua`
- `test.lua`
