local M = { _NAME = "uri._relative" }
local Util = require "uri._util"
local URI = require "uri"
Util.subclass_of(M, URI)

-- There needs to be an 'init' method in this class, to because the base-class
-- one expects there to be a 'scheme' value.
function M.init (self)
    return self
end

function M.scheme (self, ...)
    if select("#", ...) > 0 then
        error("relative URI references can't have a scheme, perhaps you" ..
              " need to resolve this against an absolute URI instead")
    end
    return nil
end

function M.is_relative () return true end

-- This implements the algorithm from RFC 3986 section 5.2.3
-- Note that this takes an additional argument which appears to be required
-- by the algorithm, but isn't shown when it is used in the RFC.
local function _merge_paths (base, r, base_has_auth)
    if base_has_auth and base == "" then
        return "/" .. r
    end

    return base:gsub("[^/]+$", "", 1) .. r
end

local function _do_resolve (self, base)
    if type(base) == "string" then base = assert(URI:new(base)) end
    setmetatable(self, URI)

    if self:host() or self:userinfo() or self:port() then
        -- network path reference, just needs a scheme
        self:path(Util.remove_dot_segments(self:path()))
        self:scheme(base:scheme())
        return
    end

    local path = self:path()
    if path == "" then
        self:path(base:path())
        if not self:query() then self:query(base:query()) end
    else
        if path:find("^/") then
            self:path(Util.remove_dot_segments(path))
        else
            local base_has_auth = base:host() or base:userinfo() or base:port()
            local merged = _merge_paths(base:path(), path, base_has_auth)
            self:path(Util.remove_dot_segments(merged))
        end
    end
    self:host(base:host())
    self:userinfo(base:userinfo())
    self:port(base:port())
    self:scheme(base:scheme())
end

function M.resolve (self, base)
    local orig = tostring(self)
    local ok, result = pcall(_do_resolve, self, base)
    if ok then return end

    -- If the resolving causes an exception, it means that the resulting URI
    -- would be invalid, so we restore self to its original state and rethrow
    -- the exception.
    local restored = assert(URI:new(orig))
    for k in pairs(self) do self[k] = nil end
    for k, v in pairs(restored) do self[k] = v end
    setmetatable(self, getmetatable(restored))
    error("resolved URI reference would be invalid: " .. result)
end

function M.relativize (self, base) end      -- already relative

return M
-- vi:ts=4 sw=4 expandtab
