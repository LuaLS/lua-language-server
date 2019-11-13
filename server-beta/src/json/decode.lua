local lpeg         = require 'lpeglabel'
local tablePack    = table.pack
local rawset       = rawset
local tointeger    = math.tointeger
local tonumber     = tonumber
local setmetatable = setmetatable
local stringChar   = string.char
local error        = error

_ENV = nil

local SaveSort
local P  = lpeg.P
local S  = lpeg.S
local R  = lpeg.R
local V  = lpeg.V
local C  = lpeg.C
local Ct = lpeg.Ct
local Cc = lpeg.Cc
local Cp = lpeg.Cp
local Cs = lpeg.Cs

local EscMap = {
    ['t']  = '\t',
    ['r']  = '\r',
    ['n']  = '\n',
    ['"']  = '"',
    ['\\'] = '\\',
}
local BoolMap = {
    ['true']  = true,
    ['false'] = false,
}

local hashmt = {
    __pairs = function (self)
        local i = 1
        local function next()
            i = i + 1
            local k = self[i]
            if k == nil then
                return
            end
            local v = self[k]
            if v == nil then
                return next()
            end
            return k, v
        end
        return next
    end,
    __newindex = function (self, k, v)
        local i = 2
        while self[i] do
            i = i + 1
        end
        rawset(self, i, k)
        rawset(self, k, v)
    end,
}

-----------------------------------------------------------------------------
-- JSON4Lua: JSON encoding / decoding support for the Lua language.
-- json Module.
-- Author: Craig Mason-Jones
-- Homepage: http://github.com/craigmj/json4lua/
-- Version: 1.0.0
-- This module is released under the MIT License (MIT).
-- Please see LICENCE.txt for details.
--
local function Utf8(str)
    local n = tonumber(str, 16)
    -- math.floor(x/2^y) == lazy right shift
    -- a % 2^b == bitwise_and(a, (2^b)-1)
    -- 64 = 2^6
    -- 4096 = 2^12 (or 2^6 * 2^6)
    local x
    if n < 0x80 then
        x = stringChar(n % 0x80)
    elseif n < 0x800 then
        -- [110x xxxx] [10xx xxxx]
        x = stringChar(0xC0 + ((n // 64) % 0x20), 0x80 + (n % 0x40))
    else
        -- [1110 xxxx] [10xx xxxx] [10xx xxxx]
        x = stringChar(0xE0 + ((n // 4096) % 0x10), 0x80 + ((n // 64) % 0x40), 0x80 + (n % 0x40))
    end
    return x
end

local function HashTable(patt)
    return C(patt) / function (_, ...)
        local hash = tablePack(...)
        local n = hash.n
        hash.n = nil
        if SaveSort then
            local max = n // 2
            for i = 1, max do
                local key, value = hash[2*i-1], hash[2*i]
                hash[key] = value
                hash[i+1] = key
            end
            hash[1] = nil
            for i = max+2, max*2 do
                hash[i] = nil
            end
            return setmetatable(hash, hashmt)
        else
            local max = n // 2
            for i = 1, max do
                local a = 2*i-1
                local b = 2*i
                local key, value = hash[a], hash[b]
                hash[key] = value
                hash[a] = nil
                hash[b] = nil
            end
            return hash
        end
    end
end

local Token = P
{
    V'Value' * Cp(),
    Nl     = P'\r\n' + S'\r\n',
    Sp     = S' \t' + '//' * (1-V'Nl')^0,
    Spnl   = (V'Sp' + V'Nl')^0,
    Bool   = C(P'true' + P'false') / BoolMap,
    Int    = C('0' + (P'-'^-1 * R'19' * R'09'^0)) / tointeger,
    Float  = C(P'-'^-1 * ('0' + R'19' * R'09'^0) * '.' * R'09'^0) / tonumber,
    Null   = P'null' * Cc(nil),
    String = '"' * Cs(V'Char'^0) * '"',
    Char   = V'Esc' + V'Utf8' + (1 - P'"' - P'\t' - V'Nl'),
    Esc    = P'\\' * C(S'tnr"\\') / EscMap,
    Utf8   = P'\\u' * C(P(4)) / Utf8,
    Hash   = V'Spnl' * '{' * V'Spnl' * HashTable((V'Object' + P',' * V'Spnl')^0) * V'Spnl' * P'}' * V'Spnl',
    Array  = V'Spnl' * '[' * V'Spnl' * Ct((V'Value' * V'Spnl' + P',' * V'Spnl')^0) * V'Spnl' * P']' * V'Spnl',
    Object = V'Spnl' * V'Key' * V'Spnl' * V'Value' * V'Spnl',
    Key    = V'String' * V'Spnl' * ':',
    Value  = V'Hash' + V'Array' + V'Bool' + V'Null' + V'String' + V'Float' + V'Int',
}

return function (str, save_sort_)
    SaveSort = save_sort_
    local table, res, pos = Token:match(str)
    if not table then
        if not pos or pos <= #str then
            pos = pos or 1
            error(('没匹配完[%s][%s]\n%s'):format(pos, res, str:sub(pos, pos+100)))
        end
    end
    return table
end
