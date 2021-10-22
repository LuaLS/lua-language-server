-- basic
arg                 = '独立版Lua的启动参数。'
assert              = '如果其参数 `v` 的值为假（`nil` 或 `false`）， 它就调用 $error； 否则，返回所有的参数。 在错误情况时， `message` 指那个错误对象； 如果不提供这个参数，参数默认为 `"assertion failed!"` 。'
cgopt.collect       = '做一次完整的垃圾收集循环。'
cgopt.stop          = '停止垃圾收集器的运行。'
cgopt.restart       = '重启垃圾收集器的自动运行。'
cgopt.count         = '以 K 字节数为单位返回 Lua 使用的总内存数。'
cgopt.step          = '单步运行垃圾收集器。 步长“大小”由 `arg` 控制。'
cgopt.setpause      = '将 `arg` 设为收集器的 *间歇率* 。'
cgopt.setstepmul    = '将 `arg` 设为收集器的 *步进倍率* 。'
cgopt.incremental   = '改变收集器模式为增量模式。'
cgopt.generational  = '改变收集器模式为分代模式。'
cgopt.isrunning     = '返回表示收集器是否在工作的布尔值。'
collectgarbage      = '这个函数是垃圾收集器的通用接口。 通过参数 opt 它提供了一组不同的功能。'
dofile              = '打开该名字的文件，并执行文件中的 Lua 代码块。 不带参数调用时， `dofile` 执行标准输入的内容（`stdin`）。 返回该代码块的所有返回值。 对于有错误的情况，`dofile` 将错误反馈给调用者 （即，`dofile` 没有运行在保护模式下）。'
error               = [[
中止上一次保护函数调用， 将错误对象 `message` 返回。 函数 `error` 永远不会返回。

当 `message` 是一个字符串时，通常 `error` 会把一些有关出错位置的信息附加在消息的前头。 level 参数指明了怎样获得出错位置。
]]
_G                  = '一个全局变量（非函数）， 内部储存有全局环境（参见 §2.2）。 Lua 自己不使用这个变量； 改变这个变量的值不会对任何环境造成影响，反之亦然。'
getfenv             = '返回给定函数的环境。`f` 可以是一个Lua函数，也可是一个表示调用栈层级的数字。'
getmetatable        = '如果 `object` 不包含元表，返回 `nil` 。 否则，如果在该对象的元表中有 `"__metatable"` 域时返回其关联值， 没有时返回该对象的元表。'
ipairs              = [[
返回三个值（迭代函数、表 `t` 以及 `0` ）， 如此，以下代码
```lua
    for i,v in ipairs(t) do body end
```
将迭代键值对 `（1,t[1]) ，(2,t[2])， ...` ，直到第一个空值。
]]
loadmode.b        = '只能是二进制代码块。'
loadmode.t        = '只能是文本代码块。'
loadmode.bt       = '可以是二进制也可以是文本。'
load['<5.1']      = '使用 `func` 分段加载代码块。 每次调用 `func` 必须返回一个字符串用于连接前文。'
load['>5.2']      = [[
加载一个代码块。

如果 `chunk` 是一个字符串，代码块指这个字符串。 如果 `chunk` 是一个函数， `load` 不断地调用它获取代码块的片断。 每次对 `chunk` 的调用都必须返回一个字符串紧紧连接在上次调用的返回串之后。 当返回空串、`nil`、或是不返回值时，都表示代码块结束。
]]
loadfile            = '从文件 `filename` 或标准输入（如果文件名未提供）中获取代码块。'
loadstring          = '使用给定字符串加载代码块。'
module              = '创建一个模块。'
next                = [[
运行程序来遍历表中的所有域。 第一个参数是要遍历的表，第二个参数是表中的某个键。 `next` 返回该键的下一个键及其关联的值。 如果用 `nil` 作为第二个参数调用 `next` 将返回初始键及其关联值。 当以最后一个键去调用，或是以 `nil` 调用一张空表时， `next` 返回 `nil`。 如果不提供第二个参数，将认为它就是 `nil`。 特别指出，你可以用 `next(t)` 来判断一张表是否是空的。

索引在遍历过程中的次序无定义， 即使是数字索引也是这样。 （如果想按数字次序遍历表，可以使用数字形式的 `for` 。）

当在遍历过程中你给表中并不存在的域赋值， `next` 的行为是未定义的。 然而你可以去修改那些已存在的域。 特别指出，你可以清除一些已存在的域。
]]
pairs               = [[
如果 `t` 有元方法 `__pairs`， 以 `t` 为参数调用它，并返回其返回的前三个值。

否则，返回三个值：`next` 函数， 表 `t`，以及 `nil`。 因此以下代码
```lua
    for k,v in pairs(t) do body end
```
能迭代表 `t` 中的所有键值对。

参见函数 $next 中关于迭代过程中修改表的风险。
]]
pcall               = '传入参数，以 *保护模式* 调用函数 `f` 。 这意味着 `f` 中的任何错误不会抛出； 取而代之的是，`pcall` 会将错误捕获到，并返回一个状态码。 第一个返回值是状态码（一个布尔量）， 当没有错误时，其为真。 此时，`pcall` 同样会在状态码后返回所有调用的结果。 在有错误时，`pcall` 返回 `false` 加错误消息。'
print               = '接收任意数量的参数，并将它们的值打印到 `stdout`。 它用 `tostring` 函数将每个参数都转换为字符串。 `print` 不用于做格式化输出。仅作为看一下某个值的快捷方式。 多用于调试。 完整的对输出的控制，请使用 $string.format 以及 $io.write。'
rawequal            = '在不触发任何元方法的情况下 检查 `v1` 是否和 `v2` 相等。 返回一个布尔量。'
rawget              = '在不触发任何元方法的情况下 获取 `table[index]` 的值。 `table` 必须是一张表； `index` 可以是任何值。'
rawlen              = '在不触发任何元方法的情况下 返回对象 `v` 的长度。 `v` 可以是表或字符串。 它返回一个整数。'
rawset              = [[
在不触发任何元方法的情况下 将 `table[index]` 设为 `value。` `table` 必须是一张表， `index` 可以是 `nil` 与 `NaN` 之外的任何值。 `value` 可以是任何 Lua 值。
这个函数返回 `table`。
]]
select              = '如果 `index` 是个数字， 那么返回参数中第 `index` 个之后的部分； 负的数字会从后向前索引（`-1` 指最后一个参数）。 否则，`index` 必须是字符串 `"#"`， 此时 `select` 返回参数的个数。'
setfenv             = '设置给定函数的环境。'
setmetatable        = [[
给指定表设置元表。 （你不能在 Lua 中改变其它类型值的元表，那些只能在 C 里做。） 如果 `metatable` 是 `nil`， 将指定表的元表移除。 如果原来那张元表有 `"__metatable"` 域，抛出一个错误。
]]
tonumber            = [[
如果调用的时候没有 `base`， `tonumber` 尝试把参数转换为一个数字。 如果参数已经是一个数字，或是一个可以转换为数字的字符串， `tonumber` 就返回这个数字； 否则返回 `nil`。

字符串的转换结果可能是整数也可能是浮点数， 这取决于 Lua 的转换文法（参见 §3.1）。 （字符串可以有前置和后置的空格，可以带符号。）
]]
tostring            = [[
可以接收任何类型，它将其转换为人可阅读的字符串形式。 浮点数总被转换为浮点数的表现形式（小数点形式或是指数形式）。 （如果想完全控制数字如何被转换，可以使用 $string.format。）
如果 `v` 有 `"__tostring"` 域的元表， `tostring` 会以 `v` 为参数调用它。 并用它的结果作为返回值。
]]
type                = [[
将参数的类型编码为一个字符串返回。 函数可能的返回值有 `"nil"` （一个字符串，而不是 `nil` 值）， `"number"`， `"string"`， `"boolean"`， `"table"`， `"function"`， `"thread"`， `"userdata"`。
]]
_VERSION            = '一个包含有当前解释器版本号的全局变量（并非函数）。'
warn                = '使用所有参数组成的字符串消息来发送警告。'
xpcall['=5.1']      = '传入参数，以 *保护模式* 调用函数 `f` 。这个函数和 `pcall` 类似。 不过它可以额外设置一个消息处理器 `err`。'
xpcall['>5.2']      = '传入参数，以 *保护模式* 调用函数 `f` 。这个函数和 `pcall` 类似。 不过它可以额外设置一个消息处理器 `msgh`。'
unpack              = [[
返回给定 `list` 中的所有元素。 改函数等价于
```lua
return list[i], list[i+1], ···, list[j]
```
]]

bit32               = ''
bit32.arshift       = [[
返回 `x` 向右位移 `disp` 位的结果。`disp` 为负时向左位移。这是算数位移操作，左侧的空位使用 `x` 的高位填充，右侧空位使用 `0` 填充。
]]
bit32.band          = '返回参数按位与的结果。'
bit32.bnot          = [[
返回 `x` 按位取反的结果。

```lua
assert(bit32.bnot(x) == (-1 - x) % 2^32)
```
]]
bit32.bor           = '返回参数按位或的结果。'
bit32.btest         = '参数按位与的结果不为0时，返回 `true` 。'
bit32.bxor          = '返回参数按位异或的结果。'
bit32.extract       = '返回 `n` 中第 `field` 到第 `field + width - 1` 位组成的结果。'
bit32.replace       = '返回 `v` 的第 `field` 到第 `field + width - 1` 位替换 `n` 的对应位后的结果。'
bit32.lrotate       = '返回 `x` 向左旋转 `disp` 位的结果。`disp` 为负时向右旋转。'
bit32.lshift        = [[
返回 `x` 向左位移 `disp` 位的结果。`disp` 为负时向右位移。空位总是使用 `0` 填充。

```lua
assert(bit32.lshift(b, disp) == (b * 2^disp) % 2^32)
```
]]
bit32.rrotate       = '返回 `x` 向右旋转 `disp` 位的结果。`disp` 为负时向左旋转。'
bit32.rshift        = [[
返回 `x` 向右位移 `disp` 位的结果。`disp` 为负时向左位移。空位总是使用 `0` 填充。

```lua
assert(bit32.lshift(b, disp) == (b * 2^disp) % 2^32)
```
]]

coroutine                     = ''
coroutine.create              = '创建一个主体函数为 `f` 的新协程。 f 必须是一个 Lua 的函数。 返回这个新协程，它是一个类型为 `"thread"` 的对象。'
coroutine.isyieldable         = '如果正在运行的协程可以让出，则返回真。'
coroutine.isyieldable['>5.4'] = '如果协程 `co` 可以让出，则返回真。`co` 默认为正在运行的协程。'
coroutine.close               = '关闭协程 `co`，并关闭它所有等待 *to-be-closed* 的变量，并将协程状态设为 `dead` 。'
coroutine.resume              = '开始或继续协程 `co` 的运行。'
coroutine.running             = '返回当前正在运行的协程加一个布尔量。 如果当前运行的协程是主线程，其为真。'
coroutine.status              = '以字符串形式返回协程 `co` 的状态。'
coroutine.wrap                = '创建一个主体函数为 `f` 的新协程。 f 必须是一个 Lua 的函数。 返回一个函数， 每次调用该函数都会延续该协程。'
coroutine.yield               = '挂起正在调用的协程的执行。'
costatus.running              = '正在运行。'
costatus.suspended            = '挂起或是还没有开始运行。'
costatus.normal               = '是活动的，但并不在运行。'
costatus.dead                 = '运行完主体函数或因错误停止。'

debug                       = ''
debug.debug               = '进入一个用户交互模式，运行用户输入的每个字符串。'
debug.getfenv             = '返回对象 `o` 的环境。'
debug.gethook             = '返回三个表示线程钩子设置的值： 当前钩子函数，当前钩子掩码，当前钩子计数 。'
debug.getinfo             = '返回关于一个函数信息的表。'
debug.getlocal['<5.1']    = '返回在栈的 `level` 层处函数的索引为 `index` 的局部变量的名字和值。'
debug.getlocal['>5.2']    = '返回在栈的 `f` 层处函数的索引为 `index` 的局部变量的名字和值。'
debug.getmetatable        = '返回给定 `value` 的元表。'
debug.getregistry         = '返回注册表。'
debug.getupvalue          = '返回函数 `f` 的第 `up` 个上值的名字和值。'
debug.getuservalue['<5.3']= '返回关联在 `u` 上的 `Lua` 值。'
debug.getuservalue['>5.4']= '返回关联在 `u` 上的第 `n` 个 `Lua` 值，以及一个布尔，`false`表示值不存在。'
debug.setcstacklimit      = [[
### **已在 `Lua 5.4.2` 中废弃**

设置新的C栈限制。该限制控制Lua中嵌套调用的深度，以避免堆栈溢出。

如果设置成功，该函数返回之前的限制；否则返回`false`。
]]
debug.setfenv             = '将 `table` 设置为 `object` 的环境。'
debug.sethook             = '将一个函数作为钩子函数设入。'
debug.setlocal            = '将 `value` 赋给 栈上第 `level` 层函数的第 `local` 个局部变量。'
debug.setmetatable        = '将 `value` 的元表设为 `table` （可以是 `nil`）。'
debug.setupvalue          = '将 `value` 设为函数 `f` 的第 `up` 个上值。'
debug.setuservalue['<5.3']= '将 `value` 设为 `udata` 的关联值。'
debug.setuservalue['>5.4']= '将 `value` 设为 `udata` 的第 `n` 个关联值。'
debug.traceback           = '返回调用栈的栈回溯信息。 字符串可选项 `message` 被添加在栈回溯信息的开头。'
debug.upvalueid           = '返回指定函数第 `n` 个上值的唯一标识符（一个轻量用户数据）。'
debug.upvaluejoin         = '让 Lua 闭包 `f1` 的第 `n1` 个上值 引用 `Lua` 闭包 `f2` 的第 `n2` 个上值。'
infowhat.n                = '`name` 和 `namewhat`'
infowhat.S                = '`source`，`short_src`，`linedefined`，`lalinedefined`，和 `what`'
infowhat.l                = '`currentline`'
infowhat.t                = '`istailcall`'
infowhat.u['<5.1']        = '`nups`'
infowhat.u['>5.2']        = '`nups`、`nparams` 和 `isvararg`'
infowhat.f                = '`func`'
infowhat.r                = '`ftransfer` 和 `ntransfer`'
infowhat.L                = '`activelines`'
hookmask.c                = '每当 Lua 调用一个函数时，调用钩子。'
hookmask.r                = '每当 Lua 从一个函数内返回时，调用钩子。'
hookmask.l                = '每当 Lua 进入新的一行时，调用钩子。'

file                        = ''
file[':close']              = '关闭 `file`。'
file[':flush']              = '将写入的数据保存到 `file` 中。'
file[':lines']              = [[
------
```lua
for c in file:lines(...) do
    body
end
```
]]
file[':read']                = '读文件 `file`， 指定的格式决定了要读什么。'
file[':seek']                = '设置及获取基于文件开头处计算出的位置。'
file[':setvbuf']             = '设置输出文件的缓冲模式。'
file[':write']               = '将参数的值逐个写入 `file`。'
readmode.n                  = '读取一个数字，根据 Lua 的转换文法返回浮点数或整数。'
readmode.a                  = '从当前位置开始读取整个文件。'
readmode.l                  = '读取一行并忽略行结束标记。'
readmode.L                  = '读取一行并保留行结束标记。'
seekwhence.set              = '基点为 0 （文件开头）。'
seekwhence.cur              = '基点为当前位置。'
seekwhence['.end']          = '基点为文件尾。'
vbuf.no                     = '不缓冲；输出操作立刻生效。'
vbuf.full                   = '完全缓冲；只有在缓存满或调用 flush 时才做输出操作。'
vbuf.line                   = '行缓冲；输出将缓冲到每次换行前。'

io                          = ''
io.stdin                    = '标准输入。'
io.stdout                   = '标准输出。'
io.stderr                   = '标准错误。'
io.close                    = '关闭 `file` 或默认输出文件。'
io.flush                    = '将写入的数据保存到默认输出文件中。'
io.input                    = '设置 `file` 为默认输入文件。'
io.lines                    = [[
------
```lua
for c in io.lines(filename, ...) do
    body
end
```
]]
io.open                    = '用字符串 `mode` 指定的模式打开一个文件。'
io.output                  = '设置 `file` 为默认输出文件。'
io.popen                   = '用一个分离进程开启程序 `prog` 。'
io.read                    = '读文件 `file`， 指定的格式决定了要读什么。'
io.tmpfile                 = '如果成功，返回一个临时文件的句柄。'
io.type                    = '检查 `obj` 是否是合法的文件句柄。'
io.write                   = '将参数的值逐个写入默认输出文件。'
openmode.r                 = '读模式。'
openmode.w                 = '写模式。'
openmode.a                 = '追加模式。'
openmode['.r+']            = '更新模式，所有之前的数据都保留。'
openmode['.w+']            = '更新模式，所有之前的数据都删除。'
openmode['.a+']            = '追加更新模式，所有之前的数据都保留，只允许在文件尾部做写入。'
openmode.rb                = '读模式。（二进制方式）'
openmode.wb                = '写模式。（二进制方式）'
openmode.ab                = '追加模式。（二进制方式）'
openmode['.r+b']           = '更新模式，所有之前的数据都保留。（二进制方式）'
openmode['.w+b']           = '更新模式，所有之前的数据都删除。（二进制方式）'
openmode['.a+b']           = '追加更新模式，所有之前的数据都保留，只允许在文件尾部做写入。（二进制方式）'
popenmode.r                = '从这个程序中读取数据。（二进制方式）'
popenmode.w                = '向这个程序写入输入。（二进制方式）'
filetype.file              = '是一个打开的文件句柄。'
filetype['.closed file']   = '是一个关闭的文件句柄。'
filetype['.nil']           = '不是文件句柄。'

math                        = ''
math.abs                    = '返回 `x` 的绝对值。'
math.acos                   = '返回 `x` 的反余弦值（用弧度表示）。'
math.asin                   = '返回 `x` 的反正弦值（用弧度表示）。'
math.atan['<5.2']           = '返回 `x` 的反正切值（用弧度表示）。'
math.atan['>5.3']           = '返回 `y/x` 的反正切值（用弧度表示）。'
math.atan2                  = '返回 `y/x` 的反正切值（用弧度表示）。'
math.ceil                   = '返回不小于 `x` 的最小整数值。'
math.cos                    = '返回 `x` 的余弦（假定参数是弧度）。'
math.cosh                   = '返回 `x` 的双曲余弦（假定参数是弧度）。'
math.deg                    = '将角 `x` 从弧度转换为角度。'
math.exp                    = '返回 `e^x` 的值 （e 为自然对数的底）。'
math.floor                  = '返回不大于 `x` 的最大整数值。'
math.fmod                   = '返回 `x` 除以 `y`，将商向零圆整后的余数。'
math.frexp                  = '将 `x` 分解为尾数与指数，返回值符合 `x = m * (2 ^ e)` 。`e` 是一个整数，`m` 是 [0.5, 1) 之间的规格化小数 (`x` 为0时 `m` 为0)。'
math.huge                   = '一个比任何数字值都大的浮点数。'
math.ldexp                  = '返回 `m * (2 ^ e)` 。'
math.log['<5.1']            = '返回 `x` 的自然对数。'
math.log['>5.2']            = '回以指定底的 `x` 的对数。'
math.log10                  = '返回 `x` 的以10为底的对数。'
math.max                    = '返回参数中最大的值， 大小由 Lua 操作 `<` 决定。'
math.maxinteger             = '最大值的整数。'
math.min                    = '返回参数中最小的值， 大小由 Lua 操作 `<` 决定。'
math.mininteger             = '最小值的整数。'
math.modf                   = '返回 `x` 的整数部分和小数部分。'
math.pi                     = '*π* 的值。'
math.pow                    = '返回 `x ^ y` 。'
math.rad                    = '将角 `x` 从角度转换为弧度。'
math.random                 = [[
* `math.random()`: 返回 [0,1) 区间内一致分布的浮点伪随机数。
* `math.random(n)`: 返回 [1, n] 区间内一致分布的整数伪随机数。
* `math.random(m, n)`: 返回 [m, n] 区间内一致分布的整数伪随机数。
]]
math.randomseed['<5.3']     = '把 `x` 设为伪随机数发生器的“种子”： 相同的种子产生相同的随机数列。'
math.randomseed['>5.4']     = [[
* `math.randomseed(x, y)`: 将 `x` 与 `y` 连接为128位的种子来重新初始化伪随机生成器。
* `math.randomseed(x)`: 等同于 `math.randomseed(x, 0)` 。
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.（不会翻）
]]
math.sin                    = '返回 `x` 的正弦值（假定参数是弧度）。'
math.sinh                   = '返回 `x` 的双曲正弦值（假定参数是弧度）。'
math.sqrt                   = '返回 `x` 的平方根。'
math.tan                    = '返回 `x` 的正切值（假定参数是弧度）。'
math.tanh                   = '返回 `x` 的双曲正切值（假定参数是弧度）。'
math.tointeger              = '如果 `x` 可以转换为一个整数， 返回该整数。'
math.type                   = '如果 `x` 是整数，返回 `"integer"`， 如果它是浮点数，返回 `"float"`， 如果 `x` 不是数字，返回 `nil`。'
math.ult                    = '如果整数 `m` 和 `n` 以无符号整数形式比较， `m` 在 `n` 之下，返回布尔真否则返回假。'

os                          = ''
os.clock                    = '返回程序使用的按秒计 CPU 时间的近似值。'
os.date                     = '返回一个包含日期及时刻的字符串或表。 格式化方法取决于所给字符串 `format`。'
os.difftime                 = '返回以秒计算的时刻 `t1` 到 `t2` 的差值。'
os.execute                  = '调用系统解释器执行 `command`。'
os.exit['<5.1']             = '调用 C 函数 `exit` 终止宿主程序。'
os.exit['>5.2']             = '调用 ISO C 函数 `exit` 终止宿主程序。'
os.getenv                   = '返回进程环境变量 `varname` 的值。'
os.remove                   = '删除指定名字的文件。'
os.rename                   = '将名字为 `oldname` 的文件或目录更名为 `newname`。'
os.setlocale                = '设置程序的当前区域。'
os.time                     = '当不传参数时，返回当前时刻。 如果传入一张表，就返回由这张表表示的时刻。'
os.tmpname                  = '返回一个可用于临时文件的文件名字符串。'
osdate.year                 = '四位数字'
osdate.month                = '1-12'
osdate.day                  = '1-31'
osdate.hour                 = '0-23'
osdate.min                  = '0-59'
osdate.sec                  = '0-61'
osdate.wday                 = '星期几，1-7，星期天为 1'
osdate.yday                 = '当年的第几天，1-366'
osdate.isdst                = '夏令时标记，一个布尔量'

package                     = ''
require['<5.3']             = '加载一个模块，返回该模块的返回值（`nil`时为`true`）。'
require['>5.4']             = '加载一个模块，返回该模块的返回值（`nil`时为`true`）与搜索器返回的加载数据。默认搜索器的加载数据指示了加载位置，对于文件来说就是文件路径。'
package.config              = '一个描述有一些为包管理准备的编译期配置信息的串。'
package.cpath               = '这个路径被 `require` 在 C 加载器中做搜索时用到。'
package.loaded              = '用于 `require` 控制哪些模块已经被加载的表。'
package.loaders             = '用于 `require` 控制如何加载模块的表。'
package.loadlib             = '让宿主程序动态链接 C 库 `libname` 。'
package.path                = '这个路径被 `require` 在 Lua 加载器中做搜索时用到。'
package.preload             = '保存有一些特殊模块的加载器。'
package.searchers           = '用于 `require` 控制如何加载模块的表。'
package.searchpath          = '在指定 `path` 中搜索指定的 `name` 。'
package.seeall              = '给 `module` 设置一个元表，该元表的 `__index` 域为全局环境，这样模块便会继承全局环境的值。可作为 `module` 函数的选项。'

string                      = ''
string.byte                 = '返回字符 `s[i]`， `s[i+1]`， ...　，`s[j]` 的内部数字编码。'
string.char                 = '接收零或更多的整数。 返回和参数数量相同长度的字符串。 其中每个字符的内部编码值等于对应的参数值。'
string.dump                 = '返回包含有以二进制方式表示的（一个 *二进制代码块* ）指定函数的字符串。'
string.find                 = '查找第一个字符串中匹配到的 `pattern`（参见 §6.4.1）。'
string.format               = '返回不定数量参数的格式化版本，格式化串为第一个参数。'
string.gmatch               = [[
返回一个迭代器函数。 每次调用这个函数都会继续以 `pattern` （参见　§6.4.1） 对 s 做匹配，并返回所有捕获到的值。

下面这个例子会循环迭代字符串 s 中所有的单词， 并逐行打印：
```lua
    s = "hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 = '将字符串 s 中，所有的（或是在 n 给出时的前 n 个） pattern （参见 §6.4.1）都替换成 repl ，并返回其副本。'
string.len                  = '返回其长度。'
string.lower                = '将其中的大写字符都转为小写后返回其副本。'
string.match                = '在字符串 s 中找到第一个能用 pattern （参见 §6.4.1）匹配到的部分。 如果能找到，match 返回其中的捕获物； 否则返回 nil 。'
string.pack                 = '返回一个打包了（即以二进制形式序列化） v1, v2 等值的二进制字符串。 字符串 fmt 为打包格式（参见 §6.4.2）。'
string.packsize             = [[返回以指定格式用 $string.pack 打包的字符串的长度。 格式化字符串中不可以有变长选项 's' 或 'z' （参见 §6.4.2）。]]
string.rep['<5.1']          = '返回 `n` 个字符串 `s` 连在一起的字符串。 如果 `n` 不是正数则返回空串。'
string.rep['>5.2']          = '返回 `n` 个字符串 `s` 以字符串 `sep` 为分割符连在一起的字符串。 默认的 `sep` 值为空字符串（即没有分割符）。 如果 `n` 不是正数则返回空串。'
string.reverse              = '返回字符串 s 的翻转串。'
string.sub                  = '返回字符串的子串， 该子串从 `i` 开始到 `j` 为止。'
string.unpack               = '返回以格式 fmt （参见 §6.4.2） 打包在字符串 s （参见 string.pack） 中的值。'
string.upper                = '接收一个字符串，将其中的小写字符都转为大写后返回其副本。'

table                       = ''
table.concat                = '提供一个列表，其所有元素都是字符串或数字，返回字符串 `list[i]..sep..list[i+1] ··· sep..list[j]`。'
table.insert                = '在 `list` 的位置 `pos` 处插入元素 `value`。'
table.maxn                  = '返回给定表的最大正数索引，如果表没有正数索引，则返回零。'
table.move                  = [[
将元素从表 `a1` 移到表 `a2`。
```lua
a2[t],··· = a1[f],···,a1[e]
return a2
```
]]
table.pack                  = '返回用所有参数以键 `1`,`2`, 等填充的新表， 并将 `"n"` 这个域设为参数的总数。'
table.remove                = '移除 `list` 中 `pos` 位置上的元素，并返回这个被移除的值。'
table.sort                  = '在表内从 `list[1]` 到 `list[#list]` *原地* 对其间元素按指定次序排序。'
table.unpack                = [[
返回列表中的元素。 这个函数等价于
```lua
    return list[i], list[i+1], ···, list[j]
```
i 默认为 1 ，j 默认为 #list。
]]

utf8                        = ''
utf8.char                   = '接收零或多个整数， 将每个整数转换成对应的 UTF-8 字节序列，并返回这些序列连接到一起的字符串。'
utf8.charpattern            = '用于精确匹配到一个 UTF-8 字节序列的模式，它假定处理的对象是一个合法的 UTF-8 字符串。'
utf8.codes                  = [[
返回一系列的值，可以让
```lua
for p, c in utf8.codes(s) do
    body
end
```
迭代出字符串 s 中所有的字符。 这里的 p 是位置（按字节数）而 c 是每个字符的编号。 如果处理到一个不合法的字节序列，将抛出一个错误。
]]
utf8.codepoint              = '以整数形式返回 `s` 中 从位置 `i` 到 `j` 间（包括两端） 所有字符的编号。'
utf8.len                    = '返回字符串 `s` 中 从位置 `i` 到 `j` 间 （包括两端） UTF-8 字符的个数。'
utf8.offset                 = '返回编码在 `s` 中的第 `n` 个字符的开始位置（按字节数） （从位置 `i` 处开始统计）。'
