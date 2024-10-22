
---@class LuaParser.Node.Repeat: LuaParser.Node.Block
---@field condition? LuaParser.Node.Exp
---@field symbolPos? integer # until 的位置
local Repeat = Class('LuaParser.Node.Repeat', 'LuaParser.Node.Block')

Repeat.kind = 'repeat'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Repeat?
function Ast:parseRepeat()
    local pos = self.lexer:consume 'repeat'
    if not pos then
        return nil
    end

    local repeatNode = self:createNode('LuaParser.Node.Repeat', {
        start = pos,
    })

    self:skipSpace()
    self:blockStart(repeatNode)
    self:blockParseChilds(repeatNode)

    self:skipSpace()
    local symbolPos = self:assertSymbol 'until'
    if symbolPos then
        repeatNode.symbolPos = symbolPos

        self:skipSpace()
        local condition = self:parseExp(true)
        if condition then
            repeatNode.condition = condition
            condition.parent = repeatNode
        end
    end
    self:blockFinish(repeatNode)

    repeatNode.finish = self:getLastPos()

    return repeatNode
end
