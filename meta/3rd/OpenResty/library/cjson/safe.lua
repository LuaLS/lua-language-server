---@meta

--- The `cjson.safe` module behaves identically to the `cjson` module, except when
--- errors are encountered during JSON conversion. On error, the `cjson.safe.encode`
--- and `cjson.safe.decode` functions will return `nil` followed by the error message.
---
--- @see cjson
---
---@class cjson.safe : cjson
local cjson_safe = {}


--- unserialize a json string to a lua value
---
--- Returns `nil` and an error string when the input cannot be decoded.
---
--- ```lua
--- local value, err = cjson_safe.decode(some_json_string)
--- ```
---@param json string
---@return any? decoded
---@return string? error
function cjson_safe.decode(json) end


--- serialize a lua value to a json string
---
--- Returns `nil` and an error string when the input cannot be encoded.
---
--- ```lua
--- local json, err = cjson_safe.encode(some_lua_value)
--- ```
---@param value any
---@return string? encoded
---@return string? error
function cjson_safe.encode(value) end


--- instantiate an independent copy of the Lua CJSON module
---
--- The new module has a separate persistent encoding buffer, and default settings
---@return cjson.safe
function cjson_safe.new() end


return cjson_safe
