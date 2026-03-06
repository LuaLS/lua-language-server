---@class Feature.TextScanner
---@field text string
---@field offset integer # 当前光标位置（1-based，指向光标右侧第一个字符）
local M = Class 'Feature.TextScanner'

---@param text string
---@param offset integer # 光标偏移量（1-based）
function M:__init(text, offset)
    self.text   = text
    self.offset = offset
end

--- 向前扫描（往左），跳过满足 predicate 的字符，返回跳过的字符串。
---@param predicate fun(ch: string): boolean
---@return string
function M:scanBack(predicate)
    local pos = self.offset - 1
    local start = pos
    while pos >= 1 do
        local ch = self.text:sub(pos, pos)
        if not predicate(ch) then
            break
        end
        pos = pos - 1
    end
    if pos == start then
        return ''
    end
    self.offset = pos + 1
    return self.text:sub(pos + 1, start)
end

--- 向前看（往左）N 个字符，不移动 offset。
---@param n integer
---@return string
function M:peekBack(n)
    local pos = self.offset - 1
    return self.text:sub(math.max(1, pos - n + 1), pos)
end

--- 返回光标前紧邻的单个字符，不移动 offset。
---@return string
function M:peekBackChar()
    return self.text:sub(self.offset - 1, self.offset - 1)
end

--- 判断一个字符是否是 Lua 标识符字符（字母、数字、下划线）。
---@param ch string
---@return boolean
function M.isIdentChar(ch)
    return ch == '_'
        or (ch >= 'a' and ch <= 'z')
        or (ch >= 'A' and ch <= 'Z')
        or (ch >= '0' and ch <= '9')
end

--- 向前扫描出光标前的 Lua 标识符单词（即正在输入的前缀）。
--- 不移动 scanner 的 offset。
---@return string word    # 当前正在输入的单词前缀（可能为空字符串）
---@return integer start  # 单词起始位置（1-based offset）
function M:getWordBack()
    local pos = self.offset - 1
    while pos >= 1 and M.isIdentChar(self.text:sub(pos, pos)) do
        pos = pos - 1
    end
    local wordStart = pos + 1
    return self.text:sub(wordStart, self.offset - 1), wordStart
end

return M
