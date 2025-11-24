# bee.lua API 兼容性修复总结

## 修复的问题

### 1. `exe_path` API 变更
- **问题**: `fs.exe_path()` 从 `bee.filesystem` 模块移除
- **解决方案**: 现在使用 `bee.sys.exe_path()`
- **修改文件**: 
  - `test.lua` - 更新为使用 `sys.exe_path()`
  - `script/meta/bee/filesystem.lua` - 添加 deprecated 标记
  - `script/meta/bee/sys.lua` - 新增元数据

### 2. Channel API 变更
- **问题**: `thread.newchannel()` 和 `thread.channel()` 不再存在
- **新 API**: `bee.channel.create()` 和 `bee.channel.query()`
- **解决方案**: 创建兼容层 `script/bee-compat.lua`
- **修改文件**:
  - `script/bee-compat.lua` - 新增兼容层
  - `script/pub/pub.lua` - 使用兼容层
  - `script/brave/brave.lua` - 使用兼容层
  - `script/meta/bee/channel.lua` - 新增元数据
  - `script/meta/bee/thread.lua` - 更新元数据

### 3. Thread API 变更
- **问题**: `thread.thread()` 改名为 `thread.create()`
- **解决方案**: 在兼容层中添加别名
- **修改文件**: `script/bee-compat.lua`

### 4. Channel bpop() 实现
- **问题**: 新版 channel 不支持阻塞 pop
- **解决方案**: 使用 `bee.select` 模块实现阻塞等待
- **实现**: 在兼容层的 metatable 中添加 `bpop()` 方法

## 兼容层功能

`script/bee-compat.lua` 提供以下功能：

1. **thread.newchannel(name)** - 创建 channel 并注册到 selector
2. **thread.channel(name)** - 查询现有 channel
3. **thread.thread(script)** - thread.create() 的别名
4. **channel:bpop()** - 阻塞式 pop，使用 select 等待
5. **errlog 特殊处理** - 包装 thread.errlog() 为 channel 接口

## 测试

- ✓ 基本兼容性测试通过 (`test_compat.lua`)
- ✓ 主测试套件运行正常 (`test.lua`)
- ✓ channel 创建、查询、push/pop 功能正常
- ✓ errlog channel 工作正常
- ✓ sys.exe_path() 正常工作

## 使用方法

在需要使用旧 API 的模块中，使用：
```lua
local thread = require 'bee-compat'
```

而不是：
```lua
local thread = require 'bee.thread'
```

这样就能自动获得兼容性支持。
