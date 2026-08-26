
---@class LuaParser.Node.Call: LuaParser.Node.Base
---@field safe? boolean # 是否为可选链调用（?(）
---@field node LuaParser.Node.Term
---@field argPos integer
---@field args LuaParser.Node.Exp[]
---@field next? LuaParser.Node.Field
local Call = Class('LuaParser.Node.Call', 'LuaParser.Node.Base')

Call.kind = 'call'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param last LuaParser.Node.Term
---@return LuaParser.Node.Call?
function Ast:parseCall(last)
    local token, _, pos = self.lexer:peek()
    ---@cast pos -?

    -- 可选链：?(（无点号安全调用，? 后紧跟 (）
    if token == '?' then
        local nextToken, _, nextPos = self.lexer:peek(1)
        if nextToken == '('
        and nextPos == pos + 1 then
            if not self.nssymbolMap['?('] then
                self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + 2, {
                    symbol = '?(',
                })
            end
            if last.isLiteral or last.kind == 'table' then
                return nil
            end
            self.lexer:next()
            self.lexer:next()
            self:skipSpace()
            local exps = self:parseExpList(false, true)
            self:assertSymbol ')'
            local call = self:createNode('LuaParser.Node.Call', {
                start   = last.start,
                finish  = self:getLastPos(),
                safe    = true,
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
    end

    if token == '(' then
        if last.isLiteral or last.kind == 'table' then
            return nil
        end
        self.lexer:next()
        self:skipSpace()
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
