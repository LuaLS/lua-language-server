---@meta
resty_websocket_server={}
function resty_websocket_server.send_text(self, data) end
function resty_websocket_server.new(self, opts) end
function resty_websocket_server.send_ping(self, data) end
function resty_websocket_server.set_timeout(self, time) end
function resty_websocket_server.send_binary(self, data) end
function resty_websocket_server.send_frame() end
function resty_websocket_server.recv_frame(self) end
function resty_websocket_server.send_close(self, code, msg) end
resty_websocket_server._VERSION="0.07"
function resty_websocket_server.send_pong(self, data) end
return resty_websocket_server