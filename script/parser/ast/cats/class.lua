---@class LuaParser.Node.CatClass: LuaParser.Node.Base
---@field classID LuaParser.Node.CatID
---@field symbolPos? integer # :的位置
---@field extends? LuaParser.Node.CatType[]
local CatClass = Class('LuaParser.Node.CatClass', 'LuaParser.Node.Base')

CatClass.kind = 'catclass'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatClass?
function Ast:parseCatClass()
    local classID = self:parseCatID()
    if not classID then
        return nil
    end

    local catClass = self:createNode('LuaParser.Node.CatClass', {
        classID = classID,
        start = classID.start,
    })

    classID.parent = catClass

    local symbolPos = self.lexer:consume ':'
    if symbolPos then
        catClass.symbolPos = symbolPos
        catClass.extends = self:parseList(true, true, self.parseCatType)
        for _, extend in ipairs(catClass.extends) do
            extend.parent = catClass
        end
    end

    catClass.finish = self:getLastPos()

    return catClass
end
