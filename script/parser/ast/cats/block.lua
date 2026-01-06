---@class LuaParser.Node.CatBlock: LuaParser.Node.Block
local Block = Class('LuaParser.Node.CatBlock', 'LuaParser.Node.Block')

Block.kind = 'catblock'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param start integer
---@param finish integer
---@return LuaParser.Node.CatBlock
function Ast:parseCatBlockInRange(start, finish)
    local block = self:createNode('LuaParser.Node.CatBlock', {
        start  = start,
        finish = finish,
    })

    -- self:skipSpace()
    -- self:blockStart(block)
    -- self:blockParseChilds(block)
    -- self:blockFinish(block)

    -- self:skipSpace()

    return block
end
