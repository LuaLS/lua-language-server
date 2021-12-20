---@meta

---@class resty.websocket.protocol
resty_websocket_protocol = {
  _VERSION = "0.09",
}

--- Websocket op code
---
--- Defines the interpretation of the payload data.
---
--- See RFC 6455 section 5.2
---
---@alias resty.websocket.protocol.opcode
---| '0x0' # continuation
---| '0x1' # text
---| '0x2' # binary
---| '0x8' # close
---| '0x9' # ping
---| '0xa' # pong

---@alias resty.websocket.protocol.type
---| '"continuation"'
---| '"text"'
---| '"binary"'
---| '"close"'
---| '"ping"'
---| '"pong"'

--- Builds a raw WebSocket frame.
---@param  fin         boolean
---@param  opcode      resty.websocket.protocol.opcode
---@param  payload_len integer
---@param  payload     string
---@param  masking     boolean
---@return string
function resty_websocket_protocol.build_frame(fin, opcode, payload_len, payload, masking) end

--- Sends a raw WebSocket frame.
---@param  sock            tcpsock
---@param  fin             boolean
---@param  opcode          resty.websocket.protocol.opcode
---@param  payload         string
---@param  max_payload_len interger
---@param  masking         boolean
---@return bytes?          number
---@return string?         error
function resty_websocket_protocol.send_frame(sock, fin, opcode, payload, max_payload_len, masking) end

--- Receives a WebSocket frame from the wire.
---@param  sock                           tcpsock
---@param  max_payload_len                interger
---@param  force_masking                  boolean
---@return string?                        data
---@return resty.websocket.protocol.type? typ
---@return string?                        error
function resty_websocket_protocol.recv_frame(sock, max_payload_len, force_masking) end

return resty_websocket_protocol