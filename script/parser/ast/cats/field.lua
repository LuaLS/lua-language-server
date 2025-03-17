
---@class LuaParser.Node.CatField: LuaParser.Node.Base
---@field key LuaParser.Node.CatFieldName
---@field value? LuaParser.Node.CatExp
local CatField = Class('LuaParser.Node.CatField', 'LuaParser.Node.Base')

CatField.kind = 'catfield'

---@class LuaParser.Node.CatFieldName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatField
---@field id string
local CatFieldName = Class('LuaParser.Node.CatFieldName', 'LuaParser.Node.Base')

CatFieldName.kind = 'catfieldname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatField?
function Ast:parseCatField()
    local key = self:parseID('LuaParser.Node.CatFieldName', true, true)
    if not key then
        return nil
    end

    local catField = self:createNode('LuaParser.Node.CatField', {
        key = key,
        start = key.start,
    })

    key.parent = catField

    self:skipSpace()

    catField.value = self:parseCatExp(true)

    catField.finish = self:getLastPos()

    return catField
end
