local class = require 'class'

---@class LuaParser.Node.CatString: LuaParser.Node.String
local CatString = class.declare('LuaParser.Node.CatString', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatString?
function Ast:parseCatString()
    return self:parseShortString('LuaParser.Node.CatString')
end
