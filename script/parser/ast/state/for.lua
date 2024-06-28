
---@class LuaParser.Node.For: LuaParser.Node.Block
---@field subtype 'loop' | 'in' | 'incomplete'
---@field vars LuaParser.Node.Local[]
---@field exps LuaParser.Node.Exp[]
---@field symbolPos1? integer # in 或 = 的位置
---@field symbolPos2? integer # do 的位置
---@field symbolPos3? integer # end 的位置
local For = Class('LuaParser.Node.For', 'LuaParser.Node.Block')

For.subtype = 'incomplete'
For.vars = {}
For.exps = {}

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.For?
function Ast:parseFor()
    local pos = self.lexer:consume 'for'
    if not pos then
        return nil
    end

    local forNode = self:createNode('LuaParser.Node.For', {
        start  = pos,
    })

    self:skipSpace()
    local vars = self:parseLocalList()
    forNode.vars = vars
    for i = 1, #vars do
        local var = vars[i]
        var.parent = forNode
        var.index  = i
    end

    self:skipSpace()
    local token, _, symbolPos = self.lexer:peek()

    forNode.symbolPos1 = symbolPos

    local extraLocalCount
    if token == '=' then
        forNode.subtype = 'loop'
        extraLocalCount = 3
    elseif token == 'in' then
        forNode.subtype = 'in'
        if self.versionNum >= 54 then
            extraLocalCount = 4
        else
            extraLocalCount = 3
        end
    else
        self:throwMissSymbol(self:getLastPos(), 'in')
        return forNode
    end

    -- 循环要使用额外的局部变量
    local block = self.curBlock
    self.localCount = self.localCount + extraLocalCount
    if block then
        block.localCount  = block.localCount + extraLocalCount
    end


    self.lexer:next()

    self:skipSpace()
    local exps = self:parseExpList(true, true)
    forNode.exps = exps
    for i = 1, #exps do
        local exp = exps[i]
        exp.parent = forNode
        exp.index  = i
    end

    if forNode.subtype == 'loop' then
        if #exps == 1 then
            self:throw('MISS_LOOP_MAX', self:getLastPos())
        end
    end

    self:skipSpace()
    local symbolPos2 = self:assertSymbolDo(true)

    if symbolPos2 then
        forNode.symbolPos2 = symbolPos2

        self:skipSpace()
        self:blockStart(forNode)
        for i = 1, #vars do
            self:initLocal(vars[i])
        end
        self:blockParseChilds(forNode)
        self:blockFinish(forNode)

    end

    self:skipSpace()
    local symbolPos3 = self:assertSymbolEnd(pos, pos + #'for')
    forNode.symbolPos3 = symbolPos3

    forNode.finish = self:getLastPos()

    return forNode
end
