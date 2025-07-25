---@class LuaParser.Node.CatGenericMaster: LuaParser.Node.Base
---@field typeParams? LuaParser.Node.CatGeneric[]
---@field genericPos1? integer # `<` 的位置
---@field genericPos2? integer # `>` 的位置
local M = Class('LuaParser.Node.CatGenericMaster', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatGeneric: LuaParser.Node.Base
---@field id LuaParser.Node.CatID
---@field extends? LuaParser.Node.CatExp
---@field symbolPos? integer # 冒号的位置
local CatGeneric = Class('LuaParser.Node.CatGeneric', 'LuaParser.Node.Base')

CatGeneric.kind = 'catgeneric'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatGeneric?
function Ast:parseCatGeneric()
    local id = self:parseID('LuaParser.Node.CatID', true, true)
    if not id then
        return nil
    end

    local generic = self:createNode('LuaParser.Node.CatGeneric', {
        id = id,
        start = id.start,
    })

    self:skipSpace()
    generic.symbolPos = self.lexer:consume ':'
    if generic.symbolPos then

        self:skipSpace()
        generic.extends = self:parseCatExp()
        if generic.extends then
            generic.extends.parent = generic
        end
    end

    generic.finish = self:getLastPos()

    return generic
end

---@private
---@return LuaParser.Node.CatGeneric[]
function Ast:parseCatGenericList()
    local list = self:parseList(true, true, self.parseCatGeneric)

    return list
end

---@private
---@param node LuaParser.Node.CatGenericMaster
---@param block LuaParser.Node.Block?
---@param skipBrackets? boolean
function Ast:parseCatGenericDef(node, block, skipBrackets)
    if not skipBrackets then
        self:skipSpace()
        node.genericPos1 = self.lexer:consume '<'
        if not node.genericPos1 then
            return
        end
    end

    self:skipSpace()
    node.typeParams = self:parseCatGenericList()
    for _, generic in ipairs(node.typeParams) do
        generic.parent = node
        if block then
            block.generics[#block.generics+1] = generic
            block.genericMap[generic.id.id] = generic
        end
    end

    if not skipBrackets then
        self:skipSpace()
        node.genericPos2 = self:assertSymbol '>'
    end
end
