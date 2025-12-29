---@class LuaParser.Node.CatStateCast: LuaParser.Node.Base
---@field var LuaParser.Node.Term
---@field items LuaParser.Node.CatStateCastItem[]
local CatStateCast = Class('LuaParser.Node.CatStateCast', 'LuaParser.Node.Base')

CatStateCast.kind = 'catstatecast'

---@class LuaParser.Node.CatStateCastItem: LuaParser.Node.Base
---@field op? '+' | '-'
---@field isOptional? boolean
---@field type? LuaParser.Node.CatExp
local CatStateCastItem = Class('LuaParser.Node.CatStateCastItem', 'LuaParser.Node.Base')

CatStateCastItem.kind = 'catstatecastitem'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
function Ast:parseCatStateCast()

    local var = self:parseTerm()
    if not var then
        return nil
    end

    ---@type LuaParser.Node.CatStateCastItem[]
    local items = self:parseList(true, false, self.parseCatStateCastItem)

    local state = self:createNode('LuaParser.Node.CatStateCast', {
        var    = var,
        items  = items,
        start  = var.start,
        finish = self:getLastPos(),
    })
    for _, item in ipairs(items) do
        item.parent = state
    end
    return state
end

---@private
function Ast:parseCatStateCastItem()
    local start = self:getLastPos()
    local op = self.lexer:consume('+') and '+'
            or self.lexer:consume('-') and '-'
            or nil

    self:skipSpace()

    local exp, isOptional
    if self.lexer:consume '?' then
        isOptional = true
    else
        local exp = self:parseCatExp()
        if not exp then
            return nil
        end
    end

    self:skipSpace()
    local item = self:createNode('LuaParser.Node.CatStateCastItem', {
        op         = op,
        type       = exp,
        isOptional = isOptional,
        start      = start,
        finish     = self:getLastPos(),
    })

    return item
end
