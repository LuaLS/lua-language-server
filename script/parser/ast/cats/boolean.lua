
---@class LuaParser.Node.CatBoolean: LuaParser.Node.Base
---@field value boolean
local CatBoolean = Class('LuaParser.Node.CatBoolean', 'LuaParser.Node.Base')

CatBoolean.kind = 'catboolean'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatBoolean?
function Ast:parseCatBoolean()
    local token, _, pos = self.lexer:peek()
    if token ~= 'true' and token ~= 'false' then
        return nil
    end

    self.lexer:next()

    local value = self:createNode('LuaParser.Node.CatBoolean', {
        value  = token == 'true' and true or false,
        start  = pos,
        finish = pos + #token,
    })

    return value
end
