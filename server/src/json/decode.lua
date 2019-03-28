local lpeg = require 'lpeglabel'
local save_sort
local table_pack = table.pack

local P = lpeg.P
local S = lpeg.S
local R = lpeg.R
local V = lpeg.V
local C = lpeg.C
local Ct = lpeg.Ct
local Cg = lpeg.Cg
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
    __debugger_extand = function (self)
        local list = {}
        for k, v in pairs(self) do
            k = tostring(k)
            list[#list+1] = k
            list[k] = v
        end
        return list
    end,
}

local tointeger = math.tointeger
local tonumber = tonumber
local setmetatable = setmetatable
local rawset = rawset
local function HashTable(patt)
    return C(patt) / function (_, ...)
        local hash = table_pack(...)
        local n = hash.n
        hash.n = nil
        if save_sort then
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
    Sp     = S' \t',
    Spnl   = (V'Sp' + V'Nl')^0,
    Bool   = C(P'true' + P'false') / BoolMap,
    Int    = C('0' + (P'-'^-1 * R'19' * R'09'^0)) / tointeger,
    Float  = C(P'-'^-1 * ('0' + R'19' * R'09'^0) * '.' * R'09'^0) / tonumber,
    Null   = P'null' * Cc(nil),
    String = '"' * Cs(V'Char'^0) * '"',
    Char   = V'Esc' + (1 - P'"' - P'\t' - V'Nl'),
    Esc    = P'\\' * C(S'tnr"\\') / EscMap,
    Hash   = V'Spnl' * '{' * V'Spnl' * HashTable(V'Object'^-1 * (P',' * V'Object')^0) * V'Spnl' * P'}' * V'Spnl',
    Array  = V'Spnl' * '[' * V'Spnl' * Ct(V'Value'^-1 * (P',' * V'Spnl' * V'Value')^0) * V'Spnl' * P']' * V'Spnl',
    Object = V'Spnl' * V'Key' * V'Spnl' * V'Value' * V'Spnl',
    Key    = V'String' * V'Spnl' * ':',
    Value  = V'Hash' + V'Array' + V'Bool' + V'Null' + V'String' + V'Float' + V'Int',
}

return function (str, save_sort_)
    save_sort = save_sort_
    local table, res, pos = Token:match(str)
    if not table then
        if not pos or pos <= #str then
            pos = pos or 1
            error(('没匹配完[%s][%s]\n%s'):format(pos, res, str:sub(pos, pos+100)))
        end
    end
    return table
end
