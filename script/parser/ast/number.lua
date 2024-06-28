
---@alias LuaParser.Node.Number LuaParser.Node.Float | LuaParser.Node.Integer

---@class LuaParser.Node.Float: LuaParser.Node.Literal
---@field value number
---@field valuei? number # 虚数
---@field numBase 2 | 10 | 16
local Float = Class('LuaParser.Node.Float', 'LuaParser.Node.Literal')

Float.value = 0.0

---@param self LuaParser.Node.Float
---@return 2 | 10 | 16
---@return true
Float.__getter.numBase = function (self)
    local mark = self.code:sub(1, 2)
    if mark == '0b' or mark == '0B' then
        return 2, true
    elseif mark == '0x' or mark == '0X' then
        return 16, true
    else
        return 10, true
    end
end

---@param self LuaParser.Node.Float
---@return string
---@return true
Float.__getter.toString = function (self)
    local num = self.valuei or self.value
    local view = ('%.10f'):format(num):gsub('0+$', '')
    if view:sub(-1) == '.' then
        view = view .. '0'
    end
    if self.valuei then
        view = ('0+%si'):format(view)
    end
    return view, true
end

---@param self LuaParser.Node.Float
---@return number
---@return true
Float.__getter.asNumber = function (self)
    return self.value, true
end

---@param self LuaParser.Node.Float
---@return integer?
---@return true
Float.__getter.asInteger = function (self)
    return math.tointeger(self), true
end

---@class LuaParser.Node.Integer: LuaParser.Node.Literal
---@field value integer
---@field valuei? number # 虚数
---@field numBase 2 | 10 | 16
---@field intTail? 'LL' | 'ULL'
local Integer = Class('LuaParser.Node.Integer', 'LuaParser.Node.Literal')

Integer.value = 0

---@param self LuaParser.Node.Integer
---@return 2 | 10 | 16
---@return true
Integer.__getter.numBase = function (self)
    local mark = self.code:sub(1, 2)
    if mark == '0b' or mark == '0B' then
        return 2, true
    elseif mark == '0x' or mark == '0X' then
        return 16, true
    else
        return 10, true
    end
end

---@param self LuaParser.Node.Integer
---@return string
---@return true
Integer.__getter.toString = function (self)
    local view = tostring(self.valuei or self.value)
    if self.intTail then
        view = view .. self.intTail
    end
    if self.valuei then
        view = ('0+%si'):format(view)
    end
    return view, true
end

---@param self LuaParser.Node.Integer
---@return number
---@return true
Integer.__getter.asNumber = function (self)
    return self.value, true
end

---@param self LuaParser.Node.Integer
---@return integer?
---@return true
Integer.__getter.asInteger = function (self)
    return self.value, true
end

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

-- 解析数字（可以带负号）
---@private
---@return LuaParser.Node.Float | LuaParser.Node.Integer | nil
function Ast:parseNumber()
    -- 快速判断是否为数字
    if self.lexer:peek() == '-' then
        local token, tp = self.lexer:peek(1)
        if token ~= '.' and tp ~= 'Num' then
            return
        end
    else
        local token, tp = self.lexer:peek()
        if token ~= '.' and tp ~= 'Num' then
            return
        end
    end

    local start = self.lexer:range()
    local neg = self.lexer:consume '-'

    local node = self:parseNumber16()
            or   self:parseNumber2()
            or   self:parseNumber10()
    if not node then
        return nil
    end

    ---@cast start -?

    node.start = start
    if neg then
        node.value = - node.value
        if node.valuei then
            node.valuei = - node.valuei
        end
    end

    return node
end

---@private
---@param curOffset integer
function Ast:fastForwardNumber(curOffset)
    local word = self.code:match('^[%.%w_\x80-\xff]+', curOffset)
    if not word then
        self.lexer:fastForward(curOffset - 1)
        return
    end
    self:throw('MALFORMED_NUMBER', curOffset - 1, curOffset - 1 + #word)
    self.lexer:fastForward(curOffset - 1 + #word)
end

---@private
---@param curOffset integer
---@return boolean
function Ast:parseNumberI(curOffset)
    if self.code:find('^[iI]', curOffset) then
        return true
    end
    return false
end

---@private
---@param value number?
---@param startPos integer
---@param curOffset integer
---@return LuaParser.Node.Float
function Ast:buildFloat(value, startPos, curOffset)
    local valuei
    if self:parseNumberI(curOffset) then
        curOffset = curOffset + 1
        valuei = value
    end

    if not self.jit then
        if valuei then
            self:throw('UNSUPPORT_SYMBOL', curOffset - 2, curOffset - 1)
        end
    end

    self:fastForwardNumber(curOffset)
    return self:createNode('LuaParser.Node.Float', {
        start   = startPos,
        finish  = curOffset - 1,
        value   = valuei and 0.0 or value,
        valuei  = valuei,
    })
end

---@private
---@param value integer?
---@param startPos integer
---@param curOffset integer
---@return LuaParser.Node.Integer
function Ast:buildInteger(value, startPos, curOffset)
    local valuei, intTail
    if self:parseNumberI(curOffset) then
        curOffset = curOffset + 1
        valuei = value
    else
        if self.code:find('^[uU][lL][lL]', curOffset)
        or self.code:find('^[lL][lL][uU]', curOffset) then
            curOffset = curOffset + 3
            intTail = 'ULL'
        elseif self.code:find('^[lL][lL]', curOffset) then
            curOffset = curOffset + 2
            intTail = 'LL'
        end
    end

    if not self.jit then
        if valuei then
            self:throw('UNSUPPORT_SYMBOL', curOffset - 2, curOffset - 1)
        end
        if intTail then
            self:throw('UNSUPPORT_SYMBOL', curOffset - #intTail - 1, curOffset - 1)
        end
    end

    self:fastForwardNumber(curOffset)
    return self:createNode('LuaParser.Node.Integer', {
        start   = startPos,
        finish  = curOffset - 1,
        value   = valuei and 0 or value,
        valuei  = valuei,
        intTail = intTail,
    })
end

-- 解析十六进制数字（不支持负号）
---@private
---@return LuaParser.Node.Float | LuaParser.Node.Integer | nil
function Ast:parseNumber16()
    local token, _, pos = self.lexer:peek()

    if token ~= '0' then
        return nil
    end
    ---@cast pos -?
    if not self.code:match('^[xX]', pos + 2) then
        return
    end

    local curOffset = pos + 3

    local intPart, intOffset = self.code:match('^([%da-fA-F]+)()', curOffset)
    if intOffset then
        curOffset = intOffset
    end

    local numPart, numOffset = self.code:match('^%.([%da-fA-F]*)()', curOffset)
    if numOffset then
        curOffset = numOffset
    end

    local expPart, expOffset = self.code:match('^[pP][+-]?(%d*)()', curOffset)
    if expOffset then
        curOffset = expOffset
        if #expPart == 0 then
            self:throw('MISS_EXPONENT', curOffset - 1, curOffset - 1)
        end
    end

    if not intPart then
        if not numPart then
            self:throw('MUST_X16', pos + 2, pos + 2)
        end
        if numPart == '' then
            self:throw('MUST_X16', numOffset - 1, numOffset - 1)
        end
    end

    if numPart or expPart then
        local value = tonumber(self.code:sub(pos + 1, curOffset - 1))
        return self:buildFloat(value, pos, curOffset)
    else
        local value = math.tointeger(self.code:sub(pos + 1, curOffset - 1))
        return self:buildInteger(value, pos, curOffset)
    end
end

-- 解析二进制数字（不支持负号）
---@private
---@return LuaParser.Node.Integer | nil
function Ast:parseNumber2()
    local token, _, pos = self.lexer:peek()

    if token ~= '0' then
        return nil
    end
    ---@cast pos -?
    if not self.code:match('^[bB]', pos + 2) then
        return
    end

    local bins = self.code:match('^([01]*)', pos + 3)
    local curOffset = pos + 3 + #bins
    local value = tonumber(bins, 2)

    if not self.jit then
        self:throw('UNSUPPORT_SYMBOL', pos, curOffset - 1)
    end

    return self:buildInteger(value, pos, curOffset)
end

-- 解析十进制数字（不支持负号）
---@private
---@return LuaParser.Node.Float | LuaParser.Node.Integer | nil
function Ast:parseNumber10()
    local token, tp, pos = self.lexer:peek()
    if token ~= '.' and tp ~= 'Num' then
        return nil
    end
    ---@cast pos -?

    local curOffset = pos + 1

    local intPart, intOffset = self.code:match('^(%d+)()', curOffset)
    if intOffset then
        curOffset = intOffset
    end

    local numPart, numOffset = self.code:match('^%.(%d*)()', curOffset)
    if numOffset then
        curOffset = numOffset
    end

    local expPart, expOffset = self.code:match('^[eE][+-]?(%d*)()', curOffset)
    if expOffset then
        curOffset = expOffset
        if #expPart == 0 then
            self:throw('MISS_EXPONENT', curOffset - 1, curOffset - 1)
        end
    end

    if not intPart then
        if numPart == '' then
            self.lexer:next()
            self:throw('UNKNOWN_SYMBOL', pos, pos + 1)
            return nil
        end
    end

    if numPart or expPart then
        local value = tonumber(self.code:sub(pos + 1, curOffset - 1))
        return self:buildFloat(value, pos, curOffset)
    else
        local value = math.tointeger(self.code:sub(pos + 1, curOffset - 1))
        return self:buildInteger(value, pos, curOffset)
    end
end
