local M = { _NAME = "uri.ftp" }
local Util = require "uri._util"
local LoginURI = require "uri._login"
Util.subclass_of(M, LoginURI)

function M.default_port () return 21 end

function M.init (self)
    self, err = M._SUPER.init_base(self)
    if not self then return nil, err end

    local host = self:host()
    if not host or host == "" then
        return nil, "FTP URIs must have a hostname"
    end

    -- I don't think there's any distinction in FTP URIs between empty path
    -- and the root directory, so probably best to normalize as we do for HTTP.
    if self:path() == "" then self:path("/") end

    return self
end

function M.path (self, ...)
    local old = M._SUPER.path(self)

    if select("#", ...) > 0 then
        local new = ...
        if not new or new == "" then new = "/" end
        M._SUPER.path(self, new)
    end

    return old
end

function M.ftp_typecode (self, ...)
    local path = M._SUPER.path(self)
    local _, _, withouttype, old = path:find("^(.*);type=(.*)$")
    if not withouttype then withouttype = path end
    if old == "" then old = nil end

    if select("#", ...) > 0 then
        local new = ...
        if not new then new = "" end
        if new ~= "" then new = ";type=" .. new end
        M._SUPER.path(self, withouttype .. new)
    end

    return old
end

return M
-- vi:ts=4 sw=4 expandtab
