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

--- 检测光标前是否是一次字段访问（`.` 或 `:`），并返回触发字符和对象表达式右端的偏移量。
---
--- 算法：
---   1. 跳过光标前的标识符前缀（当前正在输入的字段名）
---   2. 检查其左侧字符是否为 `.` 或 `:`
---   3. 继续往左跳过空白，返回剩余位置（即对象表达式的末尾字符所在的 offset）
---
--- 返回值：
---   trigger  — '.' | ':' | nil（nil 表示不是字段访问）
---   objEnd   — 对象表达式末尾字符的位置（1-based，inclusive），可传给 findSources
---@return string|nil trigger  # '.' 或 ':'，不是字段访问则为 nil
---@return integer    objEnd   # 对象末尾字符在文本中的 1-based 位置
---@return string     word     # 字段名前缀（光标前正在输入的部分，可能为空字符串）
function M:getFieldTriggerBack()
    -- 1. 扫描光标前的标识符前缀（字段名前缀）
    local pos = self.offset - 1
    local wordStart = pos + 1
    while pos >= 1 and M.isIdentChar(self.text:sub(pos, pos)) do
        pos = pos - 1
    end
    -- pos 现在指向前缀左侧的字符

    -- 2. 检查触发字符
    --    情形A：触发符在前缀左侧（如 "t.ab<??>", pos 在 '.'）
    --    情形B：offset 本身就是触发符（如 "t.<??>", offset 指向 '.'，pos == offset-1 == 't'）
    local trigger = self.text:sub(pos, pos)
    if trigger ~= '.' and trigger ~= ':' then
        -- 情形B：检查 offset 位置本身是否是触发符
        trigger = self.text:sub(self.offset, self.offset)
        if trigger ~= '.' and trigger ~= ':' then
            return nil, 0, ''
        end
        -- offset 就是触发符，字段前缀为空，对象末尾在 offset-1 左侧（跳过空白）
        pos = self.offset - 1
        while pos >= 1 and (self.text:sub(pos, pos) == ' ' or self.text:sub(pos, pos) == '\t') do
            pos = pos - 1
        end
        if pos < 1 then
            return nil, 0, ''
        end
        return trigger, pos, ''
    end

    -- 情形A：pos 就是触发符，前缀是 [pos+1, offset-1]
    local word = self.text:sub(pos + 1, self.offset - 1)
    pos = pos - 1  -- 跳过触发符

    -- 3. 向左跳过空白，定位对象表达式的末尾字符
    while pos >= 1 and (self.text:sub(pos, pos) == ' ' or self.text:sub(pos, pos) == '\t') do
        pos = pos - 1
    end

    if pos < 1 then
        return nil, 0, ''
    end

    return trigger, pos, word
end

return M
