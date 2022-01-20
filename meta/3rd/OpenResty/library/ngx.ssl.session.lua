---@meta
local session={}

session.version = require("resty.core.base").version


--- Sets the serialized SSL session provided as the argument to the current SSL connection.
--- If the SSL session is successfully set, the current SSL connection can resume the session
--- directly without going through the full SSL handshake process (which is very expensive in terms of CPU time).
---
--- This API is usually used in the context of `ssl_session_fetch_by_lua*`
--- when a cache hit is found with the current SSL session ID.
---
--- The serialized SSL session used as the argument should be originally returned by the
--- `get_serialized_session` function.
---
---@param session string
---@return boolean ok
---@return string? error
function session.set_serialized_session(session) end

--- Returns the serialized form of the SSL session data of the current SSL connection, in a Lua string.
---
--- This session can be cached in `lua-resty-lrucache`, `lua_shared_dict`,
--- and/or external data storage services like `memcached` and `redis`. The SSL session ID returned
--- by the `get_session_id` function is usually used as the cache key.
---
--- The returned SSL session data can later be loaded into other SSL connections using the same
--- session ID via the `set_serialized_session` function.
---
--- In case of errors, it returns `nil` and a string describing the error.
---
--- This API function is usually called in the context of `ssl_session_store_by_lua*`
--- where the SSL handshake has just completed.
---
---@return string? session
---@return string? error
function session.get_serialized_session() end

--- Fetches the SSL session ID associated with the current downstream SSL connection.
--- The ID is returned as a Lua string.
---
--- In case of errors, it returns `nil` and a string describing the error.
---
--- This API function is usually called in the contexts of
--- `ssl_session_store_by_lua*` and `ssl_session_fetch_by_lua*`.
---
---@return string? id
---@return string? error
function session.get_session_id() end

return session