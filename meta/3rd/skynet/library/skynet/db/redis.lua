---@meta
local redis = {}

---@class redisconfig
---@field host string
---@field port integer
---@field overload boolean
---@field auth table
---@field db integer
---@field username? string

---一个 Redis 连接，返回这个 Command 对象。当在此对象上执行指令时，若指令不存在，会在第一次执行的时候构造
---指令对象的方法。
---指令的参数的第一个可以是 nil, 也可以是 table，还可以有多个参数。
---异步形式，底层用 socketchannel 进行通信，这点要注意。
---更多命令查看 [https://www.redis.com.cn/commands.html](https://www.redis.com.cn/commands.html)
---@see socketchannel
---@class command
local command = {}
function command:disconnect()
end

---Is key exists
---@param k string
---@return boolean
function command:exists(k)
end

---Does value is a member of set key.
---@param key string #key of a set
---@param value string #value
function command:sismember(key, value)
end

---Pipline command
---If resp is a table and exits, return boolean, resp.
---Or return the last result. boolean, out
---@param ops string[]
---@param resp? table
function command:pipeline(ops, resp)
end

--- watch mode, only can  do  SUBSCRIBE, PSUBSCRIBE, UNSUBSCRIBE, PUNSUBSCRIBE, PING  and QUIT command.
--- we can call watch:message in endless loop.
---@class watch
local watch = {}
function watch:disconnect()
end

---阻塞模式读取消息
function watch:message()
end

---subscribe channel
function watch:subscribe(...)
end

---pattern subscribe channels
function watch:psubscribe(...)
end

---unsubscribe
function watch:unsubscribe(...)
end

---punsubscribe
function watch:punsubscribe(...)
end

---connect to redis server
---@param conf redisconfig
---@return command
function redis.connect(conf)
end

---connect to redis server on watch mode
---@param conf redisconfig
---@return watch
function redis.watch(conf)
end

return redis
