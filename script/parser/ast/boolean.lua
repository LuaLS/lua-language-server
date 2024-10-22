
---@class LuaParser.Node.Boolean: LuaParser.Node.Literal
---@field value boolean
local Boolean = Class('LuaParser.Node.Boolean', 'LuaParser.Node.Literal')

Boolean.kind = 'boolean'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

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
