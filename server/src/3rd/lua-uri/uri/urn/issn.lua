local M = { _NAME = "uri.urn.issn" }
local Util = require "uri._util"
local URN = require "uri.urn"
Util.subclass_of(M, URN)

local function _parse_issn (issn)
    local _, _, nums1, nums2, checksum
        = issn:find("^(%d%d%d%d)-?(%d%d%d)([%dxX])$")
    if checksum == "x" then checksum = "X" end
    return nums1, nums2, checksum
end

local function _valid_issn (issn)
    local nums1, nums2, actual_checksum = _parse_issn(issn)
    if not nums1 then return nil, "invalid ISSN syntax" end
    local nums = nums1 .. nums2

    local expected_checksum = 0
    for i = 1, 7 do
        expected_checksum = expected_checksum + tonumber(nums:sub(i, i)) * (9 - i)
    end
    expected_checksum = (11 - expected_checksum % 11) % 11
    expected_checksum = (expected_checksum == 10) and "X"
                                                  or tostring(expected_checksum)
    if actual_checksum ~= expected_checksum then
        return nil, "wrong checksum, expected " .. expected_checksum
    end

    return true
end

local function _normalize_issn (issn)
    local nums1, nums2, checksum = _parse_issn(issn)
    return nums1 .. "-" .. nums2 .. checksum
end

function M.init (self)
    local nss = self:nss()
    local ok, msg = _valid_issn(nss)
    if not ok then return nil, "bad NSS value for ISSN URI (" .. msg .. ")" end
    M._SUPER.nss(self, _normalize_issn(nss))
    return self
end

function M.nss (self, new)
    local old = M._SUPER.nss(self)

    if new then
        local ok, msg = _valid_issn(new)
        if not ok then
            error("bad ISSN value '" .. new .. "' (" .. msg .. ")")
        end
        M._SUPER.nss(self, _normalize_issn(new))
    end

    return old
end

function M.issn_digits (self, new)
    local old = self:nss(new)
    return old:sub(1, 4) .. old:sub(6, 9)
end

return M
-- vi:ts=4 sw=4 expandtab
