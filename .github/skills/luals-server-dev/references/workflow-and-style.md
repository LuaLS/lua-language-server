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
