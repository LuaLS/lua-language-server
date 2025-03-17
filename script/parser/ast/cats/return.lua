
---@class LuaParser.Node.CatReturn: LuaParser.Node.Base
---@field key? LuaParser.Node.CatReturnName
---@field value LuaParser.Node.CatExp
local CatReturn = Class('LuaParser.Node.CatReturn', 'LuaParser.Node.Base')

CatReturn.kind = 'catreturn'

---@class LuaParser.Node.CatReturnName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatReturn
---@field id string
local CatReturnName = Class('LuaParser.Node.CatReturnName', 'LuaParser.Node.Base')

CatReturnName.kind = 'catreturnname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatReturn?
function Ast:parseCatReturn()
    local value = self:parseCatExp(true)
    if not value then
        return nil
    end

    local catReturn = self:createNode('LuaParser.Node.CatReturn', {
        value = value,
        start = value.start,
    })

    value.parent = catReturn

    self:skipSpace()

    local key = self:parseID('LuaParser.Node.CatReturnName', false, true)

    if key then
        key.parent = catReturn
    end

    catReturn.finish = self:getLastPos()

    return catReturn
end
