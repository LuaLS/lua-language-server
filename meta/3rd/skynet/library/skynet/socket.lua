---@meta
---* 所谓阻塞模式，实际上是利用了 lua 的 coroutine 机制。当你调用 socket api 时，服务有可能被挂起（时间片被让给其他业务处理)，待结果通过 socket 消息返回，coroutine 将延续执行。
---* socketdrver 的 Lua 层表示
---* 注意与 gateserver 的区别， 他们都会接管 socket 类型的消息
---@class socket
local socket = {}
---* 作为客户端，连接到一个 IP和端口
---* 会返回一个代表了 skynet 内部和系统套接字文件描述符相关的结构索引
---@param addr string @可以是一个IPV4地址，也可以是 'ip:port' 这样的形式，这种形式下，就可以不指定 Port
---@param port number @端口
---@return number @skynet对套接字描述符的表示
function socket.open(addr, port)
end
---* 绑定系统文件描述符
---@param os_fd  number
---@return number @skynet对套接字描述符的表示
function socket.bind(os_fd)
end
---* 等价于 socket.bind(0)，绑定到标准输出
---@return number @skynet对套接字描述符的表示
function socket.stdin()
end
---* accept 是一个函数。每当一个监听的 id 对应的 socket 上有连接接入的时候，都会调用 accept 函数。这个函数会得到接入连接的 id 以及 ip 地址。你可以做后续操作。
---* 开始收发套接字数据，并设置一个回调
---* 这个函数会将套接字索引与一个 Lua 的结构封装起来，并在协程内挂起 (skynet.wait)
---* 当有数据事件到达时，就会 skynet.wakeup 协程来
---@param id number @skynet套接字索引
---@param accept fun(...) @事件回调函数
---@return number | nil, error
function socket.start(id, accept)
end
---* 暂停收发一个套接字上的数据
---@param id number @skynet套接字索引
function socket.pause(id)
end
---* 强行关闭一个连接。和 close 不同的是，它不会等待可能存在的其它 coroutine 的读操作。
---* 一般不建议使用这个 API ，但如果你需要在 __gc 元方法中关闭连接的话，shutdown 是一个比 close 更好的选择（因为在 gc 过程中无法切换 coroutine）
---@param id number @skynet套接字索引
function socket.shutdown(id)
end
---* 在极其罕见的情况下，需要粗暴的直接关闭某个连接，而避免 socket.close 的阻塞等待流程，可以使用它。
---@param id number @skynet套接字索引
function socket.close_fd(id)
end
---* 关闭一个连接，这个 API 有可能阻塞住执行流。因为如果有其它 coroutine 正在阻塞读这个 id 对应的连接，会先驱使读操作结束，close 操作才返回。
---@param id number @skynet套接字索引
function socket.close(id)
end
---从一个 socket 上读 sz 指定的字节数。如果读到了指定长度的字符串，它把这个字符串返回。如果连接断开导致字节数不够，将返回一个 false 加上读到的字符串。如果 sz 为 nil ，则返回尽可能多的字节数，但至少读一个字节（若无新数据，会阻塞）。
---@param id number @skynet套接字索引
---@param sz number | nil @要读取的字节数,nil 尽可能多的读
---@return string | nil, string
function socket.read(id, sz)
end
---* 从一个 socket 上读所有的数据，直到 socket 主动断开，或在其它 coroutine 用 socket.close 关闭它。
---@param id number @skynet套接字索引
---@return buffer | nil, buffer
function socket.readall(id)
end
---* 从一个 socket 上读一行数据。sep 指行分割符。默认的 sep 为 "\n"。读到的字符串是不包含这个分割符的。
---@param id number @skynet套接字索引
---@return buffer | nil, buffer
function socket.readline(id, sep)
end

---* 等待一个 socket 可读
---@param id number @skynet套接字索引
function socket.block(id)
end
---* 是否合法套接字
---@param id number @skynet套接字索引
---@return boolean
function socket.invalid(id)
end
---* 是否已断开
---@param id number @skynet套接字索引
---@return boolean
function socket.disconnected(id)
end

---* 监听一个端口，返回一个 id ，供 start 使用。
---@param host string @地址，可以是 ip:port
---@param port number @断开，可为 nil，此时从 host 内获取端口信息
---@param backlog number @队列长度
---@return number @skynet套接字索引
function socket.listen(host, port, backlog)
end
---* 清除 socket id 在本服务内的数据结构，但并不关闭这个 socket 。这可以用于你把 id 发送给其它服务，以转交 socket 的控制权。
function socket.abandon(id)
end
---* 设置缓冲区大小
---@param id number @skynet套接字索引
---@param limit number @缓冲区大小
function socket.limit(id, limit)
end
function socket.udp(callback, host, port)
end
function socket.udp_connect(id, addr, port, callback)
end
function socket.warning(id, callback)
end
function socket.onclose(id, callback)
end
---* 把一个字符串置入正常的写队列，skynet 框架会在 socket 可写时发送它。
---* 这和 socketdriver.send 是一个
---@see socketdriver#send
---@param id number @skynet套接字索引
---@param msg string @数据
---@param sz number @大小
function socket.write(id, msg, sz)
end
---* 把字符串写入低优先级队列。如果正常的写队列还有写操作未完成时，低优先级队列上的数据永远不会被发出。只有在正常写队列为空时，才会处理低优先级队列。但是，每次写的字符串都可以看成原子操作。不会只发送一半，然后转去发送正常写队列的数据。
---@param id number @skynet套接字索引
---@param msg string @数据
function socket.lwrite()
end
function socket.header()
end

return socket
