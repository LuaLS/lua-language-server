---@meta
local clienthello = {}

clienthello.version = require("resty.core.base").version

---Returns the TLS SNI (Server Name Indication) name set by the client.
---
---Return `nil` when then the extension does not exist.
---
---In case of errors, it returns `nil` and a string describing the error.
---
---Note that the SNI name is gotten from the raw extensions of the client hello message associated with the current downstream SSL connection.
---
---So this function can only be called in the context of `ssl_client_hello_by_lua*`.
---@return string? host
---@return string? error
function clienthello.get_client_hello_server_name() end


--- Returns raw data of arbitrary SSL client hello extension including custom extensions.
---
--- Returns `nil` if the specified extension type does not exist.
---
--- In case of errors, it returns `nil` and a string describing the error.
---
--- Note that the ext is gotten from the raw extensions of the client hello message associated with the current downstream SSL connection.
---
--- So this function can only be called in the context of `ssl_client_hello_by_lua*`.
---
--- Example:
---
--- Gets server name from raw extension data. The `0` in `ssl_clt.get_client_hello_ext(0)` denotes `TLSEXT_TYPE_server_name`, and the `0` in `byte(ext, 3) ~= 0` denotes `TLSEXT_NAMETYPE_host_name`.
---
--- ```nginx
--- # nginx.conf
--- server {
---     listen 443 ssl;
---     server_name   test.com;
---     ssl_client_hello_by_lua_block {
---         local ssl_clt = require "ngx.ssl.clienthello"
---         local byte = string.byte
---         local ext = ssl_clt.get_client_hello_ext(0)
---         if not ext then
---             print("failed to get_client_hello_ext(0)")
---             ngx.exit(ngx.ERROR)
---         end
---         local total_len = string.len(ext)
---         if total_len <= 2 then
---             print("bad SSL Client Hello Extension")
---             ngx.exit(ngx.ERROR)
---         end
---         local len = byte(ext, 1) * 256 + byte(ext, 2)
---         if len + 2 ~= total_len then
---             print("bad SSL Client Hello Extension")
---             ngx.exit(ngx.ERROR)
---         end
---         if byte(ext, 3) ~= 0 then
---             print("bad SSL Client Hello Extension")
---             ngx.exit(ngx.ERROR)
---         end
---         if total_len <= 5 then
---             print("bad SSL Client Hello Extension")
---             ngx.exit(ngx.ERROR)
---         end
---         len = byte(ext, 4) * 256 + byte(ext, 5)
---         if len + 5 > total_len then
---             print("bad SSL Client Hello Extension")
---             ngx.exit(ngx.ERROR)
---         end
---         local name = string.sub(ext, 6, 6 + len -1)
---
---         print("read SNI name from Lua: ", name)
---     }
---     ssl_certificate test.crt;
---     ssl_certificate_key test.key;
--- }
--- ```
---
---@param ext_type number
---@return string? ext
function clienthello.get_client_hello_ext(ext_type) end


--- Sets the SSL protocols supported by the current downstream SSL connection.
---
--- Returns `true` on success, or a `nil` value and a string describing the error otherwise.
---
--- Considering it is meaningless to set ssl protocols after the protocol is determined,
--- so this function may only be called in the context of `ssl_client_hello_by_lua*`.
---
--- Example:
--- ```lua
---  ssl_clt.set_protocols({"TLSv1.1", "TLSv1.2", "TLSv1.3"})`
--- ```
---
---@param protocols string[]
---@return boolean ok
---@return string? error
function clienthello.set_protocols(protocols) end


return clienthello
