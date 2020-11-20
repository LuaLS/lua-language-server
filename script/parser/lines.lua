local m = require 'lpeglabel'

_ENV = nil

local function Line(start, line, range, finish)
    line.start  = start
    line.finish = finish - 1
    line.range  = range  - 1
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
Line    = m.Cp() * m.V'Indent' * (1 - m.V'Nl')^0 * m.Cp() * m.V'Nl' * m.Cp() / Line,
LastLine= m.Cp() * m.V'Indent' * (1 - m.V'Nl')^0 * m.Cp() * m.Cp() / Line,
Nl      = m.P'\r\n' + m.S'\r\n',
Indent  = m.C(m.S' \t')^0 / Space,
}

return function (self, text)
    local lines, err = parser:match(text)
    if not lines then
        return nil, err
    end

    return lines
end
