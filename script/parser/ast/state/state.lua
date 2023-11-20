local class = require 'class'

require 'parser.ast.state.local'
require 'parser.ast.state.function'
require 'parser.ast.state.label'
require 'parser.ast.state.do'
require 'parser.ast.state.if'
require 'parser.ast.state.return'
require 'parser.ast.state.for'
require 'parser.ast.state.while'
require 'parser.ast.state.repeat'
require 'parser.ast.state.break'

---@class LuaParser.Node.Assign: LuaParser.Node.Base
---@field symbolPos? integer # 等号的位置
---@field exps LuaParser.Node.Exp[]
---@field values LuaParser.Node.Var[]
local Assign = class.declare('LuaParser.Node.Assign', 'LuaParser.Node.Base')

---@class LuaParser.Node.SingleExp: LuaParser.Node.Base
---@field exp LuaParser.Node.Exp
local SingleExp = class.declare('LuaParser.Node.SingleExp', 'LuaParser.Node.Base')

---@class LuaParser.Node.Select
---@field index integer
local Select = class.declare('LuaParser.Node.Select', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@alias LuaParser.Node.State
---| LuaParser.Node.LocalDef
---| LuaParser.Node.StateStartWithExp
---| LuaParser.Node.Label
---| LuaParser.Node.Goto
---| LuaParser.Node.If
---| LuaParser.Node.Do
---| LuaParser.Node.Break
---| LuaParser.Node.Continue
---| LuaParser.Node.Return
---| LuaParser.Node.For
---| LuaParser.Node.While
---| LuaParser.Node.Repeat
---| LuaParser.Node.Function

---@private
Ast.stateParserMap = {}

-- 注册语句解析
---@private
---@param token string
---@param parser fun(self: LuaParser.Ast): LuaParser.Node.State?, boolean?
function Ast:registerStateParser(token, parser)
    self.stateParserMap[token] = parser
end

Ast:registerStateParser('local'   , Ast.parseLocal)
Ast:registerStateParser('if'      , Ast.parseIf)
Ast:registerStateParser('do'      , Ast.parseDo)
Ast:registerStateParser('break'   , Ast.parseBreak)
Ast:registerStateParser('return'  , Ast.parseReturn)
Ast:registerStateParser('for'     , Ast.parseFor)
Ast:registerStateParser('while'   , Ast.parseWhile)
Ast:registerStateParser('repeat'  , Ast.parseRepeat)
Ast:registerStateParser('continue', Ast.parseContinue)
Ast:registerStateParser('::'      , Ast.parseLabel)
Ast:registerStateParser('goto'    , function (ast)
    ---@class LuaParser.Ast
    local self = ast
    local state = self:parseGoto()
    if state then
        return state
    end
    return nil, true
end)
Ast:registerStateParser('function', function (ast)
    ---@class LuaParser.Ast
    local self = ast
    local func = self:parseFunction()
    if not func then
        self:throw('MISS_NAME', self:getLastPos())
        return nil
    end
    if not func.name then
        self:throw('MISS_NAME', func.symbolPos1)
    end
    return func
end)

---@private
---@return LuaParser.Node.State?
function Ast:parseState()
    local token = self.lexer:peek()

    local parser = self.stateParserMap[token]
    if parser then
        local state, dontConsumeToken = parser(self)
        if not dontConsumeToken then
            return state
        end
    end

    return self:parseStateStartWithExp()
end

---@alias LuaParser.Node.StateStartWithExp
---| LuaParser.Node.Call
---| LuaParser.Node.Assign
---| LuaParser.Node.SingleExp

---@private
---@return LuaParser.Node.StateStartWithExp?
function Ast:parseStateStartWithExp()
    local exp = self:parseExp(false, true)
    if not exp then
        return nil
    end

    if exp.type == 'Call' then
        ---@cast exp LuaParser.Node.Call
        return exp
    end

    if exp.type == 'Var'
    or exp.type == 'Field' then
        ---@cast exp LuaParser.Node.Field
        self:skipSpace()
        local assign = self:parseAssign(exp)
        if assign then
            return assign
        end
    end

    local state = self:createNode('LuaParser.Node.SingleExp', {
        start  = exp.start,
        finish = exp.finish,
        exp    = exp,
    })
    exp.parent = state

    if exp.type == 'Field' and exp.subtype == 'method' then
        -- 已经throw过"缺少 `(`""
    else
        self:throw('EXP_IN_ACTION', state.start, state.finish)
    end

    return state
end

---@private
---@param first LuaParser.Node.Field
---@return LuaParser.Node.Assign?
function Ast:parseAssign(first)
    local token = self.lexer:peek()
    if token ~= '=' and token ~= ',' then
        return nil
    end

    local exps = {}
    local assign = self:createNode('LuaParser.Node.Assign', {
        start  = first.start,
        exps   = exps,
    })

    exps[1] = first
    first.parent = assign
    while true do
        local comma = self.lexer:consume ','
        if not comma then
            break
        end
        self:skipSpace()
        local exp = self:parseExp(true, true)
        if not exp then
            break
        end
        exps[#exps+1] = exp
        self:skipSpace()
    end

    local eqPos = self:assertSymbol '='

    if eqPos then
        assign.symbolPos = eqPos
        self:skipSpace()
        local values = self:parseExpList(true)
        self:extendsAssignValues(values, #exps)
        assign.values = values

        for i = 1, #values do
            local value = values[i]
            value.parent = assign
            value.index  = i

            local exp = exps[i]
            if exp then
                exp.value = value
            end
        end
    end

    assign.finish = self:getLastPos()

    return assign
end

---@param values LuaParser.Node.Exp[]
---@param varCount integer
function Ast:extendsAssignValues(values, varCount)
    if #values >= varCount then
        return
    end
    local lastValue = values[#values]
    if not lastValue then
        return
    end
    if lastValue.type ~= 'Call' and lastValue.type ~= 'Varargs' then
        return
    end
    for i = #values + 1, varCount do
        local sel = self:createNode('LuaParser.Node.Select', {
            start  = lastValue.start,
            finish = lastValue.finish,
            value  = lastValue,
        })
        values[i] = sel
    end
end
