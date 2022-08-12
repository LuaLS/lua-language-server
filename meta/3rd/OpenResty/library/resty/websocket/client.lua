---@meta

---@class resty.websocket.client : resty.websocket
local client = {
  _VERSION = "0.09"
}

---Instantiates a WebSocket client object.
---
---In case of error, it returns nil and a string describing the error.
---
---An optional options table can be specified.
---
---@param  opts?                   resty.websocket.new.opts
---@return resty.websocket.client? client
---@return string?                 error
function client:new(opts) end

---Connects to the remote WebSocket service port and performs the websocket
---handshake process on the client side.
---
---Before actually resolving the host name and connecting to the remote backend,
---this method will always look up the connection pool for matched idle
---connections created by previous calls of this method.
---
---@param  url     string
---@param  opts?   resty.websocket.client.connect.opts
---@return boolean ok
---@return string? error
function client:connect(uri, opts) end

--- Puts the current WebSocket connection immediately into the ngx_lua cosocket connection pool.
---
--- You can specify the max idle timeout (in ms) when the connection is in the pool and the maximal size of the pool every nginx worker process.
---
--- In case of success, returns 1. In case of errors, returns nil with a string describing the error.
---
--- Only call this method in the place you would have called the close method instead. Calling this method will immediately turn the current WebSocket object into the closed state. Any subsequent operations other than connect() on the current object will return the closed error.
----
---@param  max_idle_timeout number
---@param  pool_size        integer
---@return boolean          ok
---@return string?          error
function client:set_keepalive(max_idle_timeout, pool_size) end

---Closes the current WebSocket connection.
---
---If no close frame is sent yet, then the close frame will be automatically sent.
---
---@return boolean ok
---@return string? error
function client:close() end

---@class resty.websocket.client.connect.opts : table
---
---@field protocols  string|string[]  subprotocol(s) used for the current WebSocket session
---@field origin     string           the value of the Origin request header
---@field pool       string           custom name for the connection pool being used. If omitted, then the connection pool name will be generated from the string template <host>:<port>.
---@field ssl_verify boolean          whether to perform SSL certificate verification during the SSL handshake if the wss:// scheme is used.
---@field headers    string[]         custom headers to be sent in the handshake request. The table is expected to contain strings in the format {"a-header: a header value", "another-header: another header value"}.


return client