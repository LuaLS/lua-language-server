
---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param atLeastOne? boolean
---@param greedy? boolean
---@param parser function
---@return any[]
function Ast:parseList(atLeastOne, greedy, parser)
    local list = {}
    local first = parser(self, atLeastOne)
    list[#list+1] = first
    local wantSep = first ~= nil
    while true do
        self:skipSpace()
        local token, tp, pos = self.lexer:peek()
        if not token then
            break
        end
        ---@cast pos -?
        if tp == 'Symbol' then
            if token == ',' then
                if not wantSep then
                    self:throw('UNEXPECT_SYMBOL', pos, pos + 1)
                end
                self.lexer:next()
                self:skipSpace()
                wantSep = false
            else
                break
            end
        else
            if not greedy then
                break
            end
            if tp == 'NL' then
                break
            end
            if tp == 'Word' and self:isKeyWord(token) then
                break
            end
            ---@type LuaParser.Node.Cat
            local last = list[#list]
            if last.finishRow ~= self.lexer:rowcol(pos) then
                -- 如果不在同一行，则认为与本行无关
                break
            end
            self:throwMissSymbol(self:getLastPos(), ',')
        end
        local unit = parser(self, true)
        if unit then
            list[#list+1] = unit
        else
            break
        end
        wantSep = true
    end
    return list
end
