---@meta
---*网络数据打包解包模块
---*每个包就是 2 个字节 + 数据内容。这两个字节是 Big-Endian 编码的一个数字。数据内容可以是任意字节。
---@class netpack
local netpack = {}

---进行分包处理事件判断
---* netpack的使用者可以通过filter返回的type来分别进行事件处理。
---* 会返回 data, more, error, open, close, warning 表示事件类型及每个事件需要的参数
---* 对于SOCKET_DATA事件，filter会进行数据分包，如果分包后刚好有一条完整消息，filter返回的type为”data”，其后跟fd msg size。 如果不止一条消息，那么数据将被依次压入queue参数中，并且仅返回一个type为”more”。 queue是一个userdata，可以通过netpack.pop 弹出queue中的一条消息。
---* 其余type类型”open”，”error”, “close”分别SOCKET_ACCEPT, SOCKET_ERROR, SOCKET_CLOSE事件。
---* netpack会尽可能多地分包，交给上层。并且通过一个哈希表保存每个套接字ID对应的粘包，在下次数据到达时，取出上次留下的粘包数据，重新分包.
---@param queue userdata @一个存放消息的队列
---@param msg lightuserdata @收到的数据
---@param sz number @收到的数据长度
---@return string
function netpack.filter(queue, msg, sz)
end
---从队列中弹出一条消息
---@param queue userdata
---@return fd, msg, sz
function netpack.pop(queue)
end
---* 把一个字符串（或一个 C 指针加一个长度）打包成带 2 字节包头的数据块。
---* 这和我们我们用 string.pack('>I2') 打包字符串长度，再连上字符串是一样的，不过，这样打包后是在，string pack 是在 Lua 管理，而不是 C 管理
---* 这个 api 返回一个lightuserdata 和一个 number 。你可以直接送到 socket.write 发送（socket.write 负责最终释放内存）。
---@param msg string | lightuserdata @当是 lightuserdata 的时候，需要指定 sz
---@param sz number | nil @当是一个字符串的时候，不需要这个参数
---@return lightuserdata,number
function netpack.pack(msg, sz)
end
---清除一个队列
---@param queue any
function netpack.clear(queue)
end
---把 handler.message 方法收到的 msg,sz 转换成一个 lua string，并释放 msg 占用的 C 内存。
---@param msg any
---@param sz any
---@return string
function netpack.tostring(msg, sz)
end

return netpack
