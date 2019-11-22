local M = { _NAME = "uri.data" }
local Util = require "uri._util"
local URI = require "uri"
Util.subclass_of(M, URI)

-- This implements the 'data' scheme defined in RFC 2397.

local Filter = Util.attempt_require("datafilter")

local function _valid_base64 (data) return data:find("^[0-9a-zA-Z/+]*$") end

local function _split_path (path)
    local _, _, mediatype, data = path:find("^([^,]*),(.*)")
    if not mediatype then return "must have comma in path" end
    local base64 = false
    if mediatype:find(";base64$") then
        base64 = true
        mediatype = mediatype:sub(1, -8)
    end
    if base64 and not _valid_base64(data) then
        return "illegal character in base64 encoding"
    end
    return nil, mediatype, base64, data
end

function M.init (self)
    if M._SUPER.host(self) then
        return nil, "data URIs may not have authority parts"
    end
    local err, mediatype, base64, data = _split_path(M._SUPER.path(self))
    if err then return nil, "invalid data URI (" .. err .. ")" end
    return self
end

function M.data_media_type (self, ...)
    local _, old, base64, data = _split_path(M._SUPER.path(self))

    if select('#', ...) > 0 then
        local new = ... or ""
        new = Util.uri_encode(new, "^A-Za-z0-9%-._~!$&'()*+;=:@/")
        if base64 then new = new .. ";base64" end
        M._SUPER.path(self, new .. "," .. data)
    end

    if old ~= "" then
        if old:find("^;") then old = "text/plain" .. old end
        return Util.uri_decode(old)
    else
        return "text/plain;charset=US-ASCII"    -- default type
    end
end

local function _urienc_len (s)
    local num_unsafe_chars = s:gsub("[A-Za-z0-9%-._~!$&'()*+,;=:@/]", ""):len()
    local num_safe_chars = s:len() - num_unsafe_chars
    return num_safe_chars + num_unsafe_chars * 3
end

local function _base64_len (s)
    local num_blocks = (s:len() + 2) / 3
    num_blocks = num_blocks - num_blocks % 1
    return num_blocks * 4
           + 7      -- because of ";base64" marker
end

local function _do_filter (algorithm, input)
    return Filter[algorithm](input)
end

function M.data_bytes (self, ...)
    local _, mediatype, base64, old = _split_path(M._SUPER.path(self))
    if base64 then
        if not Filter then
            error("'datafilter' Lua module required to decode base64 data")
        end
        old = _do_filter("base64_decode", old)
    else
        old = Util.uri_decode(old)
    end

    if select('#', ...) > 0 then
        local new = ... or ""
        local urienc_len = _urienc_len(new)
        local base64_len = _base64_len(new)
        if base64_len < urienc_len and Filter then
            mediatype = mediatype .. ";base64"
            new = _do_filter("base64_encode", new)
        else
            new = new:gsub("%%", "%%25")
        end
        M._SUPER.path(self, mediatype .. "," .. new)
    end

    return old
end

function M.path (self, ...)
    local old = M._SUPER.path(self)

    if select('#', ...) > 0 then
        local new = ...
        if not new then error("there must be a path in a data URI") end
        local err = _split_path(new)
        if err then error("invalid data URI (" .. err .. ")") end
        M._SUPER.path(self, new)
    end

    return old
end

Util.uri_part_not_allowed(M, "userinfo")
Util.uri_part_not_allowed(M, "host")
Util.uri_part_not_allowed(M, "port")

return M
-- vi:ts=4 sw=4 expandtab
