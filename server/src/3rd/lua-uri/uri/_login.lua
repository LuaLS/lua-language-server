local M = { _NAME = "uri._login" }
local Util = require "uri._util"
local URI = require "uri"
Util.subclass_of(M, URI)

-- Generic terminal logins.  This is used as a base class for 'telnet' and
-- 'ftp' URL schemes.

local function _valid_userinfo (userinfo)
    if userinfo then
        local colon = userinfo:find(":")
        if colon and userinfo:find(":", colon + 1) then
            return nil, "only one colon allowed in userinfo"
        end
    end
    return true
end

-- TODO - this is a bit of a hack because currently subclasses are required
-- to know whether their superclass has one of these that needs calling.
-- It should be called from 'init' before anything more specific is done,
-- and it has the same calling convention.
-- According to RFC 1738 there should be at most one colon in the userinfo.
-- I apply that restriction for schemes where it's used for a username/password
-- pair.
function M.init_base (self)
    local host = self:host()
    if not host or host == "" then
        return nil, "host missing from login URI"
    end

    local ok, err = _valid_userinfo(self:userinfo())
    if not ok then return nil, err end

    return self
end

function M.userinfo (self, ...)
    if select("#", ...) > 0 then
        local ok, err = _valid_userinfo(...)
        if not ok then error("invalid userinfo value (" .. err .. ")") end
    end
    return M._SUPER.userinfo(self, ...)
end

function M.username (self, ...)
    local info = M._SUPER.userinfo(self)
    local old, colon
    if info then
        local colon = info and info:find(":")
        old = colon and info:sub(1, colon - 1) or info
        old = Util.uri_decode(old)
    end

    if select('#', ...) > 0 then
        local pass = colon and info:sub(colon) or ""    -- includes colon
        local new = ...
        if not new then
            M._SUPER.userinfo(self, nil)
        else
            -- Escape anything that's not allowed in a userinfo, and also
            -- colon, because that indicates the end of the username.
            new = Util.uri_encode(new, "^A-Za-z0-9%-._~!$&'()*+,;=")
            M._SUPER.userinfo(self, new .. pass)
        end
    end

    return old
end

function M.password (self, ...)
    local info = M._SUPER.userinfo(self)
    local old, colon
    if info then
        colon = info and info:find(":")
        old = colon and info:sub(colon + 1) or nil
        if old then old = Util.uri_decode(old) end
    end

    if select('#', ...) > 0 then
        local new = ...
        local user = colon and info:sub(1, colon - 1) or info
        if not new then
            M._SUPER.userinfo(self, user)
        else
            if not user then user = "" end
            new = Util.uri_encode(new, "^A-Za-z0-9%-._~!$&'()*+,;=")
            M._SUPER.userinfo(self, user .. ":" .. new)
        end
    end

    return old
end

return M
-- vi:ts=4 sw=4 expandtab
