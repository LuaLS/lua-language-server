# 多线程架构文档

## 1. 概述

本项目采用**主线程 + 多工作线程**的并发模型。AST 解析与 Coder 中间代码生成均在**子线程**中完成，子线程将结果（纯字符串代码和简单数据结构）返回给**主线程**，由主线程执行这段代码来构建真正的 Node 类型图。

```
主线程 (master)
  │
  ├── Async.Master (coder-worker pool, 8 workers)
  │     │
  │     ├── Worker-1 (bee.thread)  ← 解析 Lua 文本，生成 Middle Code 字符串
  │     ├── Worker-2 (bee.thread)
  │     └── ...
  │
  └── 执行 Middle Code 字符串 → 构建 Node 类型图
```

底层通信通过 `bee.channel` 实现，是进程内线程间的消息队列。

---

## 2. 关键文件

| 文件 | 线程 | 职责 |
|------|------|------|
| `script/async/master.lua` | 主线程 | 管理 Worker 池，调度任务队列 |
| `script/async/worker.lua` | 主线程 | 创建单个 Worker 线程，管理请求/响应 Channel |
| `script/async/worker-init.lua` | **子线程** | 子线程启动入口，事件循环，转发请求到模块方法 |
| `script/vm/coder/coder.lua` | 两侧 | 主线程持有 Coder 对象；子线程执行 `makeFromAst` 生成代码 |
| `script/vm/coder/coder-worker.lua` | **子线程** | Worker 的请求处理模块，暴露 `makeCode` 方法 |
| `script/vm/virtual_file.lua` | 主线程 | 驱动 `awaitMakeCoder`（异步）或 `makeCoder`（同步）编译流程 |

---

## 3. 通信协议

通信使用**结构化表**（Lua table），由 `bee.channel:push` / `:pop` 序列化传输。

### 请求格式（主线程 → 子线程）

```lua
{
    id     = <integer>,   -- 请求 ID（仅 request 模式有；notify 无）
    method = "makeCode",  -- 方法名
    params = {
        text   = <string>,  -- Lua 源代码文本
        source = <Uri>,     -- 文件 URI（用于错误定位）
    },
}
```

### 响应格式（子线程 → 主线程）

```lua
{
    id     = <integer>,   -- 对应请求的 ID
    result = {
        code           = <string>,  -- 生成的 Middle Code 字符串
        tracerFlowMap  = <table>,   -- Tracer 流程图数据（见 §6）
        parentMap      = <table>,   -- 父子节点映射
    },
    -- 或者
    error  = <string>,    -- 错误信息（xpcall 捕获）
}
```

---

## 4. ⚠️ 跨线程传递的限制

子线程通过 `bee.channel` 向主线程传递数据时，**只能传递可序列化的简单值**：

- ✅ 字符串 (`string`)
- ✅ 数字 (`number`)
- ✅ 布尔值 (`boolean`)
- ✅ 嵌套 table（只含上述类型的值）
- ❌ **不能传递含 `__index`/`__newindex` 等元方法的复杂对象**（如 Node、Class 实例）
- ❌ **不能传递函数** (`function`)
- ❌ **不能传递 userdata / thread**

### 实际传递的数据

子线程只传递：
1. **`code`**：Middle Code 是一段 Lua 源代码**字符串**，主线程通过 `load(code, ...)` 编译并执行它。
2. **`tracerFlowMap`**：一个纯数据表，描述控制流信息（tag + 变量名等字符串），供主线程的 Tracer 使用。
3. **`parentMap`**：变量父子路径映射（字符串 → 字符串数组）。

---

## 5. 完整编译流程

```
文件变更事件
    │
    ▼
VM.Vfile:awaitIndex()          ← 主线程调用（async）
    │
    ▼
VM.Vfile:awaitMakeCoder()      ← 向 coder Worker 池发出请求（await）
    │ (bee.channel push)
    ▼
[子线程] coder-worker.lua      ← 接收请求
    │
    ├── parser.compile(text)   ← 解析 Lua 文本为 AST
    │
    └── Coder:makeFromAst(ast) ← 遍历 AST，生成 Middle Code 字符串
                                  同时构建 tracerFlowMap 和 parentMap
    │ (bee.channel push 结果)
    ▼
主线程收到响应
    │
    ├── load(result.code)      ← 编译 Middle Code 为 Lua 函数
    ├── coder.tracerFlowMap    ← 存储流程图数据
    └── coder.parentMap        ← 存储父子映射
    │
    ▼
Coder:run(vfile)               ← 执行 Middle Code，构建 Node 类型图
    │
    └── func(coder, vfile)     ← 在主线程环境中运行，可以访问 rt、Node 等复杂对象
```

---

## 6. Flow（控制流类型收窄）的架构演变

### 6.1 旧方案（子线程插入 typeGuard 代码）

**已废弃，但代码保留供参考**，主要位于：
- `script/vm/coder/flow.lua`（`Coder.Flow`、`Coder.Branch` 等类）
- `script/vm/coder/branch.lua`（`Coder.Branch.Child` 等）

**旧方案原理**：

Coder（在子线程）遍历 AST 时，在每个 `if`/`and`/`or` 条件处直接插入 typeGuard 相关的 Lua 代码到 Middle Code 中，例如：

```lua
-- 旧方案生成的 Middle Code 片段（示意）
r["narrow|if|1|x"] = rt.narrow(r["x"]):matchTruly()
r["shadow|if|1|x"] = r["x"]:shadow(r["narrow|if|1|x"])
-- ... if block body uses r["shadow|if|1|x"] instead of r["x"]
```

每一条可能影响类型的条件表达式都会生成对应的 narrow/shadow 语句。

**旧方案的问题**：

当遇到 `assert(x)` 这样的调用时，需要在**每一个 `call` 节点处**都插入 typeGuard 代码来检查函数是否具有 assert 语义。这意味着每个函数调用都要在 Middle Code 中增加额外的窄化代码，代码膨胀严重，且逻辑复杂，被认为"无法接受"。

### 6.2 新方案（主线程 Tracer 自上而下计算）

**当前实现**，核心文件为 `script/node/tracer.lua`。

**新方案原理**：

1. **子线程（Coder）阶段**：只负责收集**流程结构信息**（`tracerFlowMap`），不在 Middle Code 中生成任何 typeGuard 代码。`tracerFlowMap` 是一个描述控制流节点顺序和层次关系的纯数据表（Flow DSL）。

2. **主线程（Tracer）阶段**：当需要查询某个位置的变量类型时，Tracer 从函数入口开始，依据 `tracerFlowMap` **自上而下**模拟执行，在遇到条件节点时动态计算类型收窄，最终得出目标位置的精确类型。

**关键优势**：
- **按需计算**：只在需要时（如 hover、定义跳转）才运行 Tracer，而非为所有节点都预计算。
- **支持 assert**：`assert(x)` 只需在 Tracer 的 `traceConditionUnit` 中处理函数调用的返回值窄化，无需在 Middle Code 中对每个 call 插入代码。
- **中间数据简单**：`tracerFlowMap` 是纯数据，可安全地跨线程传递。

### 6.3 两方案并存的现状

目前 `Coder.Flow`/`Coder.Branch` 相关代码**仍然保留**，但已不再被主流程使用（已被新 Tracer 方案替代）。保留原因：

- 搬迁尚未完成，旧代码可供参考对照新方案逻辑。
- 部分边缘功能（如 `Coder.Variable.Link` 关联变量传播）尚未迁移到新 Tracer。

---

## 7. Worker 池管理（Async.Master）

`Async.Master`（`script/async/master.lua`）维护一个 Worker 池：

```lua
-- 当前 coder 池配置（coder.lua 中）
M.coderMaster = ls.async.create('coder', 8, 'vm.coder.coder-worker', true)
--                                          ^ 8 个 Worker 线程
```

调度策略：
- **请求（request）**：完成后 Worker 放回队首（最近空闲优先）。
- **通知（notify）**：不等待结果，Worker 放回队尾（保守处理）。
- 任务通过 `LinkedTable` 实现的队列按顺序分配。

### 防抖与版本控制

`VM.Vfile` 中实现了文件编译防抖：

```lua
-- virtual_file.lua 关键逻辑
if self.indexingVersion then
    -- 正在编译中，只记录最新版本号
    if version > self.nextVersion then
        self.nextVersion = version
    end
    -- 等待当前编译完成
    ls.await.yield(function (resume)
        self.onDidIndex:once(resume)
    end)
    if self.nextVersion ~= version then
        return  -- 有更新版本，跳过本次编译
    end
end
```

这确保高频文件修改时不会产生大量冗余编译任务。

---

## 8. 同步 vs 异步编译

`VM.Vfile` 提供两种编译路径：

| 方法 | 使用场景 | 特点 |
|------|----------|------|
| `M:index()` + `M:makeCoder(document)` | 测试环境 / 同步场景 | 直接在当前线程解析和编译，阻塞 |
| `M:awaitIndex()` + `M:awaitMakeCoder(file)` | 正常运行时 | 将解析工作发往子线程，`await` 异步等待结果 |

在 `coder.lua` 中：
```lua
-- 同步（测试/调试用）
function M:makeFromAst(ast)
    -- 直接在当前线程编译 AST
end

-- 异步（生产环境）
function M:makeFromFile(file)
    local result = self.coderMaster:awaitRequest('makeCode', {...})
    -- 等待子线程返回 code 字符串再 load
end
```

---

## 9. 子线程环境初始化

子线程通过 `async/worker-init.lua` 启动，流程如下：

1. 重新设置 `package.searchers`（子线程不继承主线程的模块缓存）。
2. 创建专属 `Log` 对象，日志通过 `bee.channel('log')` 发回主线程打印。
3. 可选附加调试器（`lua-debug`）。
4. 进入基于 `bee.epoll` 的事件循环，等待 `requestChannel` 有数据时调用 `module.resolve(method, params)`。

> **注意**：子线程中 `require 'vm'` 会重新执行一遍 VM 模块初始化，但不会创建 `Async.Master`（因为 `ls.threadName ~= 'master'`），避免递归创建 Worker 的问题。

---

## 10. 常见陷阱与注意事项

1. **不要在传递给子线程的 `params` 中放入复杂对象**  
   只传字符串、数字、布尔值、简单 table。Node 实例、Class 对象、函数等均不可传递。

2. **Middle Code 在主线程环境（`self.env = _G`）中执行**  
   Middle Code 可以访问主线程的全局变量（`rt`、`rt.UNKNOWN`、Node 构造函数等），这是设计意图。

3. **`tracerFlowMap` 是跨线程的关键数据**  
   子线程生成它，主线程的 Tracer 消费它。必须保证其内容只含简单值（字符串、数字、嵌套 table）。

4. **Flow/Branch 旧代码与新 Tracer 并存**  
   修改类型收窄逻辑时，应优先修改 `script/node/tracer.lua`（新方案），不要再向 `script/vm/coder/branch.lua` 或 `script/vm/coder/flow.lua` 添加新功能。

5. **Worker 数量硬编码为 8**  
   目前 `coder` Worker 池固定 8 个线程（见 `coder.lua`），未来可根据 CPU 核心数动态调整。
