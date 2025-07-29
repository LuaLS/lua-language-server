local l = require 'lpeglabel'

---@class Catched
---@operator add: Catched
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

function mt.__eq(a, b)
    if not a or not b then
        return false
    end
    if #a ~= #b then
        return false
    end
    table.sort(a, function (m, n)
        if m[1] == n[1] then
            return m[2] < n[2]
        end
        return m[1] < n[1]
    end)
    table.sort(b, function (m, n)
        if m[1] == n[1] then
            return m[2] < n[2]
        end
        return m[1] < n[1]
    end)
    for i = 1, #a do
        if a[i][1] ~= b[i][1] then
            return false
        end
        if a[i][2] ~= b[i][2] then
            return false
        end
    end
    return true
end

local function parseTokens(script, seps)
    local parser = l.P {
        l.Ct(l.V 'Token'^0),
        Token = l.Cp() * (l.V 'Raw' + l.V 'Mark' + l.V 'Nl' + l.V 'Text'),
        Mark  = l.Cc 'ML' * l.P '<' * l.C(l.S(seps))
              + l.Cc 'MR' * l.C(l.S(seps)) * l.P '>',
        Nl    = l.Cc 'NL' * l.C(l.P '\r\n' + l.S '\r\n'),
        Text  = l.Cc 'TX' * l.C((1 - l.V 'Nl' - l.V 'Mark')^1),
        Raw   = l.Cc 'RX' * l.C(l.P '%' * l.P(1)),
    }
    local results = parser:match(script)
    return results
end

---@param script string
---@param seps string
---@return string
---@return table<string, Catched>
return function (script, seps)
    local tokens = parseTokens(script, seps)
    local newBuf = {}
    local result = {}
    local marks  = {}

    for s in seps:gmatch '.' do
        result[s] = catchedTable()
    end

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
        if mode == 'RX' then
            newBuf[#newBuf+1] = text:sub(2)
            skipOffset = skipOffset + 1
        end
        if mode == 'NL' then
            newBuf[#newBuf+1] = text
            line = line + 1
        end
        if mode == 'ML' then
            marks[#marks+1] = {
                char     = text,
                offset   = offset - skipOffset - 1,
            }
            skipOffset = skipOffset + 1 + #text
        end
        if mode == 'MR' then
            for j = #marks, 1, -1 do
                local mark = marks[j]
                if mark.char == text then
                    result[text][#result[text]+1] = { mark.offset, offset - skipOffset - 1 }
                    table.remove(marks, j)
                    break
                end
            end
            skipOffset = skipOffset + 1 + #text
        end
    end

    return table.concat(newBuf), result
end
