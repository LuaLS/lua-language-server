local M = { _NAME = "uri.urn.oid" }
local Util = require "uri._util"
local URN = require "uri.urn"
Util.subclass_of(M, URN)

-- This implements RFC 3061.

local function _valid_oid (oid)
    if oid == "" then return nil, "OID can't be zero-length" end
    if not oid:find("^[.0-9]*$") then return nil, "bad character in OID" end
    if oid:find("%.%.") then return nil, "missing number in OID" end
    if oid:find("^0[^.]") or oid:find("%.0[^.]") then
        return nil, "OID numbers shouldn't have leading zeros"
    end
    return true
end

function M.init (self)
    local nss = self:nss()
    local ok, msg = _valid_oid(nss)
    if not ok then return nil, "bad NSS value for OID URI (" .. msg .. ")" end
    return self
end

function M.nss (self, new)
    local old = M._SUPER.nss(self)

    if new then
        local ok, msg = _valid_oid(new)
        if not ok then
            error("bad OID value '" .. new .. "' (" .. msg .. ")")
        end
        M._SUPER.nss(self, new)
    end

    return old
end

function M.oid_numbers (self, new)
    local old = Util.split("%.", self:nss())
    for i = 1, #old do old[i] = tonumber(old[i]) end

    if new then
        if type(new) ~= "table" then error("expected array of numbers") end
        local nss = ""
        for _, n in ipairs(new) do
            if type(n) == "string" and n:find("^%d+$") then n = tonumber(n) end
            if type(n) ~= "number" then error("bad type for number in OID") end
            n = n - n % 1
            if n < 0 then error("negative numbers not allowed in OID") end
            if nss ~= "" then nss = nss .. "." end
            nss = nss .. n
        end
        if nss == "" then error("no numbers in new OID value") end
        self:nss(nss)
    end

    return old
end

return M
-- vi:ts=4 sw=4 expandtab
