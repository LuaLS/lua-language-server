local M = { _NAME = "uri.pop" }
local URI = require "uri"
local Util = require "uri._util"
Util.subclass_of(M, URI)

-- This is the set of characters must be encoded in a POP userinfo, which
-- unlike for other schemes includes the ';' character.
local _POP_USERINFO_ENCODE = "^A-Za-z0-9%-._~%%!$&'()*+,=:"

function M.default_port () return 110 end

local function _update_userinfo (self, old, new)
    if new then
        local _, _, user, auth = new:find("^(.*);[Aa][Uu][Tt][Hh]=(.*)$")
        if not user then user = new end
        if user == "" then return "pop user name must not be empty" end
        user = Util.uri_encode(user, _POP_USERINFO_ENCODE)
        if auth then
            if auth == "" then return "pop auth type must not be empty" end
            if auth == "*" then auth = nil end
            auth = Util.uri_encode(auth, _POP_USERINFO_ENCODE)
        end
        new = user .. (auth and ";auth=" .. auth or "")
    end

    if new ~= old then M._SUPER.userinfo(self, new) end
    return nil
end

function M.init (self)
    if M._SUPER.path(self) ~= "" then
        return nil, "pop URIs must have an empty path"
    end

    local userinfo = M._SUPER.userinfo(self)
    local err = _update_userinfo(self, userinfo, userinfo)
    if err then return nil, err end

    return self
end

function M.userinfo (self, ...)
    local old = M._SUPER.userinfo(self)

    if select('#', ...) > 0 then
        local new = ...
        local err = _update_userinfo(self, old, new)
        if err then error(err) end
    end

    return old
end

function M.path (self, new)
    if new and new ~= "" then error("POP URIs must have an empty path") end
    return ""
end

local function _decode_userinfo (self)
    local old = M._SUPER.userinfo(self)
    if not old then return nil, nil end
    local _, _, old_user, old_auth = old:find("^(.*);auth=(.*)$")
    if not old_user then old_user = old end
    return old_user, old_auth
end

function M.pop_user (self, ...)
    local old_user, old_auth = _decode_userinfo(self)

    if select('#', ...) > 0 then
        local new = ...
        if new == "" then error("pop user name must not be empty") end
        if not new and old_auth then
            error("pop user name required when an auth type is specified")
        end
        if new then
            new = Util.uri_encode(new, _POP_USERINFO_ENCODE)
            if old_auth then new = new .. ";auth=" .. old_auth end
        end
        M._SUPER.userinfo(self, new)
    end

    return Util.uri_decode(old_user)
end

function M.pop_auth (self, ...)
    local old_user, old_auth = _decode_userinfo(self)

    if select('#', ...) > 0 then
        local new = ...
        if not new or new == ""
            then error("pop auth type must not be empty")
        end
        if new == "*" then new = nil end
        if new and not old_user then
            error("pop auth type can't be specified without user name")
        end
        if new then
            new = old_user .. ";auth=" ..
                  Util.uri_encode(new, _POP_USERINFO_ENCODE)
        else
            new = old_user
        end
        M._SUPER.userinfo(self, new)
    end

    return old_auth and Util.uri_decode(old_auth) or "*"
end

return M
-- vi:ts=4 sw=4 expandtab
