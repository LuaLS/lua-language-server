local class = require'class'

---@class LuaParser.Node.CatCross: LuaParser.Node.Base
---@field poses integer[] # 所有 & 的位置
---@field exps LuaParser.Node.CatType[] # 所有的子表达式
local Cross = class.declare('LuaParser.Node.CatCross', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@private
---@param required? boolean
---@return LuaParser.Node.CatType?
function Ast:parseCatCross(required)
    local first = self:parseCatTerm(required)
    if not first then
        return nil
    end

    local pos = self.lexer:consume '&'
    if not pos then
        return first
    end

    local cross = self:createNode('LuaParser.Node.CatCross', {
        start = first.start,
        poses = { pos },
        exps  = { first },
    })

    while true do
        self:skipSpace()
        local nextNode = self:parseCatTerm(true)
        cross.exps[#cross.exps+1] = nextNode

        self:skipSpace()
        local nextPos = self.lexer:consume '&'
        if not nextPos then
            break
        end

        cross.poses[#cross.poses+1] = nextPos
    end

    cross.finish = self:getLastPos()

    return cross
end
