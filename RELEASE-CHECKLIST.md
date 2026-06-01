# lua-language-server 4.x 正式发布功能清单

> 本文件仅追踪**功能完整性**（不含 Bug 修复与性能优化）。  
> `[x]` = 已实现；`[ ]` = 待实现。

---

## 1. 基础架构

- [x] 词法/语法解析器（Parser / AST）
- [x] LuaCats 注解解析框架
- [x] 类型系统（Node 体系：union / intersection / function / table / class / alias / generic / array / tuple）
- [x] 类型推导引擎（VM / Coder / Tracer）
- [x] 类型窄化（Narrowing / @cast）
- [x] Scope / 工作区管理（多根目录）
- [x] 文档同步（didOpen / didChange / didClose）
- [x] LSP 生命周期消息（initialize / initialized / shutdown / exit / cancelRequest）
- [x] 配置系统（`.luarc.json` 加载与生效）
- [ ] 工作区文件变更监听（`workspace/didChangeWatchedFiles`）
- [ ] 服务端主动拉取配置（`workspace/configuration`）

---

## 2. LuaCats 注解支持

### 2.1 类型声明

- [x] `@class`（含继承 `:Base`、属性 `exact` / `partial`）
- [x] `@field`（public / private / protected）
- [x] `@type`
- [x] `@alias`
- [x] `@enum`（解析器支持）
- [ ] `@operator`
- [ ] `@module`
- [ ] `@meta`

### 2.2 函数注解

- [x] `@param`
- [x] `@return`
- [x] `@generic`
- [x] `@vararg`
- [x] `@overload`
- [x] `@async`（函数属性）
- [ ] `@nodiscard`

### 2.3 控制与标记

- [x] `@cast`（局部变量类型断言）
- [x] `@see`（交叉引用）
- [ ] `@deprecated`
- [ ] `@diagnostic`（行级诊断开关）
- [ ] `@version` / `@since`（版本标注）
- [ ] `@private` / `@protected` / `@public`（访问修饰符）

---

## 3. 类型推导能力

- [x] 局部变量推导
- [x] 全局变量推导
- [x] 字面量类型（string / number / boolean / nil）
- [x] 函数返回值推导（多返回值 / vararg）
- [x] 表字段推导
- [x] 数组类型 `T[]`
- [x] 泛型实例化推导
- [x] 元表 / `setmetatable` 推导
- [x] 控制流类型窄化（if / while / assert）
- [ ] 标准库函数精确返回类型（如 `rawlen()→integer`、`tostring()→string`）
- [ ] `@nodiscard` 语义检查
- [ ] `@deprecated` 语义标记与警告

---

## 4. 语言特性（LSP Language Features）

### 4.1 已实现

- [x] **悬停提示**（Hover）
  - [x] 变量 / 局部 / 全局
  - [x] 函数签名（含多返回、泛型、method）
  - [x] 字段与 tablefield
  - [x] 类型展示（union 拆分多 item）
  - [x] 字面量与表结构
  - [x] `@see` 引用
- [x] **跳转到定义**（Go-to-Definition）
  - [x] 局部 / 全局变量定义
  - [x] 函数定义
  - [x] 字段定义
  - [x] `require` 模块跳转
- [x] **代码补全**（Completion）
  - [x] 关键字补全
  - [x] 局部 / 全局变量补全
  - [x] 字段访问补全（`.` / `:`）
  - [x] LuaCats 注解标签补全
  - [x] 字符串枚举补全（`"a"|"b"|"c"` 等）
  - [x] 后缀补全（Postfix `@`）
  - [x] 工作区词语补全（Text）

### 4.2 待实现

- [ ] **跳转到实现**（Go-to-Implementation）
- [ ] **查找所有引用**（Find All References）
- [ ] **重命名符号**（Rename Symbol）
- [ ] **诊断 / 代码检查**（Diagnostics / publishDiagnostics）
  - [ ] 未定义全局变量
  - [ ] 类型不匹配
  - [ ] 未使用变量
  - [ ] `@deprecated` 引用警告
  - [ ] `@nodiscard` 返回值丢弃警告
  - [ ] `@diagnostic` 注解控制
  - [ ] 注入字段（inject-field）
  - [ ] 缺失字段（missing-fields）
- [ ] **函数签名帮助**（Signature Help）
- [ ] **文档符号**（Document Symbols）
- [ ] **工作区符号搜索**（Workspace Symbols）
- [ ] **语义高亮**（Semantic Tokens）
- [ ] **内嵌提示**（Inlay Hints）
  - [ ] 参数名提示
  - [ ] 变量类型提示
- [ ] **代码透镜**（Code Lens）
  - [ ] 引用数量提示
- [ ] **折叠范围**（Folding Range）
- [ ] **文档高亮**（Document Highlights）
- [ ] **调用层级**（Call Hierarchy）
- [ ] **类型层级**（Type Hierarchy）
- [ ] **代码操作**（Code Actions）
  - [ ] 自动修复 / 快速修复
  - [ ] 注入字段补全
- [ ] **代码格式化**（Document Formatting / Range Formatting，集成 EmmyLuaCodeStyle）

---

## 5. 标准库 Meta 文件

- [x] Lua 5.4
- [x] Lua 5.5
- [x] LuaJIT
- [ ] Lua 5.1
- [ ] Lua 5.2
- [ ] Lua 5.3

---

## 6. 第三方 Meta 库

- [x] love2d
- [x] lovr
- [x] OpenResty
- [x] skynet
- [x] Defold
- [x] Cocos 4.0
- [x] busted
- [x] luassert
- [x] luv
- [x] lfs
- [x] luaecs
- [x] ffi-reflect
- [x] Jass
- [ ] …（按需持续扩展）

---

## 7. 配置项支持

- [x] `.luarc.json` 文件读取与应用
- [ ] 完整配置项 Schema 覆盖（对齐 3.x `Lua.*` 所有选项）
- [ ] VSCode 扩展 `settings.json` 实时同步
- [ ] `workspace/didChangeConfiguration` 通知处理

---

## 8. 测试覆盖

- [x] Parser / AST 测试
- [x] Node / Tracer 测试
- [x] VM / Coder 测试
- [x] Feature 测试
  - [x] Hover 测试
  - [x] Definition 测试
  - [x] Completion 测试（keyword / word / field / luadoc / string / postfix / special）
- [ ] Diagnostics 测试
- [ ] Rename 测试
- [ ] References 测试
- [ ] Signature Help 测试
- [ ] Inlay Hints 测试
