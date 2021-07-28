local sfind = string.find
local ssub  = string.sub

---@param text string
return function (self, text)
    local current = 1
    local lines = {}
    local i = 1
    while true do
        local pos = sfind(text,'[\r\n]', current)
        if not pos then
            break
        end
        local line = {
            start = current - 1,
            range = pos - 1,
        }
        lines[i] = line
        i = i + 1
        if ssub(text, pos, pos + 1) == '\r\n' then
            current     = pos + 2
            line.finish = pos + 1
        else
            current     = pos + 1
            line.finish = pos
        end
    end
    lines[i] = {
        start  = current - 1,
        finish = #text,
        range  = #text,
    }
    return lines
end
