---@meta
---@alias MESSAGENAME
---|+'"lua"'
---|+'"socket"'
---|+'"client"'
---|+'"response"'
---|+'"muliticast"'
---|+'"system"'
---|+'"harbor"'
---|+'"error"'
---|+'"queue"'
---|+'"debug"'
---|+'"trace"'
---@alias SERVICEADDR '".servicename"' | '":0000000C"' | integer
---@alias MESSAGEHANDLER fun(session:integer, source:integer, cmd:string, ...)
local skynet  = {
  -- read skynet.h
  PTYPE_TEXT      = 0,
  PTYPE_RESPONSE  = 1,
  PTYPE_MULTICAST = 2,
  PTYPE_CLIENT    = 3,
  PTYPE_SYSTEM    = 4,
  PTYPE_HARBOR    = 5,
  PTYPE_SOCKET    = 6,
  PTYPE_ERROR     = 7,
  PTYPE_QUEUE     = 8, -- used in deprecated mqueue, use skynet.queue instead
  PTYPE_DEBUG     = 9,
  PTYPE_LUA       = 10,
  PTYPE_SNAX      = 11,
  PTYPE_TRACE     = 12, -- use for debug trace
  PNAME_TEXT      = "text",
  PNAME_RESPONSE  = "response",
  PNAME_MULTICAST = "muliticast",
  PNAME_CLIENT    = "client",
  PNAME_SYSTEM    = "system",
  PNAME_HARBOR    = "harbor",
  PNAME_SOCKET    = "socket",
  PNAME_ERROR     = "error",
  PNAME_QUEUE     = "queue",
  PNAME_DEBUG     = "debug",
  PNAME_LUA       = "lua",
  PNAME_SNAX      = "snax",
  PNAME_TRACE     = "trace",

}

-------------- 地址相关 API ---------------

---* 获取服务自己的整型服务地址
---@return integer
function skynet.self()
end

---* 获取服务所属的节点
---@param addr number
---@return number
function skynet.harbor(addr)
end

---* 将服务的整型地址转换成一个16进制字符串，若不是整型，则 tostring() 返回
---* :0000000c
---@param addr SERVICEADDR
---@return string
function skynet.address(addr)
end

---* skynet.localname(name) 用来查询一个 . 开头的名字对应的地址。它是一个非阻塞 API ，不可以查询跨节点的全局名字。
---* 返回地址类似 :0000000b
---@return string
function skynet.localname(name)
end

----------------消息分发和响应相关 API -----------

---* 注册一类消息的处理机制
---* 需要 require 'skynet.manager'
---* skynet.register_protocol {
---*     name = "text",
---*     id = skynet.PTYPE_TEXT,
---*     pack = function(m) return tostring(m) end,
---*     unpack = skynet.tostring,
---*   }
---@param class  table
function skynet.register_protocol(class)
end

---* 注册特定类消息的处理函数。大多数程序会注册 lua 类消息的处理函数，惯例的写法是：
---* local CMD = {}
---* skynet.dispatch("lua", function(session, source, cmd, ...)
---*    local f = assert(CMD[cmd])
---*    f(...)
---*  end)
---@param typename MESSAGENAME
---@param func MESSAGEHANDLER
function skynet.dispatch(typename, func)
end

---* 向当前会话返回数据
---* 会自动获取当前线程所关联的会话ID和返回地址
---* 由于某些历史原因（早期的 skynet 默认消息类别是文本，而没有经过特殊编码），
---这个 API 被设计成传递一个 C 指针和长度，而不是经过当前消息的 pack 函数打包。或者你也可以省略 size 而传入一个字符串。
---* 在同一个消息处理的 coroutine 中只可以被调用一次，多次调用会触发异常。
---* 你需要挂起一个请求，等将来时机满足，再回应它。而回应的时候已经在别的 coroutine 中了。
---针对这种情况，你可以调用 skynet.response(skynet.pack) 获得一个闭包，以后调用这个闭包即可把回应消息发回。
---这里的参数 skynet.pack 是可选的，你可以传入其它打包函数，默认即是 skynet.pack 。
---@param msg lightuserdata
---@param sz integer
function skynet.ret(msg, sz)
end

---* 与 skynet.ret(skynet.pack(...)) 相等
function skynet.retpack(...)
end

---返回一个闭包以进行延迟回应
---@param pack fun(...):string|lightuserdata,integer #默认会用 skynet.pack
---@return fun(isOK:boolean | 'TEST', ...)
function skynet.response(pack)
end

---* 一般来说每个请求都需要给出一个响应，
---* 但当我们不需要响应的时候调用这个，就不会给出警告了
---* 如我们使用  C Gate 将套接字作为会话ID
function skynet.ignoreret()
end

---设置未知请求的处理函数
---@param unknown fun(session:number, source:number, msg:lightuserdata, sz:number, prototype:number)
function skynet.dispatch_unknown_request(unknown)
end

---设置未知响应的处理函数
---@param unknown fun(session:number, source:number, msg:lightuserdata , sz:number)
function skynet.dispatch_unknown_response(unknown)
end

---SNLUA 默认的Lua回调
function skynet.dispatch_message(...)
end

--------------------序列化相关API---------------

---* 可以将一组 lua 对象序列化为一个由 malloc 分配出来的 C 指针加一个数字长度
---* 你需要考虑 C 指针引用的数据块何时释放的问题。当然，如果你只是将 skynet.pack 填在消息
---  处理框架里时，框架解决了这个管理问题。skynet 将 C 指针发送到其他服务，而接收方会在使用完
---  后释放这个指针。
---@vararg any
---@return lightuserdata, number
function skynet.pack(...)
end

---* 将 Lua 多个数据打包成一个 Lua 字符串
---* 这里不用考虑内存何时释放的问题，而 skynet.pack 如果在消息框架外调用就需要
---@vararg any
---@return string
function skynet.packstring(...)
end

---* 将 C 指针 或字符串转换成 Lua 数据
---@param msg lightuserdata | string
---@param sz? number
---@return ...
function skynet.unpack(msg, sz)
end

---* 将 C 指针转换成 Lua 字符串
---@param msg lightuserdata|string
---@param sz number #如果是传递的 string，则不需要 此参数
---@return string
function skynet.tostring(msg, sz)
end

---# 将 C 指针释放
---@param msg lightuserdata
---@param sz number
function skynet.trash(msg, sz)
end

------------------ 消息推送和远程调用 API -----------------

---* **非阻塞API**
---* 这条 API 可以把一条类别为 typename 的消息发送给 address 。它会先经过事先注册的 pack 函数打包 ... 的内容。
---* 实际上也是利用了 c.send 不过传送的会话ID是0
---* 接收端接收完毕消息后，默认情况下，消息会由 skynet 释放。
---  具体可以查看 skynet-server.c 中的 dispatch_message 的代码
---@param addr SERVICEADDR
---@param typename string @类型名
---@vararg any @传输的数据
function skynet.send(addr, typename, ...)
end

---* 向一个服务发送消息
---* 它和 skynet.send 功能类似，但更细节一些。它可以指定发送地址（把消息源伪装成另一个服务），指定发送的消息的 session 。
---* 注：address 和 source 都必须是数字地址，不可以是别名。
---* skynet.redirect 不会调用 pack ，所以这里的 ... 必须是一个编码过的字符串，或是 userdata 加一个长度。
---@param address number @目标服务地址
---@param source number @伪装的源地址
---@param typename string @类型名
---@param session number @会话ID
---@vararg any @传输的数据
function skynet.redirect(address, source, typename, session, ...)
end

---* 向一个服务发送不打包的消息
---@param addr SERVICEADDR @目标服务地址
---@param typename string @类型名
---@param msg lightuserdata
---@param sz number
function skynet.rawsend(addr, typename, msg, sz)
end

---* **阻塞API**
---* 向一个服务发送消息，并期待得到响应，用了此函数后，当前的线程会挂起，直到响应到达
---* 若长时间没有响应，会有警告在控制台显示
---* **挂起期间，状态可能会变更，造成重入**
---* 实际上，他也是利用 c.send 来发送消息，不过传送的会话 ID 是nil，会由引擎来生成这个会话ID
---@param addr SERVICEADDR @目标服务地址
---@param typename string @类型名
---@vararg any @传输的数据
function skynet.call(addr, typename, ...)
end

---* **阻塞API**
---* 向一个服务，不打包发送数据，并期待得到响应
---* 收到回应后，也不走 unpack 流程。
---* 调用了此函数后，当前的线程会挂起，直到响应到达
---* 挂起期间，状态可能会变更，造成重入
---@param addr SERVICEADDR @目标服务地址
---@param typename string @类型名
---@param msg lightuserdata
---@param sz number
function skynet.rawcall(addr, typename, msg, sz)
end

--- https://blog.codingnow.com/2020/09/skynet_select.html
---@class request
local request = {}
request.__call = request.add

---@param obj table # {addr, typename, ...}
function request:add(obj)
end
function request:close()
end
function request:select(timeout)
end

---@param obj? table
---@return request
function skynet.request(obj)
end
---* 返回一个唯一的会话ID
---@return number
function skynet.genid()
end

---带跟踪的发送一条消息
---@param tag string
---@param addr SERVICEADDR
---@param typename string
---@param msg lightuserdata
---@param sz number
function skynet.tracecall(tag, addr, typename, msg, sz)
end

---------------- 服务的启动和退出API ---------------

---* 为 snlua 服务注册一个启动函数，在 Lua 加载完服务脚本后，并不会立即进行执行，而是会注册一个 0 的定时器，再回来执行。
---* 执行时，这个启动函数会在 skynet.init 注册的函数之后执行
---* 这个函数执行完毕后，方可收发消息
---* 注意，这个函数才会设置 snlua 服务的消息处理回调函数 skynet.dispatch_message，若在此之前就进行调用阻塞API，可能会卡住。
---* 这是因为，消息回调处理函数才会唤醒挂起的协程
---* **但是，不要在此函数外面调用 skynet 的阻塞 API ，因为框架将无法唤醒它们。**
---@param start_func fun()
function skynet.start(start_func)
end

---* 初始化服务,执行 skynet.init 注册的函数 和 start 函数，并向 .launcher 上报结果
---* 一般不直接使用，而是由 skynet.start 调用
---@param start fun()
function skynet.init_service(start)
end

---* 注册一个在 start_func 执行前的执行的函数
---@param fun fun()
function skynet.init(fun)
end

--- 用于退出当前的服务。skynet.exit 之后的代码都不会被运行。而且，当前服务被阻塞住的 coroutine 也会立刻中断退出。这些通常是一些 RPC 尚未收到回应。所以调用 skynet.exit() 请务必小心。
function skynet.exit()
end

--- 用于启动一个新的 Lua 服务。name 是脚本的名字（不用写 .lua 后缀）。只有被启动的脚本的 start 函数返回后，这个 API 才会返回启动的服务的地址，这是一个阻塞 API 。如果被启动的脚本在初始化环节抛出异常，或在初始化完成前就调用 skynet.exit 退出，skynet.newservice 都会抛出异常。如果被启动的脚本的 start 函数是一个永不结束的循环，那么 newservice 也会被永远阻塞住。
--- > 启动参数其实是以字符串拼接的方式传递过去的。所以不要在参数中传递复杂的 Lua 对象。接收到的参数都是字符串，且字符串中不可以有空格（否则会被分割成多个参数）。这种参数传递方式是历史遗留下来的，有很多潜在的问题。目前推荐的惯例是，让你的服务响应一个启动消息。在 newservice 之后，立刻调用 skynet.call 发送启动请求。
---@param name string #脚本名字
---@vararg string #可选参数
function skynet.newservice(name, ...)
end

--- 启动一个全局唯一服务
---* global 为 true 表示启动全局服务 ，信息从后面参数获取
---* global 为其他的，表示在本地启动一个本地唯一的服务，global 就代表了服务名
---@param global boolean|string
---@vararg any
function skynet.uniqueservice(global, ...)
end

--- 查询一个全局服务
---* global 为 true 表示启动全局服务 ，信息从后面参数获取
---* global 为其他的，表示在本地启动一个本地唯一的服务，global 就代表了服务名
---@param global boolean|string
---@vararg any
function skynet.queryservice(global, ...)
end

------------------ 时钟和线程 ------------------------

---* 将返回 skynet 节点进程内部时间。这个返回值的数值不是真实时间, 本身意义不大。
---* 不同节点在同一时刻取到的值也不相同。只有两次调用的差值才有意义。用来测量经过的时间, 单位是 1/100秒。
---* **(注意:这里的时间片表示小于skynet内部时钟周期的时间片,假如执行了比较费时的操作如超长时间的循环,或者调用了外部的阻塞调用,**
---* **如os.execute('sleep 1'), 即使中间没有skynet的阻塞api调用,两次调用的返回值还是会不同的.)**
---@return number
function skynet.now()
end

---* 如果你需要做性能分析，可以使用 skynet.hpc ，它会返回精度为 ns （1000000000 分之一 秒）的 64 位整数。
---@return number
function skynet.hpc()
end

---* 返回 skynet 节点进程启动的 UTC 时间，以秒为单位
---@return number
function skynet.starttime()
end

---返回以秒为单位（精度为小数点后两位）的 UTC 时间。它时间上等价于：skynet.now()/100 + skynet.starttime()
---@return number
function skynet.time()
end

---* 相当于 skynet.sleep(0) 。
---* 交出当前服务对 CPU 的控制权。通常在你想做大量的操作，又没有机会调用阻塞 API 时，可以选择调用 yield 让系统跑的更平滑。
function skynet.yield()
end

---* 让框架在 ti 个单位时间后，调用 func 这个函数。
---* 这不是一个阻塞 API ，当前 coroutine 会继续向下运行，而 func 将来会在新的 coroutine 中执行。
---* skynet 的定时器实现的非常高效，所以一般不用太担心性能问题。不过，如果你的服务想大量使用定时器的话，可以考虑一个更好的方法：
---* 即在一个service里，尽量只使用一个 skynet.timeout ，用它来触发自己的定时事件模块。
---* 这样可以减少大量从框架发送到服务的消息数量。毕竟一个服务在同一个单位时间能处理的外部消息数量是有限的。
---* 事实上，这个 API 相当于向引擎 调用 skynet.send 发送了一个请求，会由请求在定时器超时后进行响应，
---@param ti number @ ti 的单位是 0.01秒
---@param func fun() @回调函数
function skynet.timeout(ti, func)
end

---* **阻塞API**
---* 将当前 coroutine 挂起 ti 个单位时间。一个单位是 1/100 秒。
---* 它是向框架注册一个定时器实现的。框架会在 ti 时间后，发送一个定时器消息来唤醒这个 coroutine 。
---* 这是一个阻塞 API 。它的返回值会告诉你是时间到了，还是被 skynet.wakeup 唤醒 （返回 "BREAK"）。
---@param ti number ti*0.01s
---@param token? any 默认coroutine.running()
function skynet.sleep(ti, token)
end

---* skynet.wait(token) 把当前 coroutine 挂起，之后由 skynet.wakeup 唤醒。
---* 将当前线程移入 sleep 队列
---* token 必须是唯一的，默认为 coroutine.running() 。
---@param token any
function skynet.wait(token)
end

---* skynet.wakeup(token) 唤醒一个被 skynet.sleep 或 skynet.wait 挂起的 coroutine 。
---* 这会将一个处于 挂起状态，sleep 队列中的线程移到待唤醒的队列中，一旦主线程有一个挂起其他线程的操作，就会进行唤醒。
---* 在 1.0 版中 wakeup 不保证次序，目前的版本则可以保证。
function skynet.wakeup(token)
end

---* skynet.fork(func, ...) 从功能上，它等价于 skynet.timeout(0, function() func(...) end)
---* 但是比 timeout 高效一点。因为它并不需要向框架注册一个定时器。
---* fork 出来的线程的执行时机，是在处理完一条消息时。（skynet.start 内调用此 API 可以保证被触发执行，因为 start 注册的函数是以定时器的形式触发执行的）
---@param func function
---@vararg any
function skynet.fork(func, ...)
end

-------------- 日志跟踪 API -------------

---* 写日志
---@vararg any
function skynet.error(...)
end

---跟踪一条消息的处理
---* tag = string.format(":%08x-%d",skynet.self(), traceid
---@param info string notifymsg
function skynet.trace(info)
end

---返回当前线程的 trace tag
---* tag = string.format(":%08x-%d",skynet.self(), traceid
---@return string
function skynet.tracetag()
end

---是否打开超时跟踪
---@param on boolean
function skynet.trace_timeout(on)
end

---设置消息类型的跟踪标志
---* true: force on
---* false: force off
---* nil: optional (use skynet.trace() to trace one message)
---@param prototype string|number
---@param flag? boolean
function skynet.traceproto(prototype, flag)
end

----------------- 其他 API -------------
---设置回调
---@param fun function
---@param forward boolean @设置是否是进行转发，如果是 true 那消息将不会由 skynet 释放
function skynet.callback(fun, forward)

end

---干掉一个线程
---@param thread string | table
function skynet.killthread(thread)
end

---获取我们为 skynet 设置的环境变量
---@param key string
---@return any
function skynet.getenv(key)
end

---为 skynet 设置的环境变量
---@param key string
---@param value any
function skynet.setenv(key, value)
end

---返回当前线程的会话ID和协程地址
---@return number co_session, number co_address
function skynet.context()
end

----------------------状态相关 API ------------------
---是否 (c.intcommand("STAT", "endless") == 1)
function skynet.endless()
end

--- 返回队列长度 c.intcommand("STAT", "mqlen")
---@return number
function skynet.mqlen()
end

--- 返回状态信息 c.intcommand("STAT", what)
--- 可以返回当前服务的性能统计信息，what 可以是以下字符串。
---* "mqlen" 消息队列中堆积的消息数量。如果消息是均匀输入的，那么 mqlen 不断增长就说明已经过载。你可以在消息的 dispatch 函数中首先判断 mqlen ，在过载发生时做一些处理（至少 log 记录下来，方便定位问题）。
---* "cpu" 占用的 cpu 总时间。需要在 [[Config]] 配置 profile 为 true 。
---* "message" 处理的消息条数
---@param what string
function skynet.stat(what)
end

---返回任务信息
---@param ret any
function skynet.task(ret)
end

function skynet.uniqtask()
end

function skynet.term(service)
end

--- 只能调用一次，设置 lua 最多使用的内存字节属
---@param bytes integer
function skynet.memlimit(bytes)
end

------------------以下是属于 skynet.manager 中的 api

---* **skynet.manager API**
---* 启动一个C 服务，具体参数要看 C服务是怎么编写的
---@vararg any
function skynet.launch(...)
end

---* **skynet.manager API**
--- 可以用来强制关闭别的服务。但强烈不推荐这样做。因为对象会在任意一条消息处理完毕后，毫无征兆的退出。所以推荐的做法是，发送一条消息，让对方自己善后以及调用 skynet.exit 。注：skynet.kill(skynet.self()) 不完全等价于 skynet.exit() ，后者更安全。
---@param name number|string
function skynet.kill(name)
end

---* **skynet.manager API**
---* 向引擎发送一个 ABORT 命令，退出自身服务
function skynet.abort()
end

---* **skynet.manager API**
---* 给服务注册一个名字
---@param name string
function skynet.register(name)
end

---* **skynet.manager API**
---* 给服务命名 以 . 开头的名字是在同一 skynet 节点下有效的
---* skynet.name(name, skynet.self()) 和 skynet.register(name) 功能等价。
---@param name string
---@param handle number
function skynet.name(name, handle)
end

---* **skynet.manager API**
---* 将本服务实现为消息转发器，对一类消息进行转发
---* 设置指定类型的消息，不由 skynet 框架释放
---* 对于在 map 中的消息，不进行释放
---* 不在 map 中的消息，由 此函数中调用  skynet.trash 进行释放
---@param map table
---@param start_func function
function skynet.forward_type(map, start_func)
end

---* **skynet.manager API**
---过滤消息再处理。（注：filter 可以将 type, msg, sz, session, source 五个参数先处理过再返回新的 5 个参数。）
---@param f any
---@param start_func any
function skynet.filter(f, start_func)
end

---* **skynet.manager API**
---给当前 skynet 进程设置一个全局的服务监控。
---@param service any
---@param query any
function skynet.monitor(service, query)
end

-----------------------debug API--------------
---注册一个响应 debug console 中 info 命令的函数
---* 这个 API 不是由 skynet 模块定义，而是将 skynet 模块传递给 skynet.debug 模块后，由 skynet.debug 模块类似 mixin 的形式定义的
---@param fun fun()
function skynet.info_func(fun)

end
return skynet
