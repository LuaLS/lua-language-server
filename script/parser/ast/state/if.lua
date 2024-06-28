
---@class LuaParser.Node.If: LuaParser.Node.Base
---@field childs LuaParser.Node.IfChild[]
local If = Class('LuaParser.Node.If', 'LuaParser.Node.Base')

---@class LuaParser.Node.IfChild: LuaParser.Node.Block
---@field subtype 'if' | 'elseif' | 'else'
---@field condition? LuaParser.Node.Exp
---@field symbolPos? integer # then 的位置
local IfChild = Class('LuaParser.Node.IfChild', 'LuaParser.Node.Block')

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.If?
function Ast:parseIf()
    local token, _, pos = self.lexer:peek()
    if token ~= 'if' then
        return nil
    end

    ---@cast pos -?

    local ifNode = self:createNode('LuaParser.Node.If', {
        start  = pos,
        childs = {},
    })

    local hasElse
    while true do
        local child = self:parseIfChild()
        if not child then
            break
        end
        child.parent = ifNode
        ifNode.childs[#ifNode.childs+1] = child

        if hasElse then
            self:throw('BLOCK_AFTER_ELSE', child.start, child.start + #child.subtype)
        end
        if child.subtype == 'else' then
            hasElse = true
        end
    end

    self:skipSpace()
    self:assertSymbolEnd(pos, pos + #'if')

    ifNode.finish = self:getLastPos()

    return ifNode
end

---@private
---@return LuaParser.Node.IfChild?
function Ast:parseIfChild()
    return self:parseIfChildIf()
        or self:parseIfChildElseIf()
        or self:parseIfChildElse()
end

---@private
---@return LuaParser.Node.IfChild?
function Ast:parseIfChildIf()
    local pos = self.lexer:consume 'if'
    if not pos then
        return nil
    end

    self:skipSpace()
    local condition = self:parseExp(true)

    local node = self:createNode('LuaParser.Node.IfChild', {
        subtype   = 'if',
        start     = pos,
        condition = condition,
    })

    self:skipSpace()
    node.symbolPos = self:assertSymbolThen(condition ~= nil)

    self:skipSpace()
    self:blockStart(node)
    self:blockParseChilds(node)
    self:blockFinish(node)
    node.finish = self:getLastPos()

    return node
end

---@private
---@return LuaParser.Node.IfChild?
function Ast:parseIfChildElseIf()
    local pos = self.lexer:consume 'elseif'
    if not pos then
        return nil
    end

    self:skipSpace()
    local condition = self:parseExp(true)

    local node = self:createNode('LuaParser.Node.IfChild', {
        subtype   = 'elseif',
        start     = pos,
        condition = condition,
    })

    self:skipSpace()
    node.symbolPos = self:assertSymbolThen(condition ~= nil)

    self:skipSpace()
    self:blockStart(node)
    self:blockParseChilds(node)
    self:blockFinish(node)
    node.finish = self:getLastPos()

    return node
end

---@private
---@return LuaParser.Node.IfChild?
function Ast:parseIfChildElse()
    local pos = self.lexer:consume 'else'
    if not pos then
        return nil
    end

    self:skipSpace()

    local node = self:createNode('LuaParser.Node.IfChild', {
        subtype   = 'else',
        start     = pos,
    })

    self:blockStart(node)
    self:blockParseChilds(node)
    self:blockFinish(node)

    node.finish = self:getLastPos()

    return node
end
