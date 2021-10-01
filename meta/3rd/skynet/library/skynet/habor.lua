---@meta
---* 多节点相关的 API
---@class harbor
local harbor = {}

---*  注册一个全局名字。如果 handle 为空，则注册自己。skynet.name 和 skynet.register 是用其实现的。
---@param name string @服务名称
---@param handle number | nil @服务地址，可为空，表示注册自己
function harbor.globalname(name, handle)
end
---*  可以用来查询全局名字或本地名字对应的服务地址。它是一个阻塞调用。
---@param name string
function harbor.queryname(name)
end
---* 用来监控一个 slave 是否断开。如果 harbor id 对应的 slave 正常，这个 api 将阻塞。当 slave 断开时，会立刻返回。
---@param id number @harbor id
function harbor.link(id)
end
---* 和 harbor.link 相反。如果 harbor id 对应的 slave 没有连接，这个 api 将阻塞，一直到它连上来才返回。
---@param id number @harbor id
function harbor.connect(id)
end
---*  用来在 slave 上监控和 master 的连接是否正常。这个 api 多用于异常时的安全退出（因为当 slave 和 master 断开后，没有手段可以恢复）。
function harbor.linkmaster()
end

return harbor
