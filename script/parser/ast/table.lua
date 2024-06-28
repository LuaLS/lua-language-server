
---@class LuaParser.Node.Table: LuaParser.Node.Base
---@field fields LuaParser.Node.Field[]
local Table = Class('LuaParser.Node.Table', 'LuaParser.Node.Base')

Table.isLiteral = true

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Table?
function Ast:parseTable()
    local pos = self.lexer:consume '{'
    if not pos then
        return nil
    end

    self:skipSpace()
    local fields = self:parseTableFields()
    self:skipSpace()

    self:assertSymbol '}'

    local table = self:createNode('LuaParser.Node.Table', {
        start   = pos,
        finish  = self:getLastPos(),
        fields  = fields,
    })

    local expi = 0
    for _, field in ipairs(fields) do
        field.parent = table
        if field.subtype == 'exp' then
            expi = expi + 1
            field.key = self:createNode('LuaParser.Node.Integer', {
                dummy   = true,
                value   = expi,
                start   = field.start,
                finish  = field.start,
                parent  = field,
            })
        end
    end

    return table
end

---@private
---@return LuaParser.Node.TableField[]
function Ast:parseTableFields()
    local fields = {}
    local wantSep = false
    while true do
        local token, _, pos = self.lexer:peek()
        if not token or token == '}' then
            break
        end
        if token == ','
        or token == ';' then
            if not wantSep then
                self:throwMissExp(self:getLastPos())
            end
            wantSep = false
            self.lexer:next()
        else
            if wantSep then
                local lastField = fields[#fields]
                self:throw('MISS_SEP_IN_TABLE', lastField.finish, pos)
            end
            wantSep = true
            local field = self:parseTableField()
            if field then
                fields[#fields+1] = field
            else
                self:throwMissExp(self:getLastPos())
                break
            end
        end
        self:skipSpace()
    end
    return fields
end
