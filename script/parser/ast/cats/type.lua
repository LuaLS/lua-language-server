---@class LuaParser.Node.CatStateType: LuaParser.Node.Base
---@field exp LuaParser.Node.CatExp
local CatStateType = Class('LuaParser.Node.CatStateType', 'LuaParser.Node.Base')

CatStateType.kind = 'catstatetype'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateType?
function Ast:parseCatStateType()
    local exp = self:parseCatExp(true)
    if not exp then
        return nil
    end

    local catType = self:createNode('LuaParser.Node.CatStateType', {
        exp = exp,
        start = exp.start,
    })

    exp.parent = catType

    catType.finish = self:getLastPos()

    return catType
end
