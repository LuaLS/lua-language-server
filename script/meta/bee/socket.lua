---@meta

---@alias bee.socket.protocol
---| 'tcp'
---| 'udp'
---| 'unix'
---| 'tcp6'
---| 'udp6'

---@class bee.socket
---@overload fun(protocol: bee.socket.protocol): bee.socket.fd?, string?
local socket = {}

---@param readfds? bee.socket.fd[]
---@param writefds? bee.socket.fd[]
---@param timeout number
---@return bee.socket.fd[] # readfds
---@return bee.socket.fd[] # writefds
function socket.select(readfds, writefds, timeout) end

---@param handle lightuserdata
---@return bee.socket.fd
function socket.fd(handle) end

---@return bee.socket.fd
---@return bee.socket.fd
function socket.pair() end

---@class bee.socket.fd
local fd = {}

---@param addr string
---@param port? integer
---@return boolean
---@return string?
function fd:bind(addr, port) end

function fd:close() end

---@return boolean
---@return string?
function fd:listen() end

---@param addr string
---@param port integer
---@return boolean
---@return string?
function fd:connect(addr, port) end

---@param len? integer
---@return string | false
function fd:recv(len) end

---@param content string
function fd:send(content) end

---@return lightuserdata
function fd:handle() end

---@return lightuserdata
function fd:detach() end

---@return boolean
function fd:status() end

---@return bee.socket.fd
function fd:accept() end

return socket
