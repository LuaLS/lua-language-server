
---@class LuaParser.Node.CatStateField: LuaParser.Node.Base
---@field key? LuaParser.Node.CatFieldName | LuaParser.Node.CatExp
---@field pos? integer
---@field pos2? integer
---@field optional? boolean
---@field value? LuaParser.Node.CatExp
local CatStateField = Class('LuaParser.Node.CatStateField', 'LuaParser.Node.Base')

CatStateField.kind = 'catstatefield'

---@class LuaParser.Node.CatFieldName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatStateField
---@field id string
local CatFieldName = Class('LuaParser.Node.CatFieldName', 'LuaParser.Node.Base')

CatFieldName.kind = 'catfieldname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
function Ast:parseCatFieldAsIndex()
    local token, _, pos = self.lexer:peek()
    if token ~= '[' then
        return nil
    end
    self.lexer:next()
    self:skipSpace()
    local key = self:parseCatExp(true)
    self:skipSpace()
    local pos2 = self:assertSymbol ']'
    return key, pos, pos2
end

---@private
---@return LuaParser.Node.CatStateField?
function Ast:parseCatStateField()
    local token, _, pos = self.lexer:peek()
    local key, start, pos2
    if token == '[' then
        self.lexer:next()
        self:skipSpace()
        key = self:parseCatExp(true)
        self:skipSpace()
        start = pos
        pos2 = self:assertSymbol ']'
    else
        key = self:parseID('LuaParser.Node.CatFieldName', false, 'yes')
        start = key and key.start
    end
    if not key then
        return nil
    end
    local optional = self.lexer:consume '?' and true or nil

    local catField = self:createNode('LuaParser.Node.CatStateField', {
        key = key,
        pos = pos,
        pos2 = pos2,
        optional = optional,
        start = start,
    })

    key.parent = catField

    self:skipSpace()

    catField.value = self:parseCatExp(true)

    catField.finish = self:getLastPos()

    return catField
end
