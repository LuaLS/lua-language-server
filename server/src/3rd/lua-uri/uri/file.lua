local M = { _NAME = "uri.file" }
local Util = require "uri._util"
local URI = require "uri"
Util.subclass_of(M, URI)

function M.init (self)
    if self:userinfo() or self:port() then
        return nil, "usernames and passwords are not allowed in HTTP URIs"
    end

    local host = self:host()
    local path = self:path()
    if host then
        if host:lower() == "localhost" then self:host("") end
    else
        if not path:find("^/") then
            return nil, "file URIs must contain a host, even if it's empty"
        end
        self:host("")
    end

    if path == "" then self:path("/") end

    return self
end

function M.host (self, ...)
    local old = M._SUPER.host(self)

    if select('#', ...) > 0 then
        local new = ...
        if not new then error("file URIs must have an authority part") end
        if new:lower() == "localhost" then new = "" end
        M._SUPER.host(self, new)
    end

    return old
end

function M.path (self, ...)
    local old = M._SUPER.path(self)

    if select('#', ...) > 0 then
        local new = ...
        if not new or new == "" then new = "/" end
        M._SUPER.path(self, new)
    end

    return old
end

local function _os_implementation (os)
    local FileImpl = Util.attempt_require("uri.file." .. os:lower())
    if not FileImpl then
        error("no file URI implementation for operating system " .. os)
    end
    return FileImpl
end

function M.filesystem_path (self, os)
    return _os_implementation(os).filesystem_path(self)
end

function M.make_file_uri (path, os)
    return _os_implementation(os).make_file_uri(path)
end

Util.uri_part_not_allowed(M, "userinfo")
Util.uri_part_not_allowed(M, "port")

return M
-- vi:ts=4 sw=4 expandtab
