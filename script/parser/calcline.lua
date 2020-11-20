local m    = require 'lpeglabel'
local util = require 'utility'

local row
local fl
local NL = (m.P'\r\n' + m.S'\r\n') * m.Cp() / function (pos)
    row = row + 1
    fl = pos
end
local ROWCOL = (NL + m.P(1))^0
local function rowcol(str, n)
    row = 1
    fl = 1
    ROWCOL:match(str:sub(1, n))
    local col = n - fl + 1
    return row, col
end

local function rowcol_utf8(str, n)
    row = 1
    fl = 1
    ROWCOL:match(str:sub(1, n))
    return row, util.utf8Len(str, fl, n)
end

local function position(str, _row, _col)
    local cur = 1
    local row = 1
    while true do
        if row == _row then
            return cur + _col - 1
        elseif row > _row then
            return cur - 1
        end
        local pos = str:find('[\r\n]', cur)
        if not pos then
            return #str
        end
        row = row + 1
        if str:sub(pos, pos+1) == '\r\n' then
            cur = pos + 2
        else
            cur = pos + 1
        end
    end
end

local function position_utf8(str, _row, _col)
    local cur = 1
    local row = 1
    while true do
        if row == _row then
            return utf8.offset(str, _col, cur)
        elseif row > _row then
            return cur - 1
        end
        local pos = str:find('[\r\n]', cur)
        if not pos then
            return #str
        end
        row = row + 1
        if str:sub(pos, pos+1) == '\r\n' then
            cur = pos + 2
        else
            cur = pos + 1
        end
    end
end

local NL = m.P'\r\n' + m.S'\r\n'

local function line(str, row)
    local count = 0
    local res
    local LINE = m.Cmt((1 - NL)^0, function (_, _, c)
        count = count + 1
        if count == row then
            res = c
            return false
        end
        return true
    end)
    local MATCH = (LINE * NL)^0 * LINE
    MATCH:match(str)
    return res
end

return {
    rowcol = rowcol,
    rowcol_utf8 = rowcol_utf8,
    position = position,
    position_utf8 = position_utf8,
    line = line,
}
