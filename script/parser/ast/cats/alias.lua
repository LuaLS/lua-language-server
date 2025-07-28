---@class LuaParser.Node.CatStateAlias: LuaParser.Node.Base, LuaParser.Node.CatGenericMaster, LuaParser.Node.Block
---@field aliasID LuaParser.Node.CatID
---@field extends? LuaParser.Node.CatExp
local CatStateAlias = Class('LuaParser.Node.CatStateAlias', 'LuaParser.Node.Base')

Extends('LuaParser.Node.CatStateAlias', 'LuaParser.Node.CatGenericMaster')
Extends('LuaParser.Node.CatStateAlias', 'LuaParser.Node.Block')

CatStateAlias.kind = 'catstatealias'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateAlias?
function Ast:parseCatStateAlias()
    local aliasID = self:parseCatID()
    if not aliasID then
        return nil
    end

    local catAlias = self:createNode('LuaParser.Node.CatStateAlias', {
        aliasID = aliasID,
        start = aliasID.start,
    })

    aliasID.parent = catAlias

    self:blockStart(catAlias)
    self:parseCatGenericDef(catAlias, catAlias)

    self:skipSpace()
    if self.lexer:consume '|' then
        self:skipSpace()
    end
    local extends = self:parseCatExp(true)
    if extends then
        catAlias.extends = extends
        extends.parent = catAlias
    end

    catAlias.finish = self:getLastPos()
    self:blockFinish(catAlias)

    return catAlias
end
