# 工作流与风格

## 验证命令
从 server 根目录运行。

```powershell
bin\lua-language-server.exe --test
bin\lua-language-server.exe --test parser
bin\lua-language-server.exe --test node
bin\lua-language-server.exe --test coder
bin\lua-language-server.exe --test feature.completion
bin\lua-language-server.exe --test feature.completion.field
```

## 测试工作流
- 先跑最小相关 suite，只有需要时再扩大验证范围。
- parser 改动优先在 `test/parser/` 增加测试。
- node 或 tracer 改动根据归属放到 `test/node/` 或 `test/coder/`。
- 面向 LSP 行为的改动，优先在 `test/feature/` 补测试。
- completion 测试使用 `test/feature/completion/init.lua` 中的 harness；要记住 `TEST_COMPLETION` 运行在裸环境。

## 调试工作流
- tracer 或 flow 失败后，先看 `tmp/LAST_CODE`、`tmp/LAST_FLOW`、`tmp/LAST_PMAP`。
- 如果 `self.map` 报 `No such key`，优先检查 coder 输出中的读写顺序，不要直接绕过 map。
- 临时日志和诊断产物统一留在 `tmp/`。
- 如果使用 debugger，启动新会话前先停掉旧会话，用完后及时断开。

## 风格约定
- Lua 文件使用 4 空格缩进。
- 行宽尽量接近仓库限制 120。
- 保持现有对齐风格，尤其是 assign、参数列表和 `if` 分支。
- 项目中多条件 `if` 的对齐格式是有意设计的，例如：

```lua
if  condA
and condB
and condC then
    ...
end
```

- 延续 `script/class.lua` 中已有的 class 写法，包括 `Class` 和 `New` 的使用方式。
- 避免大范围纯格式化改动。

## 实际约束
- 日常功能开发不要运行 `PreCompile` 或 `Compile` 任务。
- worker-thread 边界只能传递可序列化的 plain data。
- completion 相关逻辑优先复用 VM/Node 推导出的类型信息，不要回退成大段原始文本重扫。
- 改动尽量聚焦在拥有该职责的子系统内。

## 已知陷阱：`makeRegistry` "Key already exists" 错误

`script/vm/coder/coder.lua` 中的 `makeRegistry.__newindex` 实施了严格的键唯一性检查。
向同一 key 写第二次时会立即 `error('Key already exists: ' .. k)`。
**这是有意设计的，不要去绕过或削弱这个检测。**

### 错误来源

当 **parser** 对同一源文件位置调用了两次 `parseCat()`，就会产生两个不同的 cat/catid 对象，
但它们的 `uniqueKey`（`kind@startRow:startCol-finishRow:finishCol`）相同。
coder 分别编译这两个对象时，双方都会尝试写入同一 registry key，触发上述错误。

### 诊断方式

1. 看 `tmp/LAST_CODE`，查找重复出现的 `r["catid@row:col-row:col"] = ...` 行。
2. 统计重复次数——常见模式是函数前多个 `---@return` 注解中有行内注释（`-- comment`）时，
   后续注解的 cat 呈 1、2、4 指数倍出现。

### 正确的修复方向

**在 parser 层去重，不要在 coder 层屏蔽。**

已采用的方案（见 `script/parser/ast/cats/cat.lua` 末尾的 `parseCat` 函数）：
在将 cat 节点追加到 `curBlock.cats` 之前，检查是否已有相同 `start` 位置的 cat；
若存在则跳过追加，防止重复节点进入 `mergeStatesAndCats` 并最终出现在 `block.childs` 中。

```lua
-- parseCat() 末尾：
local isDuplicate = false
local catStart = cat.start
for i = 1, #cats do
    if cats[i].start == catStart then
        isDuplicate = true
        break
    end
end
if not isDuplicate then
    cats[#cats+1] = cat
end
```

**绝对不要**用以下方式"修复"此问题：
- 修改 `compile()` 用 `source.uniqueKey` 替代对象引用做已编译检查（会导致真正的重复编译被静默忽略）。
- 在 `catstatereturn` 或其他 provider 里加条件跳过重复写入（掩盖根因）。
- 弱化 `makeRegistry.__newindex` 的检查（破坏设计意图）。

回归测试位于 `test/coder/block.lua`（"Bug 3 回归测试" 注释块）。
