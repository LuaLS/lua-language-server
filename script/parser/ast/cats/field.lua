
---@class LuaParser.Node.CatStateField: LuaParser.Node.Base
---@field key LuaParser.Node.CatFieldName
---@field value? LuaParser.Node.CatExp
---@field optional? boolean
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
---@return LuaParser.Node.CatStateField?
function Ast:parseCatStateField()
    local key = self:parseID('LuaParser.Node.CatFieldName', true, 'yes')
    if not key then
        return nil
    end
    local optional = self.lexer:consume '?' and true or nil

    local catField = self:createNode('LuaParser.Node.CatStateField', {
        key = key,
        start = key.start,
        optional = optional,
    })

    key.parent = catField

    self:skipSpace()

    catField.value = self:parseCatExp(true)

    catField.finish = self:getLastPos()

    return catField
end
