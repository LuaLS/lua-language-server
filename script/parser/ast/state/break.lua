
---@class LuaParser.Node.Break: LuaParser.Node.Base
---@field breeakBlock? LuaParser.Node.Block
local Break = Class('LuaParser.Node.Break', 'LuaParser.Node.Base')

Break.kind = 'break'

---@class LuaParser.Node.Continue: LuaParser.Node.Base
local Continue = Class('LuaParser.Node.Continue', 'LuaParser.Node.Base')

Continue.kind = 'continue'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Block?
function Ast:findBreakBlock()
    local blocks = self.blocks
    for i = #blocks, 1, -1 do
        local block = blocks[i]
        if block.kind == 'for'
        or block.kind == 'while'
        or block.kind == 'repeat' then
            return block
        end
        if block.kind == 'function'
        or block.kind == 'main' then
            return nil
        end
    end
    return nil
end

---@private
---@return LuaParser.Node.Break?
function Ast:parseBreak()
    local pos = self.lexer:consume 'break'
    if not pos then
        return
    end

    local block = self:findBreakBlock()
    if not block then
        self:throw('BREAK_OUTSIDE', pos, pos + #'break')
    end

    return self:createNode('LuaParser.Node.Break', {
        start  = pos,
        finish = self:getLastPos(),
        breakBlock = block,
    })
end

---@private
---@return LuaParser.Node.Continue?
function Ast:parseContinue()
    if not self.nssymbolMap['continue'] then
        return nil
    end
    local pos = self.lexer:consume 'continue'
    if not pos then
        return
    end

    local block = self:findBreakBlock()
    if not block then
        self:throw('BREAK_OUTSIDE', pos, pos + #'break')
    end

    return self:createNode('LuaParser.Node.Continue', {
        start  = pos,
        finish = self:getLastPos(),
        breakBlock = block,
    })
end
