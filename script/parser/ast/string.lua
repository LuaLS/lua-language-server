
---@alias LuaParser.EscMode 'normal' | 'unicode' | 'err' | 'byte'

---@class LuaParser.Node.String: LuaParser.Node.Literal
---@field value string
---@field quo string
---@field escs? table
---@field missQuo? true
local String = Class('LuaParser.Node.String', 'LuaParser.Node.Literal')

String.kind = 'string'

local escMap = {
    ['a']  = '\a',
    ['b']  = '\b',
    ['f']  = '\f',
    ['n']  = '\n',
    ['r']  = '\r',
    ['t']  = '\t',
    ['v']  = '\v',
    ['\\'] = '\\',
    ['\''] = '\'',
    ['\"'] = '\"',
}

---@param self LuaParser.Node.String
---@return string
---@return true
String.__getter.value = function (self)
    if self.quo == "'"
    or self.quo == '"' then
        error('短字符串应该在解析时求值！')
    else
        local raw
        if self.missQuo then
            raw = self.ast.code:sub(self.start + #self.quo + 1, self.finish - 1)
        else
            raw = self.ast.code:sub(self.start + #self.quo + 1, self.finish - #self.quo)
        end
        local value = raw
            : gsub('\r\n', '\n')
            : gsub('\r', '\n')
            : gsub('^\n', '')
        return value, true
    end
end

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

-- 解析字符串
---@private
---@return LuaParser.Node.String?
function Ast:parseString()
    local token = self.lexer:peek()
    if token == '"'
    or token == "'"
    or token == '`' then
        return self:parseShortString('LuaParser.Node.String')
    end
    if token == '[' then
        return self:parseLongString()
    end
    return nil
end

-- 解析短字符串
---@private
---@generic T
---@param stringType `T`
---@return T?
function Ast:parseShortString(stringType)
    local quo, _, pos = self.lexer:peek()
    if quo ~= '"' and quo ~= "'" and quo ~= '`' then
        return nil
    end
    ---@cast quo -?
    ---@cast pos -?

    if quo == '`' and not self.nssymbolMap['`'] then
        self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + 1, {
            symbol = '"'
        })
    end

    local pieces = {}
    local escs

    ---@param mode LuaParser.EscMode
    ---@param start integer
    ---@param finish integer
    local function pushEsc(mode, start, finish)
        if not escs then
            escs = {}
        end

        local i = #escs
        escs[i+1] = start
        escs[i+2] = finish
        escs[i+3] = mode
    end

    local curOffset = pos + 2
    while true do
        local char, offset = self.code:match('([\\\r\n\'"`])()', curOffset)
        if char == quo then
            pieces[#pieces+1] = self.code:sub(curOffset, offset - 2)
            curOffset = offset
            break
        end
        if not char then
            pieces[#pieces+1] = self.code:sub(curOffset)
            curOffset = #self.code + 1
            self:throwMissSymbol(curOffset - 1, quo)
            break
        end
        if char == '\r'
        or char == '\n' then
            pieces[#pieces+1] = self.code:sub(curOffset, offset - 2)
            curOffset = offset - 1
            self:throwMissSymbol(curOffset - 1, quo)
            break
        end
        if char == '\\' then
            pieces[#pieces+1] = self.code:sub(curOffset, offset - 2)
            self.lexer:fastForward(offset - 1)
            local curToken, curType, curPos = self.lexer:peek()
            if not curToken then
                pushEsc('err', offset - 2, offset - 1)
                curOffset = offset
                goto continue
            end
            ---@cast curPos -?
            if curType == 'NL' and curPos == offset - 1 then
                pushEsc('normal', offset - 2, offset - 1)
                curOffset = curPos + #curToken + 1
                pieces[#pieces+1] = '\n'
                goto continue
            end
            if curType == 'Num' and curPos == offset - 1 then
                local numWord = curToken:sub(1, 3)
                curOffset = offset + #numWord
                local num = math.tointeger(numWord)
                if num and num >= 0 and num <= 255 then
                    pushEsc('byte', offset - 2, offset - 1 + #numWord)
                    pieces[#pieces+1] = string.char(num)
                else
                    pushEsc('err', offset - 2, offset - 1 + #numWord)
                    self:throw('ERR_ESC_DEC', curPos, curPos + #numWord, {
                        min = '000',
                        max = '255',
                    })
                end
                goto continue
            end
            local escChar = self.code:sub(offset, offset)
            if escChar == 'z' then
                pushEsc('normal', offset - 2, offset)
                self.lexer:fastForward(offset)
                repeat until not self.lexer:consumeType 'NL'
                local _, _, afterPos = self.lexer:peek()
                curOffset = afterPos and (afterPos + 1) or (#self.code + 1)
                goto continue
            end
            if escChar == 'x' then
                local code = self.code:match('^%x%x', offset + 1)
                if code then
                    pushEsc('byte', offset - 2, offset + 2)
                    curOffset = offset + 3
                    local num = tonumber(code, 16)
                    pieces[#pieces+1] = string.char(num)
                else
                    pushEsc('err', offset - 2, offset)
                    self:throw('MISS_ESC_X', offset, offset)
                    curOffset = offset + 1
                end
                if self.versionNum <= 51 then
                    self:throw('ERR_ESC', curPos - 1, curPos + 3)
                end
                goto continue
            end
            if escChar == 'u' then
                local leftP, word, rightP, tailOffset = self.code:match('^({)(%w*)(}?)()', offset + 1)
                if not leftP then
                    pushEsc('err', offset - 2, offset)
                    self:throwMissSymbol(offset, '{')
                    curOffset = offset
                    goto continue
                end
                pushEsc('unicode', offset - 2, tailOffset - 1)
                if self.versionNum <= 52 then
                    self:throw('ERR_ESC', offset - 2, tailOffset - 1)
                else
                    if #word == 0 then
                        self:throw('UTF8_SMALL', offset + 1, offset + 1)
                    else
                        local num = tonumber(word, 16)
                        if num then
                            if self.versionNum >= 54 then
                                if num < 0 or num > 0x7FFFFFFF then
                                    self:throw('UTF8_MAX', offset + 1, offset + #word + 1, {
                                        min = '00000000',
                                        max = '7FFFFFFF',
                                    })
                                end
                            else
                                self:throw('UTF8_MAX', offset + 1, offset + #word + 1, {
                                    min     = '000000',
                                    max     = '10FFFF',
                                    needVer = num <= 0x7FFFFFFF and 'Lua 5.4' or nil,
                                })
                            end
                            if num >= 0 and num <= 0x7FFFFFFF then
                                pieces[#pieces+1] = utf8.char(num)
                            end
                        else
                            self:throw('MUST_X16', offset + 1, offset + #word + 1)
                        end
                    end
                end
                if rightP == '' then
                    self:throwMissSymbol(tailOffset - 1, '}')
                end
                curOffset = tailOffset
                goto continue
            end
            if escMap[escChar] then
                pushEsc('normal', offset - 2, offset)
                curOffset = offset + 1
                pieces[#pieces+1] = escMap[escChar]
                goto continue
            else
                pushEsc('err', offset - 2, offset)
                curOffset = offset + 1
                self:throw('ERR_ESC', offset - 2, offset)
                goto continue
            end
            goto continue
        end
        pieces[#pieces+1] = self.code:sub(curOffset, offset - 1)
        curOffset = offset
        ::continue::
    end

    local finishPos = curOffset - 1
    self.lexer:fastForward(finishPos)
    if quo == '`' then
        quo = '"'
    end

    return self:createNode(stringType, {
        start   = pos,
        finish  = finishPos,
        quo     = quo,
        value   = table.concat(pieces),
        escs    = escs,
    })
end

-- 解析长字符串
---@private
---@return LuaParser.Node.String?
function Ast:parseLongString()
    local _, _, pos = self.lexer:peek()
    local quo = self.code:match('^(%[=*%[)', pos + 1)
    if not quo then
        return nil
    end

    local missQuo
    local finishQuo = quo:gsub('%[', ']')
    local finishPos
    local finishOffset = self.code:find(finishQuo, pos + #quo + 1, true)
    if finishOffset then
        finishPos = finishOffset + #finishQuo - 1
    else
        finishPos = #self.code
        missQuo = true
        self:throwMissSymbol(finishPos, finishQuo)
    end

    if quo == '[[' and self.versionNum <= 51 then
        local nestOffset = self.code:find('[[', pos + #quo + 1, true)
        if nestOffset and nestOffset < finishOffset then
            self:throw('NESTING_LONG_MARK', nestOffset - 1, nestOffset + 1)
        end
    end

    self.lexer:fastForward(finishPos)

    return self:createNode('LuaParser.Node.String', {
        start   = pos,
        finish  = finishPos,
        quo     = quo,
        missQuo = missQuo,
    })
end
