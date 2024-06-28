
-- 符号的优先级
---@enum(key) LuaParser.BinarySymbol
local BinarySymbol = {
    ['or']  = 1,
    ['and'] = 2,
    ['<=']  = 3,
    ['>=']  = 3,
    ['<']   = 3,
    ['>']   = 3,
    ['~=']  = 3,
    ['==']  = 3,
    ['=']   = 3,
    ['|']   = 4,
    ['~']   = 5,
    ['&']   = 6,
    ['<<']  = 7,
    ['>>']  = 7,
    ['..']  = 8,
    ['+']   = 9,
    ['-']   = 9,
    ['*']   = 10,
    ['//']  = 10,
    ['/']   = 10,
    ['%']   = 10,
    ['^']   = 12,
    -- nonstandard
    ['&&']  = 2,
    ['||']  = 1,
    ['!=']  = 3,
}

local BinaryAlias = {
    ['&&'] = 'and',
    ['||'] = 'or',
    ['!='] = '~=',
}

-- 这些符号从右向左结合
local RevertConcat = {
    ['..'] = true,
    ['^']  = true,
}

---@class LuaParser.Node.Binary: LuaParser.Node.Base
---@field op LuaParser.BinarySymbol
---@field symbolPos integer
---@field exp1 LuaParser.Node.Exp
---@field exp2? LuaParser.Node.Exp
local Binary = Class('LuaParser.Node.Binary', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param curExp LuaParser.Node.Exp
---@param curLevel? integer
---@param asState? boolean # 是否作为语句解析
---@return LuaParser.Node.Binary?
---@return integer? opLevel
function Ast:parseBinary(curExp, curLevel, asState)
    local token, _, pos = self.lexer:peek()
    if not BinarySymbol[token] then
        return nil
    end
    ---@cast pos -?

    local op = token
    local myLevel = BinarySymbol[op]
    if curLevel then
        if myLevel < curLevel then
            return nil
        end
        if myLevel == curLevel and not RevertConcat[op] then
            return nil
        end
    end

    if op == '//' and self.nssymbolMap['//'] then
        -- 如果设置了 `//` 为非标准符号，那么就认为 `//` 是注释而不是整除
        return nil
    end
    if op == '=' then
        if asState then
            return nil
        end
        self:throw('ERR_EQ_AS_ASSIGN', pos, pos + #op)
        op = '=='
    end
    if BinaryAlias[op] then
        if not self.nssymbolMap[op] then
            self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + #op, {
                symbol = BinaryAlias[op]
            })
        end
        op = BinaryAlias[op]
    end
    if op == '//'
    or op == '<<'
    or op == '>>'
    or op == '~'
    or op == '&'
    or op == '|' then
        if self.versionNum < 53 then
            self:throw('UNSUPPORT_SYMBOL', pos, pos + #op)
        end
    end

    self.lexer:next()
    self:skipSpace()

    local exp2 = self:parseExp(true, false, myLevel)

    local binary = self:createNode('LuaParser.Node.Binary', {
        start     = curExp.start,
        finish    = self:getLastPos(),
        op        = op,
        exp1      = curExp,
        exp2      = exp2,
        symbolPos = pos,
    })
    curExp.parent = binary
    if exp2 then
        exp2.parent = binary
    end

    return binary, myLevel
end
