# 新增语言特性完整流程

本文档描述在本项目中新增一个 Lua 语言特性（语法 + 类型支持）的完整步骤。

## 概览：四层改动

```
① Parser（解析层）    script/parser/ast/
② VM/Coder（编译层）  script/vm/coder/
③ Node（类型层）      script/node/
④ Test（测试层）      test/
```

---

## 场景 A：新增一种类型收窄条件

**例子**：新增对 `typeof(x) == "string"` 的收窄支持

### 步骤

1. **解析层**（如需新语法）  
   在 `script/parser/ast/exp.lua` 或对应文件中识别 `typeof` 调用。

2. **VM/Coder 层**  
   在 `script/vm/coder/` 中，将 `typeof(x) == "string"` 编译为 tracer flow 中的新 condition exp：
   ```lua
   { 'typeof==', { 'ref', 'x', 'x1' }, 'v', { 'value', 'type_string' }, 'v' }
   ```

3. **Node.Tracer 层**（`script/node/tracer.lua`）  
   在 `traceConditionUnit` 中添加分支：
   ```lua
   elseif kind == 'typeof==' then
       self:traceTypeofEqual(exp, revert)
   ```
   实现 `traceTypeofEqual` 方法，调用适当的 narrowing 逻辑。

4. **测试层**（`test/node/tracer.lua`）  
   添加 `do...end` 块，验证新收窄行为。

---

## 场景 B：新增 EmmyLua 注解标签

**例子**：新增 `---@deprecated` 注解

### 步骤

1. **解析层**  
   在 `script/parser/ast/cats/` 创建 `deprecated.lua`：
   ```lua
   local M = {}
   function M:parse(reader)
       -- 解析 ---@deprecated [message]
       return { tag = 'deprecated', message = ... }
   end
   return M
   ```
   在 `script/parser/ast/cats/cat.lua` 中注册：
   ```lua
   cats['deprecated'] = require 'parser.ast.cats.deprecated'
   ```

2. **Node 层**（如需影响类型）  
   在 `script/node/` 相关节点上添加 `deprecated` 标记字段，影响 `view()` 输出或诊断。

3. **测试层**（`test/parser/`）  
   添加解析测试，验证注解被正确解析。

---

## 场景 C：新增节点类型

**例子**：新增 `Node.Conditional`（条件类型 `A extends B ? C : D`）

### 步骤

1. **创建节点文件** `script/node/conditional.lua`：
   ```lua
   local M = ls.node.register 'Node.Conditional'
   M.kind = 'conditional'

   function M:__init(scope, check, extends, trueType, falseType)
       self.scope = scope
       -- ...
   end

   function M:onView(viewer, options)
       return '...'
   end
   ```

2. **注册 kind**（`script/node/node.lua`）：
   ```lua
   ls.node.kind = {
       -- ...
       ['conditional'] = 1 << 25,  -- 新增
   }
   ```

3. **在 init.lua 追加 require**（`script/node/init.lua`）：
   ```lua
   require 'node.conditional'
   ```

4. **在 runtime 中添加工厂方法**（`script/node/runtime.lua` 或 `runtime-helper.lua`）：
   ```lua
   function rt.conditional(check, extends, trueType, falseType)
       return New 'Node.Conditional' (rt.scope, check, extends, trueType, falseType)
   end
   ```

5. **测试层**：在 `test/node/` 添加测试。

---

## 场景 D：修改现有类型收窄逻辑

**步骤**：
1. 先在 `test/node/tracer.lua` 写出期望行为的测试（TDD）
2. 运行测试确认当前失败
3. 修改 `script/node/tracer.lua` 中对应方法
4. 运行测试确认通过
5. 检查其他既有测试未被破坏

---

## 关键约定

- **不要改变 Flow DSL 的既有 tag 语义**，只新增 tag
- **and/or 的 stack 模式**不对称（详见 `03-tracer-narrowing.md`），新增逻辑运算符需仔细设计
- **每个 alias** 在使用前必须调用 `setTracer(tracer)`，否则不会被追踪
- **parentMap** 必须描述完整的从叶节点到根节点的路径，顺序要求：叶 → 父
