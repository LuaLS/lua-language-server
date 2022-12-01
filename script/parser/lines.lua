local sfind = string.find
local ssub  = string.sub

---@param text string
return function (text)
    local current = 1
    local lines = {}
    lines[0] = 1
    lines.size = #text
    local i = 0
    while true do
        local pos = sfind(text,'[\r\n]', current)
        if not pos then
            break
        end
        i = i + 1
        if ssub(text, pos, pos + 1) == '\r\n' then
            current = pos + 2
        else
            current = pos + 1
        end
        lines[i] = current
    end
    return lines
end
