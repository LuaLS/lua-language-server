
---@class LuaParser.Node.CatSubtract: LuaParser.Node.Base
---@field a LuaParser.Node.CatExp
---@field b? LuaParser.Node.CatExp
---@field symbolPos integer # `~` 的位置
local Subtract = Class('LuaParser.Node.CatSubtract', 'LuaParser.Node.Base')

Subtract.kind = 'catsubtract'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param required? boolean
---@return LuaParser.Node.CatExp?
function Ast:parseCatSubtract(required)
    local first = self:parseCatIntersection(required)
    if not first then
        return nil
    end

    local pos = self.lexer:consume '~'
    if not pos then
        return first
    end

    local subtract = self:createNode('LuaParser.Node.CatSubtract', {
        start     = first.start,
        a         = first,
        symbolPos = pos,
    })
    first.parent = subtract

    self:skipSpace()
    local second = self:parseCatIntersection(true)
    if second then
        second.parent = subtract
        subtract.b = second
    end
    subtract.finish = self:getLastPos()

    return subtract
end
