
---@class LuaParser.Node.CatStateField: LuaParser.Node.Base
---@field key LuaParser.Node.CatFieldName
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
---@return LuaParser.Node.CatStateField?
function Ast:parseCatStateField()
    local key = self:parseID('LuaParser.Node.CatFieldName', true, true)
    if not key then
        return nil
    end

    local catField = self:createNode('LuaParser.Node.CatStateField', {
        key = key,
        start = key.start,
    })

    key.parent = catField

    self:skipSpace()

    catField.value = self:parseCatExp(true)

    catField.finish = self:getLastPos()

    return catField
end
