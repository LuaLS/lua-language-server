---@class LuaParser.Node.CatTuple: LuaParser.Node.Base
---@field exps LuaParser.Node.CatExp[]
local CatTuple = Class('LuaParser.Node.CatTuple', 'LuaParser.Node.Base')

CatTuple.kind = 'cattuple'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
function Ast:parseCatTuple()
    local pos = self.lexer:consume '['
    if not pos then
        return
    end

    local catTuple = self:createNode('LuaParser.Node.CatTuple', {
        start  = pos,
    })

    local exps = self:parseCatTypeList(true)
    catTuple.exps = exps
    for _, exp in ipairs(exps) do
        exp.parent = catTuple
    end

    self:assertSymbol ']'

    catTuple.finish = self:getLastPos()

    return catTuple
end
