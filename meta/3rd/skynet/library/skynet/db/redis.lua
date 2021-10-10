---@meta
local redis   = {}

---@class redisconfig
---@field host string
---@field port integer
---@field overload boolean
---@field auth table
---@field db integer
---@field username? string

---其他指令还可以动态生成
---更多命令查看 https://www.redis.com.cn/commands.html
local command = {}
function command:disconnect() end
function command:exists(k) end
function command:sismember(key, value) end
function command:pipeline(ops, resp) end

--- watch mode, only can  do  SUBSCRIBE, PSUBSCRIBE, UNSUBSCRIBE, PUNSUBSCRIBE, PING  and QUIT command.
local watch   = {}
function watch:disconnect() end
---阻塞模式读取消息
function watch:message() end
---subscribe channel
function watch:subscribe(...) end
---pattern subscribe channels
function watch:psubscribe(...) end
---unsubscribe
function watch:unsubscribe(...) end
---punsubscribe
function watch:punsubscribe(...) end

---connect to redis server
---@param conf redisconfig
---@return command
function redis.connect(conf) end

---connect to redis server on watch mode
---@param conf redisconfig
---@return watch
function redis.watch(conf) end

return redis
