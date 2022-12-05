---@meta
local base64 = {
  version = require("resty.core.base").version,
}

---Encode input using base64url rules. Returns the encoded string.
---@param s string
---@return string
function base64.encode_base64url(s) end

---Decode input using base64url rules. Returns the decoded string.
---
---If the input is not a valid base64url encoded string, decoded will be `nil`
---and err will be a string describing the error.
---
---@param  s       string
---@return string? decoded
---@return string? err
function base64.decode_base64url(s) end

return base64