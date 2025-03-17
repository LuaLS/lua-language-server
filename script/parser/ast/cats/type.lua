---@class LuaParser.Node.CatType: LuaParser.Node.Base
---@field exp LuaParser.Node.CatExp
local CatType = Class('LuaParser.Node.CatType', 'LuaParser.Node.Base')

CatType.kind = 'cattype'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatType?
function Ast:parseCatType()
    local exp = self:parseCatExp(true)
    if not exp then
        return nil
    end

    local catType = self:createNode('LuaParser.Node.CatType', {
        exp = exp,
        start = exp.start,
    })

    exp.parent = catType

    catType.finish = self:getLastPos()

    return catType
end
