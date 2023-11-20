local class = require 'class'

---@class LuaParser.Node.Return: LuaParser.Node.Base
---@field exps LuaParser.Node.Exp[]
local Return = class.declare('LuaParser.Node.Return', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Return?
function Ast:parseReturn()
    local pos = self.lexer:consume 'return'
    if not pos then
        return nil
    end

    local exps = self:parseExpList()

    local ret = self:createNode('LuaParser.Node.Return', {
        start  = pos,
        finish = self:getLastPos(),
        exps   = exps,
    })

    for i = 1, #exps do
        local exp = exps[i]
        exp.parent = ret
    end

    return ret
end
