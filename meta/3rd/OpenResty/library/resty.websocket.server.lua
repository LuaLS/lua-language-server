---@meta

---@class resty.websocket.server : resty.websocket
resty_websocket_server = {
  _VERSION = "0.09"
}

---Performs the websocket handshake process on the server side and returns a WebSocket server object.
---
---In case of error, it returns nil and a string describing the error.
---@param  opts?                   resty.websocket.new.opts
---@return resty.websocket.server? server
---@return string?                 error
function resty_websocket_server:new(opts) end

return resty_websocket_server