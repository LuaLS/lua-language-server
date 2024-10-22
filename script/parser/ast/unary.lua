
---@enum(key) LuaParser.UnarySymbol
local UnarySymbol = {
    ['not'] = 11,
    ['#']   = 11,
    ['~']   = 11,
    ['-']   = 11,
    -- unstandard
    ['!']   = 11,
}

local UnaryAlias = {
    ['!'] = 'not',
}

---@class LuaParser.Node.Unary: LuaParser.Node.Base
---@field op LuaParser.UnarySymbol
---@field exp? LuaParser.Node.Exp
local Unary = Class('LuaParser.Node.Unary', 'LuaParser.Node.Base')

Unary.kind = 'unary'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Unary?
---@return integer? opLevel
function Ast:parseUnary()
    local token, _, pos = self.lexer:peek()
    if not UnarySymbol[token] then
        return nil
    end
    ---@cast pos -?

    if token == '-' then
        local savePoint = self.lexer:savePoint()
        self.lexer:next()
        self:skipSpace()
        local nextToken, nextType = self.lexer:peek()
        if nextToken == '.'
        or nextType == 'Num' then
            -- 负数？
            savePoint()
            return nil
        end
    else
        self.lexer:next()
        self:skipSpace()
    end

    local op = token
    if UnaryAlias[op] then
        if not self.nssymbolMap[op] then
            self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + #op, {
                symbol = UnaryAlias[op]
            })
        end
        op = UnaryAlias[op]
    end

    if op == '~' then
        if self.versionNum < 53 then
            self:throw('UNSUPPORT_SYMBOL', pos, pos + #op)
        end
    end

    local myLevel = UnarySymbol[token]
    local exp = self:parseExp(true, false, myLevel)
    local unary = self:createNode('LuaParser.Node.Unary', {
        start   = pos,
        finish  = self:getLastPos(),
        op      = token,
        exp     = exp,
    })
    if exp then
        exp.parent = unary
    end

    return unary
end
