---@class LuaParser.Node.CatStateClass: LuaParser.Node.Base, LuaParser.Node.CatGenericMaster
---@field classID LuaParser.Node.CatID
---@field symbolPos? integer # :的位置
---@field extends? LuaParser.Node.CatExp[]
local CatStateClass = Class('LuaParser.Node.CatStateClass', 'LuaParser.Node.Base')

Extends('LuaParser.Node.CatStateClass', 'LuaParser.Node.CatGenericMaster')

CatStateClass.kind = 'catstateclass'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateClass?
function Ast:parseCatStateClass()
    local classID = self:parseCatID()
    if not classID then
        return nil
    end

    local catClass = self:createNode('LuaParser.Node.CatStateClass', {
        classID = classID,
        start = classID.start,
    })

    classID.parent = catClass

    self:parseCatGenericDef(catClass, self.curBlock)

    self:skipSpace()
    local symbolPos = self.lexer:consume ':'
    if symbolPos then
        catClass.symbolPos = symbolPos
        catClass.extends = self:parseCatTypeList(true)
        for _, extend in ipairs(catClass.extends) do
            extend.parent = catClass
        end
    end

    catClass.finish = self:getLastPos()

    return catClass
end
