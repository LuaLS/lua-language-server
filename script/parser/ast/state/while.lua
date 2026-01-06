
---@class LuaParser.Node.While: LuaParser.Node.Block
---@field condition LuaParser.Node.Exp
---@field symbolPos1? integer # do 的位置
---@field symbolPos2? integer # end 的位置
local While = Class('LuaParser.Node.While', 'LuaParser.Node.Block')

While.kind = 'while'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.While?
function Ast:parseWhile()
    local pos = self.lexer:consume 'while'
    if not pos then
        return nil
    end

    self:skipSpace()
    local condition = self:parseExp(true)

    local whileNode = self:createNode('LuaParser.Node.While', {
        start     = pos,
        condition = condition,
    })
    if condition then
        condition.parent = whileNode
    end

    self:skipSpace()
    local symbolPos1 = self:assertSymbolDo(true)
    if symbolPos1 then
        whileNode.symbolPos1 = symbolPos1

        self:skipSpace()
        self:blockStart(whileNode)
        self:blockParseChilds(whileNode)
        self:blockFinish(whileNode)

    end

    self:skipSpace()
    local symbolPos2 = self:assertSymbolEnd(pos, pos + #'while')
    whileNode.symbolPos2 = symbolPos2

    if symbolPos2 then
        whileNode.finish = self:getLastPos()
    else
        whileNode.finish = self:getBlockEndPos()
    end

    return whileNode
end
