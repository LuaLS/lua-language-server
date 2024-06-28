
---@class LuaParser.Node.CatTable: LuaParser.Node.Base
---@field fields LuaParser.Node.CatTableField[]
local CatTable = Class('LuaParser.Node.CatTable', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatTableField: LuaParser.Node.Base
---@field subtype 'field' | 'index'
---@field key? LuaParser.Node.CatTableFieldID | LuaParser.Node.CatType
---@field value? LuaParser.Node.CatType
---@field symbolPos? integer
---@field symbolPos2? integer
---@field parent LuaParser.Node.CatTable
local CatTableField = Class('LuaParser.Node.CatTableField', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatTableFieldID: LuaParser.Node.Base
---@field id string
---@field parent LuaParser.Node.CatTableField
local CatTableFieldID = Class('LuaParser.Node.CatTableFieldID', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatTable?
function Ast:parseCatTable()
    local pos = self.lexer:consume '{'
    if not pos then
        return
    end

    local catTable = self:createNode('LuaParser.Node.CatTable', {
        start  = pos,
    })

    local fields = self:parseCatTableFields()
    catTable.fields = fields
    for _, field in ipairs(fields) do
        field.parent = catTable
    end

    self:assertSymbol '}'

    catTable.finish = self:getLastPos()

    return catTable
end

---@private
---@return LuaParser.Node.CatTableField[]
function Ast:parseCatTableFields()
    local fields = {}
    local wantSep = false
    while true do
        local token, _, pos = self.lexer:peek()
        if not token or token == '}' then
            break
        end
        if token == ',' then
            if not wantSep then
                self:throwMissExp(self:getLastPos())
            end
            wantSep = false
            self.lexer:next()
        else
            if wantSep then
                local lastField = fields[#fields]
                self:throw('MISS_SEP_IN_TABLE', lastField.finish, pos)
                break
            end
            wantSep = true
            local field = self:parseCatTableField()
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

---@private
---@return LuaParser.Node.CatTableField?
function Ast:parseCatTableField()
    return self:parseCatTableFieldAsField()
        or self:parseCatTableFieldAsIndex()
end

---@private
---@return LuaParser.Node.CatTableField?
function Ast:parseCatTableFieldAsField()
    local key

    local pos = self.lexer:consume '...'
    if pos then
        key = self:createNode('LuaParser.Node.CatTableFieldID', {
            start  = pos,
            finish = pos + #'...',
            id     = '...',
        })
    else
        key = self:parseID('LuaParser.Node.CatTableFieldID', false, true)
    end

    if not key then
        return nil
    end

    local value
    self:skipSpace()
    if self.lexer:consume ':' then
        self:skipSpace()
        value = self:parseCatType(true)
    end

    local tfield = self:createNode('LuaParser.Node.CatTableField', {
        subtype = 'field',
        key     = key,
        value   = value,
        start   = key.start,
        finish  = self:getLastPos(),
    })
    key.parent = tfield
    if value then
        value.parent = tfield
    end
    return tfield
end

---@private
---@return LuaParser.Node.CatTableField?
function Ast:parseCatTableFieldAsIndex()
    local token, _, pos = self.lexer:peek()
    if token ~= '[' then
        return nil
    end
    self.lexer:next()
    self:skipSpace()
    local key = self:parseCatType(true)
    self:skipSpace()
    local pos2 = self:assertSymbol ']'
    self:skipSpace()

    local value
    if self.lexer:consume ':' then
        self:skipSpace()
        value = self:parseCatType(true)
    end
    local tfield = self:createNode('LuaParser.Node.CatTableField', {
        subtype = 'index',
        key     = key,
        value   = value,
        start   = pos,
        finish  = self:getLastPos(),
        symbolPos  = pos,
        symbolPos2 = pos2,
    })
    if key then
        key.parent = tfield
    end
    if value then
        value.parent = tfield
    end
    return tfield
end
