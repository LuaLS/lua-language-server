---@meta
resty_websocket_protocol={}
function resty_websocket_protocol.build_frame() end
function resty_websocket_protocol.new_tab() end
function resty_websocket_protocol.send_frame(sock, fin, opcode, payload, max_payload_len, masking) end
resty_websocket_protocol._VERSION="0.07"
function resty_websocket_protocol.recv_frame(sock, max_payload_len, force_masking) end
return resty_websocket_protocol