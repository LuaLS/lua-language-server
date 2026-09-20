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
- **测试环境没有标准库**：`TEST_INDEX`（`test/coder/init.lua`）、`TEST_COMPLETION` 等 harness 运行在裸 `rt` 环境，`string`/`table`/`math`/`ipairs`/`select` 等标准库函数不可用。若用例需要某个标准库函数，用 `--!include <name>` 宏手动导入，或直接用 `test.includeCodes[name]` 中已有的片段（见 `test/include.lua`），再或者在用例里自行定义。测试用例也应尽量用抽象、通用代码，避免依赖具体标准库实现。

## 调试工作流
- tracer 或 flow 失败后，先看 `tmp/LAST_CODE`、`tmp/LAST_FLOW`、`tmp/LAST_PMAP`。
- 如果 `self.map` 报 `No such key`，优先检查 coder 输出中的读写顺序，不要直接绕过 map。
- 临时日志和诊断产物统一留在 `tmp/`。
- 临时调试脚本/文件必须放在 `tmp/` 下，测试完毕后清理；不要散落在 `test/` 或 `script/` 目录。
- **新增文件可以，但尽量不要删除文件**（`del`/`rm` 会被拦截，需用户手动确认）；尽量复用已有文件或就地修改。
- 如果使用 debugger，启动新会话前先停掉旧会话，用完后及时断开。

## 批量扫描与内存护栏

命令行项目扫描（`--test project.external[-diagnostic] --test-project=<path>`）跑在测试模式，
Lua 堆上限由 `ls.args.MEM_LIMIT`（默认 10GB）控制，护栏实现是 `script/tools/mem-guard.lua`：

- `mem-guard.enable(memLimitGB)`：已有钩子（如调试器）或已启用则直接返回 `false`，不抢占；
  否则装一个**指令级（字节码）钩子**，每 10 万条指令查一次 `collectgarbage('count')`，
  超限打印 `[MEMORY GUARD] (<state>) ... force exit` 并 `os.exit(1)`；`isEnabled()` 可查询是否已启用。
- **钩子只对设置它的线程生效**：协程不会自动继承（实测主线程计数钩子调用 602 次，同一钩子在协程内 0 次）。
  因此 `enable()` 同时包装 `coroutine.create` / `coroutine.wrap`，给每个新建协程显式
  `debug.sethook(co, hook, mask, count)`；回归用例见 `test/tools/memory-guard.lua`。
- **两个 Lua 状态都要装**：master 在 `test.lua` 里用 `ls.args.MEM_LIMIT` 调用；`bee.thread` 工作线程是
  独立状态（worker 里跑 coder 编译），由 `script/async/worker.lua` 在测试模式把 `memLimit` 传进 worker 选项，
  `script/async/worker-init.lua` 用同一个模块装钩子（每个 worker 各自启用一份）。
- 实测：600 行的 `CS.lua` 前缀在 `--mem-limit=0.5` 下会在 master 状态触发护栏，触发时进程 RSS ≈ 550MB
  （≈ 堆 + 50MB），因此用 `--mem-limit` 能有效阻止吃满机器。
- **测试入口的错误处理**：`test.lua` 的 bootstrap（装护栏、require 测试文件）整体包在 `xpcall` 里，
  保证后面的 `ls.await.sleep` / `ls.eventLoop.stop()` / `os.exit` 一定执行。
  历史坑：入口早期抛错（如调用了已删除的函数）会让 `eventLoop.stop()` 永不执行，进程挂住不退出，
  表现为「测试跑了几十分钟还没结束」。

- **批量扫描一律显式传 `--mem-limit=2`**：默认 10GB 远超机器承受范围，加载型爆炸会先吃光机器才触发。
- **不要并发跑多个扫描/测试进程**：上限叠加（2026-09-18 实测两个 meta 扫描并发 → 机器内存耗尽）；
  重试前先用 `Get-CimInstance Win32_Process -Filter "Name='lua-language-server.exe'"` 确认没有残留 `--test` 进程。
- 需要观察峰值时用看门狗：启动扫描进程后轮询其 WorkingSet，超阈值自动 kill 并打印峰值。
  本仓库 `tmp/` 下留有这轮用的脚本（`scan-guard.ps1` / `variant-scan.ps1` / `prefix-sweep.ps1` / `cs-shrink.ps1`），
  但 `tmp/` 不入库，脚本被清掉时按下面对应做法重建。
- 加 `--test project.external` 可只加载不跑诊断，用来区分「加载/索引」与「诊断」两个阶段的消耗。
- 缩小/定位体积：按行数前缀扫描找跃变点（每次截前 N 行写成一个文件扫一遍，比较峰值），
  或对前缀做二分找最小复现。
- 判定「是否爆炸」不要用中文标记匹配（PowerShell 5.1 读无 BOM 的 `.ps1` 会把中文字面量读成乱码，
  导致恒真）；用 ASCII 标记（如看门狗输出的 `killed=True`）。

看门狗核心（PowerShell，`$Project` 为待扫目录）：

```powershell
$p = Start-Process -FilePath 'bin\lua-language-server.exe' -PassThru -NoNewWindow `
     -ArgumentList @('--test', 'project.external', "--test-project=$Project", '--mem-limit=2')
$peak = 0
while (-not $p.HasExited) {
    $ws = (Get-Process -Id $p.Id).WorkingSet64 / 1MB
    if ($ws -gt $peak) { $peak = $ws }
    if ($ws -gt 2000) { Stop-Process -Id $p.Id -Force; Write-Host "killed peak=$([int]$peak)MB"; break }
    Start-Sleep -Milliseconds 400
}
```

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
- 禁止写任何注释；确有必要写注释时，必须先询问用户并得到同意。即便用户同意，注释也只写意图、保持简练，不暴露内部实现细节。
- 可选链：本工程支持 `?.` `?:` `?[` `?(` 写法（bee.lua 以 `BEE_OPTCHAIN` 编译），可省略判空；但 `script/tools/` 目录不允许使用。
- 不要留下 lint / 诊断警告；改完用诊断检查确认干净。清理诊断只处理 warning 及以上等级；hint/information 级存量为项目常态，不主动清理，除非用户明确要求。

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
