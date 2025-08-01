
---@class LuaParser.Node.ParenBase: LuaParser.Node.Base
local ParenBase = Class('LuaParser.Node.ParenBase', 'LuaParser.Node.Base')

ParenBase.kind = 'parenbase'

function ParenBase.__getter.asNumber(self)
    return self.exp.asNumber, true
end

function ParenBase.__getter.asString(self)
    return self.exp.asString, true
end

function ParenBase.__getter.asBoolean(self)
    return self.exp.asBoolean, true
end

function ParenBase.__getter.asInteger(self)
    return self.exp.asInteger, true
end

function ParenBase.__getter.toNumber(self)
    return self.exp.toNumber, true
end

function ParenBase.__getter.toString(self)
    return self.exp.toString, true
end

function ParenBase.__getter.toInteger(self)
    return self.exp.toInteger, true
end

function ParenBase.__getter.isTruly(self)
    return self.exp.isTruly, true
end

---@class LuaParser.Node.Paren: LuaParser.Node.ParenBase
---@field exp? LuaParser.Node.Exp
---@field next? LuaParser.Node.Field
local Paren = Class('LuaParser.Node.Paren', 'LuaParser.Node.ParenBase')

Paren.kind = 'paren'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@alias LuaParser.Node.Exp
---| LuaParser.Node.Term
---| LuaParser.Node.Unary
---| LuaParser.Node.Binary
---| LuaParser.Node.Select

-- 解析表达式
---@private
---@param required? boolean
---@param curLevel? integer # 新表达式的符号优先级必须比这个大
---@param asState? boolean # 是否作为语句解析
---@return LuaParser.Node.Exp?
function Ast:parseExp(required, asState, curLevel)
    local curExp

    local unary, unaryLevel = self:parseUnary()
    if unary then
        curExp = unary
        curLevel = unaryLevel
    else
        curExp = self:parseTerm()
        if not curExp then
            if required then
                self:throw('MISS_EXP', self:getLastPos(), self:getLastPos())
            end
            return nil
        end
        self:skipSpace(true)
    end

    while true do
        local binary = self:parseBinary(curExp, curLevel, asState)
        if not binary then
            break
        end
        curExp = binary
    end

    return curExp
end

-- 解析表达式列表，以逗号分隔
---@private
---@param atLeastOne? boolean
---@param greedy? boolean
---@return LuaParser.Node.Exp[]
function Ast:parseExpList(atLeastOne, greedy)
    return self:parseList(atLeastOne, greedy, self.parseExp)
end

---@alias LuaParser.Node.Term
---| LuaParser.Node.TermHead
---| LuaParser.Node.TermChain

---@alias LuaParser.Node.TermHead
---| LuaParser.Node.Literal
---| LuaParser.Node.Var
---| LuaParser.Node.Paren
---| LuaParser.Node.Varargs
---| LuaParser.Node.Table
---| LuaParser.Node.Function

---@alias LuaParser.Node.TermChain
---| LuaParser.Node.Field
---| LuaParser.Node.Call

-- 解析表达式中的一项
---@private
---@return LuaParser.Node.Term?
function Ast:parseTerm()
    ---@type LuaParser.Node.TermHead?
    local head = self:parseNil()
            or   self:parseBoolean()
            or   self:parseNumber()
            or   self:parseString()
            or   self:parseVarargs()
            or   self:parseFunction()
            or   self:parseVar()
            or   self:parseParen()
            or   self:parseTable()

    if not head then
        return nil
    end

    if head.kind == 'function' then
        if head.name then
            self:throw('UNEXPECT_EFUNC_NAME', head.name.start, head.name.finish)
        end
    end

    ---@type LuaParser.Node.Term
    local current = head

    while true do
        self:skipSpace(true)

        local chain = self:parseField(current)
                or    self:parseCall(current)

        if  current.kind == 'field'
        and current.subtype == 'method' then
            if not chain or chain.kind ~= 'call' then
                self:throwMissSymbol(current.finish, '(')
            end
        end

        if chain then
            if chain.kind == 'call' and self.versionNum <= 51 then
                if current.finishRow ~= self.lexer:rowcol(chain.argPos) then
                    self:throw('AMBIGUOUS_SYNTAX', chain.argPos, chain.finish)
                end
            end

            if current.isLiteral or current.kind == 'table' then
                self:throw('NEED_PAREN', current.start, current.finish)
            end

            current = chain
        else
            break
        end
    end

    return current
end

---@private
---@return LuaParser.Node.Paren?
function Ast:parseParen()
    local pos = self.lexer:consume '('
    if not pos then
        return nil
    end
    local exp = self:parseExp(true)
    local paren = self:createNode('LuaParser.Node.Paren', {
        start  = pos,
    })
    if exp then
        paren.exp = self:convertToSelect(exp, 1) or exp
        exp.parent = paren
    end
    self:skipSpace()
    self:assertSymbol ')'
    paren.finish = self:getLastPos()

    return paren
end
