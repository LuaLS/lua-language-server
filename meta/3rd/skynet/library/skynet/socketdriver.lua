---@meta
---@class socketdriver
local socketdriver = {}
---* 作为客户端，连接到一个 IP和端口
---* 会返回一个代表了 skynet 内部和系统套接字文件描述符相关的结构索引
---@param addr string @可以是一个IPV4地址，也可以是 'ip:port' 这样的形式，这种形式下，就可以不指定 Port
---@param port number @端口
---@return number @skynet对套接字描述符的表示
function socketdriver.connect(addr, port)
end
---关闭连接
---* close/shutdown 实际上都会构造指令发给 skynet 引擎，执行同一套逻辑
---* 不同的是，如果是 shutdown 调用会强制关闭套接字
---* 而 close 只会在没有更多需要发送的数据才会关闭
---* 两个函数都会调用操作系统的系统调用  close
---@param id number @skynet对套接字描述符的表示
function socketdriver.close(id)
end
---关闭连接
---* close/shutdown 实际上都会构造指令发给 skynet 引擎，执行同一套逻辑
---* 不同的是，如果是 shutdown 调用会强制关闭套接字
---* 而 close 只会在没有更多需要发送的数据才会关闭
---* 两个函数都会调用操作系统的系统调用  close
---@param id number @skynet对套接字描述符的表示
function socketdriver.shutdown(id)
end
---监听套接字
---@param host string
---@param port number
---@param backlog number
---@return number @skynet对套接字描述符的表示
function socketdriver.listen(host, port, backlog)
end
---发送数据，这个函数会将我们要发送的数据放到一个 socket_sendbuffer 内，再丢给 skynet，由网络线程进行发送
---* socket_sendbuffer 需要一个缓冲区指针、缓冲区类型、长度来表示
---* 发送的数据，可以是 userdata/lightuserdata/string
---* 当传递的是 userdata 的时候，可以指定 sz ，否则由 lua_rawlen 来计算，由 VM 来释放
---* 当传递的是 lightuserdata，若不指定 sz，会被当成 SOCKET_BUFFER_OBJECT，由 socket 相关的函数来释放，若指定，则当成SOCKET_BUFFER_MEMORY ，由 free 释放
---* 当传递的是 table，那么会自动计算长度，SOCKET_BUFFER_MEMORY
---* 默认情况下是当成 string，自动计算长度
---@param id number @skynet对套接字描述符的表示
---@param msg table | lightuserdata | userdata | string @要传输的数据
---@param sz number | nil @长度
function socketdriver.send(id, msg, sz)
end
---低优先发送数据
---* 当传递的是 userdata 的时候，可以指定 sz ，否则由 lua_rawlen 来计算，由 VM 来释放
---* 当传递的是 lightuserdata，若不指定 sz，会被当成 SOCKET_BUFFER_OBJECT，由 socket 相关的函数来释放，若指定，则当成SOCKET_BUFFER_MEMORY ，由 free 释放
---* 当传递的是 table，那么会自动计算长度
---* 默认情况下是当成 string，自动计算长度
---@param id number @skynet对套接字描述符的表示
---@param msg table | lightuserdata | userdata | string @要传输的数据
---@param sz number | nil @长度
function socketdriver.lsend()
end
---绑定系统套接字到一个skynet的索引
---@param fd number
---@return number @skynet索引
function socketdriver.bind(fd)
end
---启动收发数据
---@param id number @skynet对套接字描述符的表示
function socketdriver.start(id)
end
---暂停收发数据
---@param id number @skynet对套接字描述符的表示
function socketdriver.pause(id)
end
---设置 TCP 套接字的 TCP_NODELAY 标志，尽可能快的将数据发出去，而不是等待缓冲区满或到达最大分组才发送
---@param id number @skynet对套接字描述符的表示
function socketdriver.nodelay(id)
end
---开启 udp 服务
---@param addr string
---@param port number | nil
function socketdriver.udp(addr, port)
end
---连接 udp 服务
---@param id any
---@param addr string
---@param port number | nil
function socketdriver.udp_connect(id, addr, port)
end
function socketdriver.udp_send(id, addr, msg)
end
function socketdriver.udp_address()
end
---解析主机IP
---@param host string
function socketdriver.resolve(host)
end
---新开一个 socket_buffer ，作为 userdata 返回回来
---* socket_buffer 是一个 buffer_node 链表
function socketdriver.buffer()
end
---数据放到缓冲区
---* 表 pool 记录了所有的缓冲区块，位于索引 1 的是一个 lightuserdata: free_node
---* 我们总是可以使用将这个指针当成 buffer_node。
---* 接下来的索引处都是 userdata，缓冲区块（buffer_node），只有在 VM 关闭的时候才会释放他们。
---* 索引 2 处的第一块长度是 16 * buffer_node，第二块是 32*buffer_node。
---* 这个函数会从 pool 处获取一个空闲的 buffer_node，然后将 msg/sz 放到里面。
---* pop 会将 buffer_node 返回给 pool
---@param buffer userdata
---@param pool table
---@param msg lightuserdata
---@param sz number
---@return number
function socketdriver.push(buffer, pool, msg, sz)
end
---* pop 会将 buffer_node 返回给 pool
---@param buffer userdata
---@param pool table
---@param sz number
function socketdriver.pop(buffer, pool, sz)
end
---丢弃消息
---@param msg userdata
---@param sz number
---@return string  @返回的是 binary string
function socketdriver.drop(msg, sz)
end
---将数据全部读到Lua缓冲区
---@param buffer userdata
---@param pool table
---@return string  @返回的是 binary string
function socketdriver.readall(buffer, pool)
end
---清除缓冲区
---@param buffer userdata
---@param pool table
function socketdriver.clear(buffer, pool)
end
---读取 sep 分隔符分隔的行
---@param buffer userdata
---@param pool table
---@param sep string
function socketdriver.readline(buffer, pool, sep)
end
---字符串转 lightuserdata
---@param msg string
---@return lightuserdata,number
function socketdriver.str2p(msg)
end
---获取字符串的长度
---@param str string
---@return number
function socketdriver.header(str)
end
function socketdriver.info()
end
---解包数据
---@param msg lightuserdata
---@param sz number
---@return number,number,number, lightuserdata|string
function socketdriver.unpack(msg, sz)
end

return socketdriver
