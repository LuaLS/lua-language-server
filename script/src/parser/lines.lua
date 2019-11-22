local m = require 'lpeglabel'

local function utf8_len(buf, start, finish)
    local len, pos = utf8.len(buf, start, finish)
    if len then
        return len
    end
    return 1 + utf8_len(buf, start, pos-1) + utf8_len(buf, pos+1, finish)
end

local function Line(start, line, finish)
    line.start  = start
    line.finish = finish - 1
    return line
end

local function Space(...)
    local line = {...}
    local sp = 0
    local tab = 0
    for i = 1, #line do
        if line[i] == ' ' then
            sp = sp + 1
        elseif line[i] == '\t' then
            tab = tab + 1
        end
        line[i] = nil
    end
    line.sp  = sp
    line.tab = tab
    return line
end

local parser = m.P{
'Lines',
Lines   = m.Ct(m.V'Line'^0 * m.V'LastLine'),
Line    = m.Cp() * m.V'Indent' * (1 - m.V'Nl')^0 * m.Cp() * m.V'Nl' / Line,
LastLine= m.Cp() * m.V'Indent' * (1 - m.V'Nl')^0 * m.Cp() / Line,
Nl      = m.P'\r\n' + m.S'\r\n',
Indent  = m.C(m.S' \t')^0 / Space,
}

local mt = {}
mt.__index = mt

function mt:position(row, col, code)
    if row < 1 then
        return 1
    end
    code = code or self.code
    if row > #self then
        if code == 'utf8' then
            return utf8_len(self.buf) + 1
        else
            return #self.buf + 1
        end
    end
    local line = self[row]
    local next_line = self[row+1]
    local start = line.start
    local finish
    if next_line then
        finish = next_line.start - 1
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

local function isCharByte(byte)
    if not byte then
        return false
    end
    -- [0-9]
    if byte >= 48 and byte <= 57 then
        return true
    end
    -- [A-Z]
    if byte >= 65 and byte <= 90 then
        return true
    end
    -- [a-z]
    if byte >= 97 and byte <= 122 then
        return true
    end
    -- <utf8>
    if byte >= 128 then
        return true
    end
    return false
end

function mt:positionAsChar(row, col, code)
    local pos = self:position(row, col, code)
    if isCharByte(self.buf:byte(pos, pos)) then
        return pos
    elseif isCharByte(self.buf:byte(pos+1, pos+1)) then
        return pos + 1
    end
    return pos
end

function mt:rowcol(pos, code)
    if pos < 1 then
        return 1, 1
    end
    code = code or self.code
    if pos >= #self.buf + 1 then
        local start = self[#self].start
        if code == 'utf8' then
            return #self, utf8_len(self.buf, start) + 1
        else
            return #self, #self.buf - start + 2
        end
    end
    local min = 1
    local max = #self
    for _ = 1, 100 do
        if max == min then
            local start = self[min].start
            if code == 'utf8' then
                return min, utf8_len(self.buf, start, pos)
            else
                return min, pos - start + 1
            end
        end
        local row = (max - min) // 2 + min
        local start = self[row].start
        if pos < start then
            max = row
        elseif pos > start then
            local next_start = self[row + 1].start
            if pos < next_start then
                if code == 'utf8' then
                    return row, utf8_len(self.buf, start, pos)
                else
                    return row, pos - start + 1
                end
            elseif pos > next_start then
                min = row + 1
            else
                return row + 1, 1
            end
        else
            return row, 1
        end
    end
    error('rowcol failed!')
end

function mt:line(i)
    local start, finish = self:range(i)
    return self.buf:sub(start, finish)
end

function mt:range(i)
    if i < 1 or i > #self then
        return 0, 0
    end
    return self[i].start, self[i].finish
end

function mt:set_code(code)
    self.code = code
end

return function (self, buf, code)
    local lines, err = parser:match(buf)
    if not lines then
        return nil, err
    end
    lines.buf = buf
    lines.code = code

    return setmetatable(lines, mt)
end
