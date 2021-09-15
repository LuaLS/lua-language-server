local m = require 'lpeglabel'

local mt = {}

local function catchedTable()
    return setmetatable({}, mt)
end

function mt.__add(a, b)
    if not a or not b then
        return a or b
    end
    local t = catchedTable()
    for _, v in ipairs(a) do
        t[#t+1] = v
    end
    for _, v in ipairs(b) do
        t[#t+1] = v
    end
    return t
end

local function parseTokens(script, seps)
    local parser = m.P {
        m.Ct(m.V 'Token'^0),
        Token = m.Cp() * (m.V 'Mark' + m.V 'Nl' + m.V 'Text'),
        Mark  = m.Cc 'ML' * m.P '<' * m.C(m.S(seps))
              + m.Cc 'MR' * m.C(m.S(seps)) * m.P '>',
        Nl    = m.Cc 'NL' * m.C(m.P '\r\n' + m.S '\r\n'),
        Text  = m.Cc 'TX' * m.C((1 - m.V 'Nl' - m.V 'Mark')^1),
    }
    local results = parser:match(script)
    return results
end

---@param script string
---@param seps string
return function (script, seps)
    local tokens = parseTokens(script, seps)
    local newBuf = {}
    local result = {}
    local marks  = {}

    local lineOffset = 1
    local line       = 0
    local skipOffset = 0
    for i = 1, #tokens, 3 do
        local offset = tokens[i + 0]
        local mode   = tokens[i + 1]
        local text   = tokens[i + 2]
        if mode == 'TX' then
            newBuf[#newBuf+1] = text
        end
        if mode == 'NL' then
            newBuf[#newBuf+1] = text
            line = line + 1
            lineOffset = offset + #text - skipOffset
        end
        if mode == 'ML' then
            marks[#marks+1] = {
                char     = text,
                position = line * 10000 + offset - skipOffset - lineOffset,
            }
            skipOffset = skipOffset + 1 + #text
        end
        if mode == 'MR' then
            for j = #marks, 1, -1 do
                local mark = marks[j]
                if mark.char == text then
                    local position = line * 10000 + offset - skipOffset - lineOffset
                    if not result[text] then
                        result[text] = catchedTable()
                    end
                    result[text][#result[text]+1] = { mark.position, position }
                    table.remove(marks, j)
                    break
                end
            end
            skipOffset = skipOffset + 1 + #text
        end
    end

    return table.concat(newBuf), result
end
