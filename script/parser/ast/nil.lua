
---@class LuaParser.Node.Nil: LuaParser.Node.Literal
local Nil = Class('LuaParser.Node.Nil', 'LuaParser.Node.Literal')

Nil.toString = 'nil'
Nil.isTruly = false

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

-- 解析 nil
---@private
---@return LuaParser.Node.Nil?
function Ast:parseNil()
    local token = self.lexer:peek()
    if token ~= 'nil' then
        return nil
    end
    local start, finish = self.lexer:range()
    self.lexer:next()
    return self:createNode('LuaParser.Node.Nil', {
        start   = start,
        finish  = finish,
    })
end
