---@class LuaParser.Node.CatAlias: LuaParser.Node.Base, LuaParser.Node.CatGenericMaster, LuaParser.Node.Block
---@field aliasID LuaParser.Node.CatID
---@field extends? LuaParser.Node.CatExp
local CatAlias = Class('LuaParser.Node.CatAlias', 'LuaParser.Node.Base')

Extends('LuaParser.Node.CatAlias', 'LuaParser.Node.CatGenericMaster')
Extends('LuaParser.Node.CatAlias', 'LuaParser.Node.Block')

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

    self:blockStart(catAlias)
    self:parseCatGenericDef(catAlias, catAlias)

    self:skipSpace()
    local extends = self:parseCatExp(true)
    if extends then
        catAlias.extends = extends
        extends.parent = catAlias
    end

    catAlias.finish = self:getLastPos()
    self:blockFinish(catAlias)

    return catAlias
end
