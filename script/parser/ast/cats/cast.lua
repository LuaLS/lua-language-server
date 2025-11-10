---@class LuaParser.Node.CatStateCast: LuaParser.Node.Base
---@field items LuaParser.Node.CatStateCastItem[]
local CatStateCast = Class('LuaParser.Node.CatStateCast', 'LuaParser.Node.Base')

CatStateCast.kind = 'catstatecast'

---@class LuaParser.Node.CatStateCastItem: LuaParser.Node.Base
---@field var LuaParser.Node.Term
---@field type LuaParser.Node.CatExp
---@field op? '+' | '-'
local CatStateCastItem = Class('LuaParser.Node.CatStateCastItem', 'LuaParser.Node.Base')

CatStateCastItem.kind = 'catstatecastitem'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
function Ast:parseCatStateCast()
    local start = self:getLastPos()
    ---@type LuaParser.Node.CatStateCastItem[]
    local items = self:parseList(true, true, self.parseCatStateCastItem)

    local state = self:createNode('LuaParser.Node.CatStateCast', {
        items  = items,
        start  = start,
        finish = self:getLastPos(),
    })
    for _, item in ipairs(items) do
        item.parent = state
    end
    return state
end

function Ast:parseCatStateCastItem()
    local start = self:getLastPos()
    local op = self.lexer:consume('+') and '+'
            or self.lexer:consume('-') and '-'
            or nil

    self:skipSpace()
    local var = self:parseTerm()
    if not var then
        return nil
    end
    local finish = self:getLastPos()

    self:skipSpace()
    local item = self:createNode('LuaParser.Node.CatStateCastItem', {
        op     = op,
        var    = var,
        type   = self:parseCatExp(),
        start  = start,
        finish = finish,
    })

    return item
end
