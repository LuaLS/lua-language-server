local class = require 'class'

---@class LuaParser.Node.Boolean: LuaParser.Node.Literal
---@field value boolean
local Boolean = class.declare('LuaParser.Node.Boolean', 'LuaParser.Node.Literal')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

-- 解析布尔值
---@private
---@return LuaParser.Node.Boolean?
function Ast:parseBoolean()
    local token = self.lexer:peek()
    if token == 'true' then
        local start, finish = self.lexer:range()
        self.lexer:next()
        return self:createNode('LuaParser.Node.Boolean', {
            start   = start,
            finish  = finish,
            value   = true,
        })
    end
    if token == 'false' then
        local start, finish = self.lexer:range()
        self.lexer:next()
        return self:createNode('LuaParser.Node.Boolean', {
            start   = start,
            finish  = finish,
            value   = false,
        })
    end
end
