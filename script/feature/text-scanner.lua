---@class Feature.TextScanner
---@field text string
---@field offset integer # 当前光标边界位置（0-based 到 #text，表示光标左侧字符下标）
---
--- 光标边界语义示例（文本："a.b.c"）：
---   offset=0  -> 光标在最左侧：|a.b.c
---   offset=1  -> 光标在 a 与 . 之间：a|.b.c
---   offset=2  -> 光标在 . 与 b 之间：a.|b.c
---   offset=3  -> 光标在 b 与 . 之间：a.b|.c
---   offset=4  -> 光标在 . 与 c 之间：a.b.|c
---   offset=5  -> 光标在最右侧：a.b.c|
local M = Class 'Feature.TextScanner'

---@param text string
---@param offset integer # 光标边界位置（0..#text）
function M:__init(text, offset)
    self.text   = text
    self.offset = offset
end

--- 向前扫描（往左），跳过满足 predicate 的字符，返回跳过的字符串。
---@param predicate fun(ch: string): boolean
---@return string
function M:scanBack(predicate)
    local pos = self.offset
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
    local pos = self.offset
    return self.text:sub(math.max(1, pos - n + 1), pos)
end

--- 返回光标前紧邻的单个字符，不移动 offset。
---@return string
function M:peekBackChar()
    return self.text:sub(self.offset, self.offset)
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
---
--- 示例（"a.b.c"）：
---   offset=3 -> word="b"    （请求 a.b???? 的补全）
---   offset=4 -> word=""     （请求 a.b.???? 的补全）
function M:getWordBack()
    local pos = self.offset
    while pos >= 1 and M.isIdentChar(self.text:sub(pos, pos)) do
        pos = pos - 1
    end
    local wordStart = pos + 1
    return self.text:sub(wordStart, self.offset), wordStart
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
---
--- 示例（"a.b.c"）：
---   offset=3 -> 非字段触发（trigger=nil）
---   offset=4 -> 字段触发（trigger='.'，objEnd=3，word='')
---@return string|nil trigger  # '.' 或 ':'，不是字段访问则为 nil
---@return integer    objEnd   # 对象末尾字符在文本中的 1-based 位置
---@return string     word     # 字段名前缀（光标前正在输入的部分，可能为空字符串）
function M:getFieldTriggerBack()
    -- 1. 扫描光标前的标识符前缀（字段名前缀）
    local pos = self.offset
    local wordStart = pos + 1
    while pos >= 1 and M.isIdentChar(self.text:sub(pos, pos)) do
        pos = pos - 1
    end
    -- pos 现在指向前缀左侧的字符

    -- 2. 检查触发字符（支持触发符与 word 之间、触发符与对象之间有空白）
    --    情形A：触发符紧贴前缀左侧（如 "t.ab<??>", pos 在 '.'）
    --    情形B：word 为空，触发符左侧有空白（如 "t.   <??>", pos 在最后一个空格）
    local trigger = self.text:sub(pos, pos)
    if trigger ~= '.' and trigger ~= ':' then
        -- 跳过前缀左侧的空白，再检查触发符（情形B）
        local tryPos = pos
        while tryPos >= 1 and (self.text:sub(tryPos, tryPos) == ' ' or self.text:sub(tryPos, tryPos) == '\t') do
            tryPos = tryPos - 1
        end
        trigger = self.text:sub(tryPos, tryPos)
        if trigger == '.' or trigger == ':' then
            -- 情形B：触发符在空白左侧，word 为空
            local word = ''
            pos = tryPos - 1  -- 跳过触发符
            while pos >= 1 and (self.text:sub(pos, pos) == ' ' or self.text:sub(pos, pos) == '\t') do
                pos = pos - 1
            end
            if pos < 1 then
                return nil, 0, ''
            end
            return trigger, pos, word
        end
        return nil, 0, ''
    end

    -- 情形A：pos 就是触发符，前缀是 [pos+1, offset-1]
    local word = self.text:sub(pos + 1, self.offset)
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
