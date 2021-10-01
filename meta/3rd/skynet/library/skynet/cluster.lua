---@meta
---* cluster 相关的库
---* 这个库，使用了一个叫 clusterd 的服务来进行工作
---@class cluster
local cluster = {}

---* 对某个节点上的服务传输消息
---@param node string @配置中给出的节点名
---@param address string | number @推荐使用 . 开头本地服务名，因为没有必要再用 master/slave 模式
---@varargs any @传输数据
function cluster.call(node, address, ...)
end
---* 对某个节点上的服务传输消息
---* 越节点推送消息有丢失消息的风险。因为 cluster 基于 tcp 连接，当 cluster 间的连接断开，cluster.send 的消息就可能丢失。而这个函数会立刻返回，所以调用者没有机会知道发送出错。
---@param node string @配置中给出的节点名
---@param address string | number @推荐使用 . 开头本地服务名，因为没有必要再用 master/slave 模式
---@varargs any @传输数据
function cluster.send(node, address, ...)
end
---* 打开节点
---* 如果参数是一个节点名，那么会从配置文件中加载的名称对应的IP和端口进行监听
---* 实际上就是开了一个 gate 服务，监听套接字
---@param port string | number @节点名或者是端口号
function cluster.open(port)
end
---* 重新加载节点配置信息
---* Cluster 是去中心化的，所以需要在每台机器上都放置一份配置文件（通常是相同的）。
---* 通过调用 cluster.reload 可以让本进程重新加载配置。
---* 如果你修改了每个节点名字对应的地址，那么 reload 之后的请求都会发到新的地址。
---* 而之前没有收到回应的请求还是会在老地址上等待。如果你老的地址已经无效（通常是主动关闭了进程）那么请求方会收到一个错误。
---@param config  table @ 名称=IP:端口键值对
function cluster.reload(config)
end
---* 为某个节点上的服务生成一个代理服务 clusterproxy
---@param node string
---@param name string
function cluster.proxy(node, name)
end
function cluster.snax(node, name, address)
end
---* 可以把 addr 注册为 cluster 可见的一个字符串名字 name 。如果不传 addr 表示把自身注册为 name 。
---@param name string
---@param addr number
function cluster.register(name, addr)
end
---* 查询节点上服务的地址
---@param node string
---@param name string
---@return number
function cluster.query(node, name)
end
return cluster
