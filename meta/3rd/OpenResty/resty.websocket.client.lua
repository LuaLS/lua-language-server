---@meta
resty_websocket_client={}
function resty_websocket_client.send_text(self, data) end
function resty_websocket_client.new(self, opts) end
function resty_websocket_client.send_ping(self, data) end
function resty_websocket_client.connect(self, uri, opts) end
function resty_websocket_client.set_timeout(self, time) end
function resty_websocket_client.set_keepalive(self, ...) end
function resty_websocket_client.send_binary(self, data) end
function resty_websocket_client.send_close() end
function resty_websocket_client.send_frame() end
function resty_websocket_client.recv_frame(self) end
function resty_websocket_client.close(self) end
resty_websocket_client._VERSION="0.07"
function resty_websocket_client.send_pong(self, data) end
return resty_websocket_client