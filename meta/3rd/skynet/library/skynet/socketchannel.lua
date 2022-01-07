---@meta
---socket channel 在创建时，并不会立即建立连接。如果你什么都不做，那么连接建立会推迟到第一次 request 请求时。这种被动建立连接的过程会不断的尝试，即使第一次没有连接上，也会重试。
---@class socketchannel
local socket_channel = {}

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
---@return socketchannel
function socket_channel.channel(desc)

end

---连接频道
---@param once boolean tryConnectOnceOrMulti
function socket_channel:connect(once)

end

---返回值 true 表示协议解析成功，如果为 false 表示协议出错，这会导致连接断开且让 request 的调用者也获得一个 error
---在 response 函数内的任何异常以及 sock:read 或 sock:readline 读取出错，都会以 error 的形式抛给 request 的调用者。
---@alias ResponseFunction fun(sock:table): boolean, string

---发送请求
---@param request string binary 请求内容，若不填写 resonse，那么只发送而不接收
---@param response? ResponseFunction 返回值 true 表示协议解析成功，如果为 false 表示协议出错，这会导致连接断开且让 request 的调用者也获得一个 error
---@param padding? table
---@return string # 是由 response 函数返回的回应包的内容（可以是任意类型）
function socket_channel:request(request, response, padding)
end

---用来单向接收一个包。
---`local resp = channel:response(dispatch)` 与 `local resp = channel:request(req, dispatch)` 等价
---@param dispatch any
function socket_channel:response(dispatch)
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

