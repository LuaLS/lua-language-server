local m = require 'lpeglabel'

local function utf8_len(buf, start, finish)
    local len, pos = utf8.len(buf, start, finish)
    if len then
        return len
    end
    return 1 + utf8_len(buf, start, pos-1) + utf8_len(buf, pos+1, finish)
end

local function Line(pos, str, ...)
    local line = {...}
    local sp = 0
    local tab = 0
    for i = 1, #line do
        if line[i] == ' ' then
            sp = sp + 1
        else
            tab = tab + 1
        end
        line[i] = nil
    end
    line[1] = pos
    line[2] = sp
    line[3] = tab
    return line
end

local parser = m.P{
'Lines',
Lines   = m.Ct(m.V'Line'^0 * m.V'LastLine'),
Line    = m.Cp() * m.C(m.V'Indent' * (1 - m.V'Nl')^0 * m.V'Nl') / Line,
LastLine= m.Cp() * m.C(m.V'Indent' * (1 - m.V'Nl')^0) / Line,
Nl      = m.P'\r\n' + m.S'\r\n',
Indent  = m.C(m.S' \t')^0,
}

local mt = {}
mt.__index = mt

function mt:position(row, col, code)
    if row < 1 then
        return 1
    end
    if row > #self then
        if code == 'utf8' then
            return utf8_len(self.buf) + 1
        else
            return #self.buf + 1
        end
    end
    local line = self[row]
    local next_line = self[row+1]
    local start = line[1]
    local finish
    if next_line then
        finish = next_line[1] - 1
    else
        finish = #self.buf + 1
    end
    local pos
    if code == 'utf8' then
        pos = utf8.offset(self.buf, col, start) or finish
    else
        pos = start + col - 1
    end
    if pos < start then
        pos = start
    elseif pos > finish then
        pos = finish
    end
    return pos
end

function mt:rowcol(pos, code)
    if pos < 1 then
        return 1, 1
    end
    if pos > #self.buf + 1 then
        local start = self[#self][1]
        if code == 'utf8' then
            return #self, utf8_len(self.buf, start) + 1
        else
            return #self, #self.buf - start + 2
        end
    end
    local min = 1
    local max = #self
    for _ = 1, 100 do
        local row = (max - min) // 2 + min
        local start = self[row][1]
        if pos < start then
            max = row
        elseif pos > start then
            local next_start = self[row + 1][1]
            if pos < next_start then
                if code == 'utf8' then
                    return row, utf8_len(self.buf, start, pos)
                else
                    return row, pos - start + 1
                end
            elseif pos > next_start then
                min = row
            else
                return row + 1, 1
            end
        else
            return row, 1
        end
    end
    error('rowcol failed!')
end

return function (self, buf)
    local lines, err = parser:match(buf)
    if not lines then
        return nil, err
    end
    lines.buf = buf

    return setmetatable(lines, mt)
end
