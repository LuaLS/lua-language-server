---@meta

--- websocket object
--- https://github.com/openresty/lua-resty-websocket
---
---@class resty.websocket : table
---@field sock            tcpsock
---@field fatal           boolean
---@field max_payload_len number
---@field send_masked     boolean
resty_websocket = {}

---@param ms integer sets the timeout delay (in milliseconds) for the network-related operations
function resty_websocket:set_timeout(ms) end

---Sends the text argument out as an unfragmented data frame of the text type.
---
---Returns the number of bytes that have actually been sent on the TCP level.
---
---In case of errors, returns nil and a string describing the error.
---
---@param  text     string
---@return integer? bytes
---@return string?  error
function resty_websocket:send_text(text) end

---Sends the data argument out as an unfragmented data frame of the binary type.
---
---Returns the number of bytes that have actually been sent on the TCP level.
---
---In case of errors, returns nil and a string describing the error.
---
---@param  data     string
---@return integer? bytes
---@return string?  error
function resty_websocket:send_binary(data) end

---Sends out a ping frame with an optional message specified by the msg argument.
---Returns the number of bytes that have actually been sent on the TCP level.
---
---In case of errors, returns nil and a string describing the error.
---
---Note that this method does not wait for a pong frame from the remote end.
---
---@param  msg?     string
---@return integer? bytes
---@return string?  error
function resty_websocket:send_ping(msg) end

---Sends out a pong frame with an optional message specified by the msg argument.
---Returns the number of bytes that have actually been sent on the TCP level.
---
---In case of errors, returns nil and a string describing the error.
---@param  msg?     string
---@return integer? bytes
---@return string?  error
function resty_websocket:send_pong(msg) end

---Sends out a close frame with an optional status code and a message.
---
---In case of errors, returns nil and a string describing the error.
---
---For a list of valid status code, see the following document:
---
---http://tools.ietf.org/html/rfc6455#section-7.4.1
---
---Note that this method does not wait for a close frame from the remote end.
---@param  code?    integer
---@param  msg?     string
---@return integer? bytes
---@return string?  error
function resty_websocket:send_close(code, msg) end

---Sends out a raw websocket frame by specifying the fin field (boolean value), the opcode, and the payload.
---
---For a list of valid opcode, see
---
---http://tools.ietf.org/html/rfc6455#section-5.2
---
---In case of errors, returns nil and a string describing the error.
---
---To control the maximal payload length allowed, you can pass the max_payload_len option to the new constructor.
---
---To control whether to send masked frames, you can pass true to the send_masked option in the new constructor method. By default, unmasked frames are sent.
---@param  fin      boolean
---@param  opcode   resty.websocket.protocol.opcode
---@param  payload  string
---@return integer? bytes
---@return string?  error
function resty_websocket:send_frame(fin, opcode, payload) end

---Receives a WebSocket frame from the wire.
---
---In case of an error, returns two nil values and a string describing the error.
---
---The second return value is always the frame type, which could be one of continuation, text, binary, close, ping, pong, or nil (for unknown types).
---
---For close frames, returns 3 values: the extra status message (which could be an empty string), the string "close", and a Lua number for the status code (if any). For possible closing status codes, see
---
---http://tools.ietf.org/html/rfc6455#section-7.4.1
---
---For other types of frames, just returns the payload and the type.
---
---For fragmented frames, the err return value is the Lua string "again".
---
---@return string?                        data
---@return resty.websocket.protocol.type? typ
---@return string|integer?                error_or_status_code
function resty_websocket:recv_frame() end

---@class resty.websocket.new.opts : table
---@field max_payload_len  integer  maximal length of payload allowed when sending and receiving WebSocket frames
---@field send_masked      boolean  whether to send out masked WebSocket frames
---@field timeout          integer  network timeout threshold in milliseconds

return resty_websocket
