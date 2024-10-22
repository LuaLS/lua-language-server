
---@class LuaParser.Node.CatString: LuaParser.Node.String
local CatString = Class('LuaParser.Node.CatString', 'LuaParser.Node.Base')

CatString.kind = 'catstring'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatString?
function Ast:parseCatString()
    return self:parseShortString('LuaParser.Node.CatString')
end
