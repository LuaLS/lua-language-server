local class = require 'class'

---@class LuaParser.Node.CatClass: LuaParser.Node.Base
---@field classID LuaParser.Node.CatID
---@field symbolPos? integer # :的位置
---@field extends? LuaParser.Node.CatType
local CatClass = class.declare('LuaParser.Node.CatClass', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

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
        local extends = self:parseCatType(true)
        if extends then
            catClass.extends = extends
            extends.parent = catClass
        end
    end

    catClass.finish = self:getLastPos()

    return catClass
end
