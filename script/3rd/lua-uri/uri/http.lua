local M = { _NAME = "uri.http" }
local Util = require "uri._util"
local URI = require "uri"
Util.subclass_of(M, URI)

-- This implementation is based on RFC 2616 section 3.2 and RFC 1738
-- section 3.3.
--
-- An HTTP URI with a 'userinfo' field is considered invalid, because it isn't
-- shown in the syntax given in RFC 2616, and is explicitly disallowed by
-- RFC 1738.

function M.default_port () return 80 end

function M.init (self)
    if self:userinfo() then
        return nil, "usernames and passwords are not allowed in HTTP URIs"
    end

    -- RFC 2616 section 3.2.3 says that this is OK, but not that using the
    -- redundant slash is canonical.  I'm adding it because browsers tend to
    -- treat the version with the extra slash as the normalized form, and
    -- the initial slash is always present in an HTTP GET request.
    if self:path() == "" then self:path("/") end

    return self
end

Util.uri_part_not_allowed(M, "userinfo")

return M
-- vi:ts=4 sw=4 expandtab
