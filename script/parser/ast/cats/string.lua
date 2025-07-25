
---@class LuaParser.Node.CatString: LuaParser.Node.String
local CatString = Class('LuaParser.Node.CatString', 'LuaParser.Node.Base')

CatString.kind = 'catstring'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatString?
function Ast:parseCatString()
    -- cats中 不支持使用 ` 的字符串，这个格式保留给模板类型
    local quo = self.lexer:peek()
    if quo == '`' then
        return nil
    end
    return self:parseShortString('LuaParser.Node.CatString')
end
