local M = { _NAME = "uri.telnet" }
local Util = require "uri._util"
local LoginURI = require "uri._login"
Util.subclass_of(M, LoginURI)

function M.default_port () return 23 end

function M.init (self)
    self, err = M._SUPER.init_base(self)
    if not self then return nil, err end

    -- RFC 4248 does not discuss what a path longer than '/' might mean, and
    -- there are no examples with anything significant in the path, so I'm
    -- assuming that extra information in the path is not allowed.
    local path = M._SUPER.path(self)
    if path ~= "" and path ~= "/" then
        return nil, "superfluous information in path of telnet URI"
    end

    -- RFC 4248 section 2 says that the '/' can be omitted.  I chose to
    -- normalize to having it there, since the example shown in the RFC has
    -- it, and this is consistent with the way I treat HTTP URIs.
    if path == "" then self:path("/") end

    return self
end

-- The path is always '/', so setting it won't do anything, but we do throw
-- an exception on an attempt to set it to anything invalid.
function M.path (self, new)
    if new and new ~= "" and new ~= "/" then
        error("invalid path for telnet URI")
    end
    return "/"
end

return M
-- vi:ts=4 sw=4 expandtab
