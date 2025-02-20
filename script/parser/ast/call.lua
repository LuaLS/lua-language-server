
---@class LuaParser.Node.Call: LuaParser.Node.Base
---@field node LuaParser.Node.Term
---@field argPos integer
---@field args LuaParser.Node.Exp[]
local Call = Class('LuaParser.Node.Call', 'LuaParser.Node.Base')

Call.kind = 'call'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param last LuaParser.Node.Term
---@return LuaParser.Node.Call?
function Ast:parseCall(last)
    local token, _, pos = self.lexer:peek()
    if token == '(' then
        if last.isLiteral or last.kind == 'table' then
            return nil
        end
        self.lexer:next()
        local exps = self:parseExpList(false, true)
        self:assertSymbol ')'
        local call = self:createNode('LuaParser.Node.Call', {
            start   = last.start,
            finish  = self:getLastPos(),
            node    = last,
            args    = exps,
            argPos  = pos,
        })
        last.parent = call
        for i = 1, #exps do
            exps[i].parent = call
        end
        return call
    end

    local literalArg = self:parseString()
                    or self:parseTable()
    if literalArg then
        local call = self:createNode('LuaParser.Node.Call', {
            start   = last.start,
            finish  = self:getLastPos(),
            node    = last,
            args    = { literalArg },
            argPos  = literalArg.start,
        })
        last.parent = call
        literalArg.parent = call
        return call
    end

    return nil
end
