---@meta
---* 此模块使用了一个唯一服务  multicastd 来进行通信
---@class multicast
local multicast = {}

---@class channel_meta
---@field delete fun() @删除频道自身
---@field publish fun(...) @发布消息
---@field subscribe fun() @订阅频道，这个必须调用之后才能收到消息
---@field unsubscribe fun() @取消订阅

---@class multicastchannel : channel_meta
---@field channel number @频道ID
---@field __pack fun(...) @打包函数 默认 skynet.pack
---@field __unpack fun(...) @解包函数 默认 skynet.unpack
---@field __dispatch fun(...) @分发函数

---新建频道
---@param conf table
---@return multicastchannel
function multicast.new(conf)
end

return multicast
