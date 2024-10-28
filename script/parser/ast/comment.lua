
---@class LuaParser.Node.Comment: LuaParser.Node.Base
---@field subtype 'short' | 'long'
---@field value string
local Comment = Class('LuaParser.Node.Comment', 'LuaParser.Node.Base')

Comment.kind = 'comment'

---@param self LuaParser.Node.Comment
---@return string
---@return true
Comment.__getter.value = function (self)
    if self.subtype == 'short' then
        return self.code:sub(3), true
    else
        if self.code:sub(1, 2) == '--' then
            local quo = self.code:match('^(%[=*%[)', 3)
            return self.code:sub(3 + #quo, - 1 - #quo), true
        else
            -- 格式为`/**/`
            return self.code:sub(3, -3), true
        end
    end
end

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param inExp? boolean
---@return LuaParser.Node.Comment?
function Ast:parseComment(inExp)
    return self:parseLongComment()
        or self:parseShortComment(inExp)
end

---@private
---@param inExp? boolean
---@param inBlock? boolean
---@return LuaParser.Node.Comment?
function Ast:parseShortComment(inExp, inBlock)
    local token, _, pos = self.lexer:peek()
    if not token then
        return nil
    end
    if inBlock and self.code:match('^%-[ \t]*()@(%a+)', pos + 3) then
        return nil
    end
    ---@cast pos -?
    if  token == '--'
    or (token == '//' and (not inExp or self.nssymbolMap['//'])) then
        if token == '//' and not self.nssymbolMap['//'] then
            self:throw('ERR_COMMENT_PREFIX', pos, pos + 2)
        end
        local offset = self.code:find('[\r\n]', pos + 2) or (#self.code + 1)
        self.lexer:fastForward(offset)
        return self:createNode('LuaParser.Node.Comment', {
            subtype = 'short',
            start   = pos,
            finish  = offset - 1,
        })
    end
    return nil
end

---@private
---@return LuaParser.Node.Comment?
function Ast:parseLongComment()
    local token, _, pos = self.lexer:peek()
    if not token then
        return nil
    end
    ---@cast pos -?
    local finishQuo
    if token == '--' then
        local quo = self.code:match('^(%[=*%[)', pos + 3)
        if not quo then
            return nil
        end
        finishQuo = quo:gsub('%[', ']')
    elseif token == '/*' then
        finishQuo = '*/'
        if not self.nssymbolMap['/**/'] then
            self:throw('ERR_C_LONG_COMMENT', pos, pos + 2)
        end
    else
        return nil
    end
    local offset = self.code:find(finishQuo, pos + 3, true)
    if offset then
        self.lexer:fastForward(offset + #finishQuo - 1)
    else
        self:throwMissSymbol(#self.code, finishQuo)
        self.lexer:fastForward(#self.code)
    end

    local finish = offset and (offset + #finishQuo - 1) or #self.code

    return self:createNode('LuaParser.Node.Comment', {
        subtype = 'long',
        start   = pos,
        finish  = finish,
    })
end
