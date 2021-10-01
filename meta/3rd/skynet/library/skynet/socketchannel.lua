---@meta
---socket channel 在创建时，并不会立即建立连接。如果你什么都不做，那么连接建立会推迟到第一次 request 请求时。这种被动建立连接的过程会不断的尝试，即使第一次没有连接上，也会重试。
---@class socketchannel
local socket_channel = {}
socket_channel.error = setmetatable(
                           {}, {
        __tostring = function()
            return "[Error: socket]"
        end,
    })

---创建一个新的套接字频道
---返回结构：
---* {
---*     __host = assert(desc.host),
---*     __port = assert(desc.port),
---*     __backup = desc.backup,
---*     __auth = desc.auth,
---*     __response = desc.response,	-- It's for session mode
---*     __request = {},	-- request seq { response func or session }	-- It's for order mode
---*     __thread = {}, -- coroutine seq or session->coroutine map
---*     __result = {}, -- response result { coroutine -> result }
---*     __result_data = {},
---*     __connecting = {},
---*     __sock = false,
---*     __closed = false,
---*     __authcoroutine = false,
---*     __nodelay = desc.nodelay,
---*     __overload_notify = desc.overload,
---*     __overload = false,
---* }
---@param desc table {host, port, backup, auth, response, nodelay, overload}
function socket_channel.channel(desc)

end

---连接频道
---@param once boolean tryConnectOnceOrMulti
function socket_channel:connect(once)

end
---发送请求
---@param request string
---@param response? fun(sock:table): boolean, string
---@param padding? table
---@return string
function socket_channel:request(request, response, padding)
end

function socket_channel:response(response)
end
---关闭频道
function socket_channel:close()

end
---改变目标主机[端口]，打开状态会关闭
---@param host string
---@param port? number
function socket_channel:changehost(host, port)
end
---改变备用
---@param backup table
function socket_channel:changebackup(backup)
end
return socket_channel

