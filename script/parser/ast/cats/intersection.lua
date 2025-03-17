local class = require'class'

---@class LuaParser.Node.CatIntersection: LuaParser.Node.Base
---@field poses integer[] # 所有 & 的位置
---@field exps LuaParser.Node.CatExp[] # 所有的子表达式
local Intersection = Class('LuaParser.Node.CatIntersection', 'LuaParser.Node.Base')

Intersection.kind = 'catintersection'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param required? boolean
---@return LuaParser.Node.CatExp?
function Ast:parseCatIntersection(required)
    local first = self:parseCatTerm(required)
    if not first then
        return nil
    end

    local pos = self.lexer:consume '&'
    if not pos then
        return first
    end

    local intersection = self:createNode('LuaParser.Node.CatIntersection', {
        start = first.start,
        poses = { pos },
        exps  = { first },
    })

    while true do
        self:skipSpace()
        local nextNode = self:parseCatTerm(true)
        intersection.exps[#intersection.exps+1] = nextNode

        self:skipSpace()
        local nextPos = self.lexer:consume '&'
        if not nextPos then
            break
        end

        intersection.poses[#intersection.poses+1] = nextPos
    end

    intersection.finish = self:getLastPos()

    return intersection
end
