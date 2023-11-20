local class = require 'class'

---@class LuaParser.Node.Do: LuaParser.Node.Block
---@field symbolPos? integer # end 的位置
local Do = class.declare('LuaParser.Node.Do', 'LuaParser.Node.Block')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

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

    doNode.finish = self:getLastPos()

    return doNode
end
