# 项目提示与协作规则

# 项目总览：vscode-lua-4 Language Server

## 项目定位

这是一个 **Lua 语言服务器**（Language Server），为 VS Code 提供 Lua 语言的智能提示、类型检查、诊断等功能。整个服务端逻辑使用 **Lua 5.5** 编写，运行在定制的 `lua-language-server` 可执行文件之上。

## 目录结构速览

```
server/
├── bin/                        # 编译好的可执行文件（lua-language-server.exe）
├── script/                     # 核心业务逻辑（Lua）
│   ├── node/                   # 类型节点系统（核心）
│   ├── parser/                 # Lua 源码解析器 → AST
│   ├── scope/                  # 作用域与文档管理
│   ├── runtime/                # 运行时初始化
│   ├── vm/                     # 虚拟机 / 编译器层
│   ├── lsp/                    # LSP 协议层
│   ├── config/                 # 配置管理
│   └── tools/                  # 工具函数
├── test/                       # 测试用例
│   ├── node/                   # Node 系统单元测试
│   ├── parser/                 # 解析器测试
│   └── coder/                  # VM 编译测试
├── meta/                       # Lua 标准库类型定义
├── 3rd/                        # 第三方库（bee.lua, lpeglabel 等）
├── test.lua                    # 测试入口
└── copilot-instructions.md     # AI 协作规范
```

## 核心数据流

```
Lua 源码
  ↓ script/parser/        词法分析 + 语法分析
AST（抽象语法树）
  ↓ script/vm/            编译为类型指令流（Flow）
Node 图（类型节点）
  ↓ script/node/          类型推断 / 收窄 / 求值
类型结果
  ↓ script/lsp/           格式化为 LSP 响应
VS Code 前端
```

## 运行测试

```bash
# Windows（在 server/ 目录下）
lua-language-server.exe test.lua
```

## 关键设计原则

1. **类型即节点**：所有类型信息均以 `Node` 对象表示，节点之间通过 `|`（union）、`&`（intersection）等操作组合。
2. **懒求值**：节点通过 `__getter` 延迟计算属性（如 `value`、`truly`、`falsy`）。
3. **作用域驱动**：每个 `Scope` 持有 `rt`（runtime），所有节点创建均需 scope 上下文。
4. **测试优先**：新增功能/修改逻辑必须在 `test/` 中补充对应测试。
