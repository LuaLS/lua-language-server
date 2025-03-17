---@class LuaParser.Node.CatAlias: LuaParser.Node.Base
---@field aliasID LuaParser.Node.CatID
---@field extends? LuaParser.Node.CatExp
local CatAlias = Class('LuaParser.Node.CatAlias', 'LuaParser.Node.Base')

CatAlias.kind = 'catalias'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatAlias?
function Ast:parseCatAlias()
    local aliasID = self:parseCatID()
    if not aliasID then
        return nil
    end

    local catAlias = self:createNode('LuaParser.Node.CatAlias', {
        aliasID = aliasID,
        start = aliasID.start,
    })

    aliasID.parent = catAlias

    local extends = self:parseCatExp(true)
    if extends then
        catAlias.extends = extends
        extends.parent = catAlias
    end

    catAlias.finish = self:getLastPos()

    return catAlias
end
