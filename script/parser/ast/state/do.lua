
---@class LuaParser.Node.Do: LuaParser.Node.Block
---@field symbolPos? integer # end 的位置
local Do = Class('LuaParser.Node.Do', 'LuaParser.Node.Block')

Do.kind = 'do'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Do?
function Ast:parseDo()
    local pos = self.lexer:consume 'do'
    if not pos then
        return nil
    end

    local doNode = self:createNode('LuaParser.Node.Do', {
        start  = pos,
    })

    self:skipSpace()
    self:blockStart(doNode)
    self:blockParseChilds(doNode)
    self:blockFinish(doNode)

    self:skipSpace()
    doNode.symbolPos = self:assertSymbol 'end'

    if doNode.symbolPos then
        doNode.finish = self:getLastPos()
    else
        doNode.finish = self:getBlockEndPos()
    end

    return doNode
end
