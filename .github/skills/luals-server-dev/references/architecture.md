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

## 类型语义约定
- **数组默认无 nil 元素**：`T[]` 等价于 `{ [integer]: T }`——用整数下标取值得到 `T`（不是 `T | nil`），
  只有显式写成 `T?[]`（元素类型是 `T?`）才需要 nil 检查。`Node.Array:get` 返回 `head` 即是此约定，
  不要在数组下标路径上补 nil。
- **下标不是合法类型时按数组处理**：`T[...]` 里 `...` 解析不出类型（如 C# 生成工具写出的 `float[*,*]`）时，
  `parseCatIndex` 产出 `CatArray`（即 `{[integer]: T}`），错误照常上报，但**不得**产出 `index = nil`
  的 `CatIndex`（coder 会 `compile(nil)`，导致整个文件编译失败、静默不进索引）。
- **未知调用的多返回值每个位置都是 `any`**：`local a, b, c = f()` 里 `f` 是 `any`（或 `---@return table`
  模块上的未知字段）时，`matchedFuncs` 为空，`Node.FCall:select` 必须在任意位置都返回 `returns`（`any`），
  不能走 `Node:select` 基类（那里非 list 值只有位置 1 存在，其余给 `never`）。
  回归：`test/coder/multi-return.lua`。
- **右值不够时，多余的变量是 `nil`**：`local a, b = 1` 里 `b` 为 `nil`（coder 侧给 `rt.NIL` 赋值，
  见 `script/vm/coder/state.lua` 的 `localdef`）。注意 `local x`（完全没有初始值）仍走旧路径（不赋任何值），
  读它会把后续赋值并入（`local x; X0 = x; x = 10; x = 5` → `5 | 10`），这是另一处待修语义。
  回归：`test/coder/multi-return.lua`。
- **按返回值相等反推实参类型时，不得比实参自己的类型更宽**：`if get(uri, key) == 'x'` 这类比较会用
  被调函数的形参类型反推实参（`traceCallEqual` + `Node.Narrow:asCall`）。反推值只是「形参要求什么」，
  不能成为实参的读值：形参注解可选（`uri?`）时会把实参染成 `uri | nil`，实参已确定不是 nil 时同理
  （`if not args then return end` 之后）。`traceCallEqual` 里因此有两道约束——反推结果必须能 cast 到实参
  自己的类型（`getExpectValue`），且实参「确定不是 nil」时要按同名去掉反推结果里的 nil。
  回归：`test/coder/narrow-branch.lua`。注意 `Node.FCall` 的 `link`/`traceCallTruthy` 走同一套语义，
  改动需一起考虑（`type(x) == 'string'` 一族的收窄依赖这里的反推，`test/coder/flow.lua` 已钉住）。

## 核心入口文件
- `main.lua`
- `script/luals.lua`
- `script/master.lua`
- `script/language-server/language-server.lua`
- `script/parser/compile.lua`
- `script/node/init.lua`
- `script/vm/init.lua`
- `test.lua`
