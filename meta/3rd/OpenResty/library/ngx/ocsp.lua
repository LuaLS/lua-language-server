---@meta
local ocsp = {
  version = require("resty.core.base").version,
}

--- Extracts the OCSP responder URL (like "http://test.com/ocsp/") from the SSL server certificate chain in the DER format.
---
--- Usually the SSL server certificate chain is originally formatted in PEM. You can use the Lua API provided by the ngx.ssl module to do the PEM to DER conversion.
---
--- The optional max_len argument specifies the maximum length of OCSP URL allowed. This determines the buffer size; so do not specify an unnecessarily large value here. It defaults to the internal string buffer size used throughout this lua-resty-core library (usually default to 4KB).
---
--- In case of failures, returns `nil` and a string describing the error.
---
---@param  der_cert_chain string
---@param  max_len?       number
---@return string?        ocsp_url
---@return string?        error
function ocsp.get_ocsp_responder_from_der_chain(der_cert_chain, max_len) end

--- Validates the raw OCSP response data specified by the `ocsp_resp` argument using the SSL server certificate chain in DER format as specified in the `der_cert_chain` argument.
---
--- Returns true when the validation is successful.
---
--- In case of failures, returns `nil` and a string describing the failure. The maximum length of the error string is controlled by the optional `max_err_msg` argument (which defaults to the default internal string buffer size used throughout this lua-resty-core library, usually being 4KB).
---
---@param  ocsp_resp        string
---@param  der_cert_chain   string
---@param  max_err_msg_len? number
---@return boolean          ok
---@return string?          error
function ocsp.validate_ocsp_response(ocsp_resp, der_cert_chain, max_err_msg_len) end

--- Builds an OCSP request from the SSL server certificate chain in the DER format, which can be used to send to the OCSP server for validation.
---
--- The optional `max_len` argument specifies the maximum length of the OCSP request allowed. This value determines the size of the internal buffer allocated, so do not specify an unnecessarily large value here. It defaults to the internal string buffer size used throughout this lua-resty-core library (usually defaults to 4KB).
---
--- In case of failures, returns `nil` and a string describing the error.
---
--- The raw OCSP response data can be used as the request body directly if the POST method is used for the OCSP request. But for GET requests, you need to do base64 encoding and then URL encoding on the data yourself before appending it to the OCSP URL obtained by the `get_ocsp_responder_from_der_chain()` function.
---
---@param  der_cert_chain string
---@param  max_len?       number
---@return string?        ocsp_req
---@return string?        error
function ocsp.create_ocsp_request(der_cert_chain, max_len) end


--- Sets the OCSP response as the OCSP stapling for the current SSL connection.
---
--- Returns `true` in case of successes. If the SSL client does not send a "status request" at all, then this method still returns true but also with a string as the warning "no status req".
---
--- In case of failures, returns `nil` and a string describing the error.
---
--- The OCSP response is returned from CA's OCSP server. See the `create_ocsp_request()` function for how to create an OCSP request and also validate_ocsp_response for how to validate the OCSP response.
---
---@param  ocsp_resp string
---@return boolean   ok
---@return string?   error
function ocsp.set_ocsp_status_resp(ocsp_resp) end

return ocsp