---@class LuaParser.Node.CatStateGeneric: LuaParser.Node.Base, LuaParser.Node.CatGenericMaster
local CatStateGeneric = Class('LuaParser.Node.CatStateGeneric', 'LuaParser.Node.Base')

Extends('LuaParser.Node.CatStateGeneric', 'LuaParser.Node.CatGenericMaster')

CatStateGeneric.kind = 'catstategeneric'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateGeneric?
function Ast:parseCatStateGeneric()
    local catGeneric = self:createNode('LuaParser.Node.CatStateGeneric', {
        start = self:getLastPos(),
    })

    self:parseCatGenericDef(catGeneric, self.curBlock, true)

    catGeneric.finish = self:getLastPos()

    return catGeneric
end
