local m = require 'lpeglabel'

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
    line = line,
}
