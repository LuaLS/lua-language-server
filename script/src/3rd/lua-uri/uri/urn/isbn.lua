local M = { _NAME = "uri.urn.isbn" }
local Util = require "uri._util"
local URN = require "uri.urn"
Util.subclass_of(M, URN)

-- This implements the 'isbn' NID defined in RFC 3187, and is consistent
-- with the same NID suggested in RFC 2288.

local function _valid_isbn (isbn)
    if not isbn:find("^[-%d]+[%dXx]$") then return nil, "invalid character" end
    local ISBN = Util.attempt_require("isbn")
    if ISBN then return ISBN:new(isbn) end
    return isbn
end

local function _normalize_isbn (isbn)
    isbn = isbn:gsub("%-", ""):upper()
    local ISBN = Util.attempt_require("isbn")
    if ISBN then return tostring(ISBN:new(isbn)) end
    return isbn
end

function M.init (self)
    local nss = self:nss()
    local ok, msg = _valid_isbn(nss)
    if not ok then return nil, "invalid ISBN value (" .. msg .. ")" end
    self:nss(_normalize_isbn(nss))
    return self
end

function M.nss (self, new)
    local old = M._SUPER.nss(self)

    if new then
        local ok, msg = _valid_isbn(new)
        if not ok then
            error("bad ISBN value '" .. new .. "' (" .. msg .. ")")
        end
        M._SUPER.nss(self, _normalize_isbn(new))
    end

    return old
end

function M.isbn_digits (self, new)
    local old = self:nss():gsub("%-", "")

    if new then
        local ok, msg = _valid_isbn(new)
        if not ok then
            error("bad ISBN value '" .. new .. "' (" .. msg .. ")")
        end
        self._SUPER.nss(self, _normalize_isbn(new))
    end

    return old
end

function M.isbn (self, new)
    local ISBN = require "isbn"
    local old = ISBN:new(self:nss())
    if new then self:nss(tostring(new)) end
    return old
end

return M
-- vi:ts=4 sw=4 expandtab
