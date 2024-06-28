local l     = require 'lpeglabel'

local Sp     = l.S' \t\v\f'
local Nl     = l.P'\r\n' + l.S'\r\n'
local Number = l.R'09'^1
local Word   = l.R('AZ', 'az', '__', '\x80\xff') * l.R('AZ', 'az', '09', '__', '\x80\xff')^0
local Symbol = l.P'=='
            +  l.P'~='
            +  l.P'--'
            -- non-standard:
            +  l.P'<<='
            +  l.P'>>='
            +  l.P'//='
            -- end non-standard
            +  l.P'<<'
            +  l.P'>>'
            +  l.P'<='
            +  l.P'>='
            +  l.P'//'
            +  l.P'...'
            +  l.P'..'
            +  l.P'::'
            -- non-standard:
            +  l.P'!='
            +  l.P'&&'
            +  l.P'||'
            +  l.P'/*'
            +  l.P'*/'
            +  l.P'+='
            +  l.P'-='
            +  l.P'*='
            +  l.P'%='
            +  l.P'&='
            +  l.P'|='
            +  l.P'^='
            +  l.P'/='
            -- end non-standard
            -- singles
            +  l.S'+-*/!#%^&()={}[]|\\\'":;<>,.?~`'
local Unknown = (1 - Number - Word - Symbol - Sp - Nl)^1
local Token   = l.Cp() * l.C(
      Nl      * l.Cc 'NL'
    + Number  * l.Cc 'Num'
    + Word    * l.Cc 'Word'
    + Symbol  * l.Cc 'Symbol'
    + Unknown * l.Cc 'Unknown'
)

local Parser  = l.Ct((Sp^1 + Token)^0)

---@alias LuaParser.Lexer.Type
---| 'NL'
---| 'Num'
---| 'Word'
---| 'Symbol'
---| 'Unknown'

---@class Lexer
---@overload fun(code: string, mode: 'Lua' | 'Cat'): Lexer
local M = Class 'Lexer'

---@param code string
---@param mode 'Lua' | 'Cat'
function M:__init(code, mode)
    local results = Parser:match(code)
    self.len = #code -- 总长度
    ---@type string[]
    self.tokens = {} -- 分离出来的词
    ---@type integer[]
    self.poses  = {} -- 每个词的字节开始位置（光标位置，第一个字符为0）
    ---@type LuaParser.Lexer.Type[]
    self.types  = {} -- 每个词的类型
    ---@type integer[]
    self.nls    = {} -- 每个换行符的字节结束位置（下一行的开始位置）
    self.ci     = 1  -- 当前词的索引
    for i, res in ipairs(results) do
        if i % 3 == 1 then
            self.poses[#self.poses+1] = res - 1
        elseif i % 3 == 2 then
            self.tokens[#self.tokens+1] = res
        elseif i % 3 == 0 then
            self.types[#self.types+1] = res
            if res == 'NL' then
                self.nls[#self.nls+1] = results[i-2] + #results[i-1] - 1
            end
        end
    end
end

-- 看看当前的词
---@param next? integer # 默认为0表示当前的词，1表示下一个词，以此类推
---@return string?
---@return LuaParser.Lexer.Type?
---@return integer?
function M:peek(next)
    local i = self.ci + (next or 0)
    local token = self.tokens[i]
    local tp    = self.types[i]
    local pos   = self.poses[i]
    return token, tp, pos
end

-- 消耗一个词，返回这个词
---@param count? integer # 默认为1表示消耗一个词，2表示消耗两个词，以此类推
---@return string?
---@return LuaParser.Lexer.Type?
---@return integer?
function M:next(count)
    local i = self.ci + (count or 1)
    local token = self.tokens[i]
    local tp    = self.types[i]
    local pos   = self.poses[i]
    self.ci = i
    return token, tp, pos
end

-- 消耗一个指定的词，返回消耗掉词的位置
---@param token string
---@return integer?
function M:consume(token)
    local ci = self.ci
    if self.tokens[ci] == token then
        self.ci = ci + 1
        return self.poses[ci]
    end
    return nil
end

-- 消耗一个指定的类型，返回消耗掉词和位置
---@param tp LuaParser.Lexer.Type
---@return string?
---@return integer?
function M:consumeType(tp)
    local ci = self.ci
    if self.types[ci] == tp then
        self.ci = ci + 1
        return self.tokens[ci], self.poses[ci]
    end
    return nil, nil
end

-- 获取当前词的2侧光标位置
---@param offset? integer # 偏移量，默认为0
---@return integer?
---@return integer?
function M:range(offset)
    local i = self.ci + (offset or 0)
    local token = self.tokens[i]
    local pos   = self.poses[i]
    if not token then
        return nil, nil
    end
    return pos, pos + #token
end

-- 快进到某个光标位置
---@param pos integer
function M:fastForward(pos)
    for i = self.ci + 1, #self.poses do
        if self.poses[i] >= pos then
            self.ci = i
            return
        end
    end
    self.ci = #self.poses + 1
end

-- 根据偏移量获取行列
---@param offset integer
---@return integer row # 第一行是0
---@return integer col # 第一列是0
function M:rowcol(offset)
    local nls = self.nls

    if #nls == 0 then
        return 0, offset
    end

    if offset < nls[1] then
        return 0, offset
    end

    if offset >= nls[#nls] then
        return #nls, offset - nls[#nls]
    end

    -- 使用二分法查找
    local low, high = 1, #nls
    while low <= high do
        local mid = (low + high) // 2
        if offset < nls[mid] then
            high = mid - 1
        elseif offset >= nls[mid+1] then
            low = mid + 1
        else
            return mid, offset - nls[mid]
        end
    end

    return 0, offset
end

-- 设置保存点
---@return fun()
function M:savePoint()
    local ci = self.ci
    return function ()
        self.ci = ci
    end
end

local API = {}

-- 对Lua代码进行分词
---@param code string
---@return Lexer
function API.parseLua(code)
    local lexer = New 'Lexer' (code, 'Lua')
    return lexer
end

return API
