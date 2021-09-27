---@class lookForward
local m = {}

--- 是否是空白符
---@param inline boolean # 必须在同一行中（排除换行符）
function m.isSpace(char, inline)
    if inline then
        if char == ' '
        or char == '\t' then
            return true
        end
    else
        if char == ' '
        or char == '\n'
        or char == '\r'
        or char == '\t' then
            return true
        end
    end
    return false
end

--- 跳过空白符
---@param inline boolean # 必须在同一行中（排除换行符）
function m.skipSpace(text, offset, inline)
    for i = offset, 1, -1 do
        local char = text:sub(i, i)
        if not m.isSpace(char, inline) then
            return i
        end
    end
    return 0
end

function m.findWord(text, offset)
    for i = offset, 1, -1 do
        if not text:sub(i, i):match '[%w_]' then
            if i == offset then
                return nil
            end
            return text:sub(i+1, offset), i+1
        end
    end
    return text:sub(1, offset), 1
end

function m.findSymbol(text, offset)
    for i = offset, 1, -1 do
        local char = text:sub(i, i)
        if m.isSpace(char) then
            goto CONTINUE
        end
        if char == '.'
        or char == ':'
        or char == '('
        or char == ','
        or char == '=' then
            return char, i
        else
            return nil
        end
        ::CONTINUE::
    end
    return nil
end

function m.findTargetSymbol(text, offset, symbol)
    offset = m.skipSpace(text, offset)
    for i = offset, 1, -1 do
        local char = text:sub(i - #symbol + 1, i)
        if char == symbol then
            return i - #symbol + 1
        else
            return nil
        end
    end
    return nil
end

function m.findAnyOffset(text, offset)
    for i = offset, 1, -1 do
        if not m.isSpace(text:sub(i, i)) then
            return i
        end
    end
    return nil
end

return m
