
---@class LuaParser.Node.CatStateReturn: LuaParser.Node.Base
---@field key? LuaParser.Node.CatReturnName
---@field value LuaParser.Node.CatExp
local CatStateReturn = Class('LuaParser.Node.CatStateReturn', 'LuaParser.Node.Base')

CatStateReturn.kind = 'catstatereturn'

---@class LuaParser.Node.CatReturnName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatStateReturn
---@field id string
local CatReturnName = Class('LuaParser.Node.CatReturnName', 'LuaParser.Node.Base')

CatReturnName.kind = 'catreturnname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateReturn?
function Ast:parseCatStateReturn()
    local value = self:parseCatExp(true)
    if not value then
        return nil
    end

    local catReturn = self:createNode('LuaParser.Node.CatStateReturn', {
        value = value,
        start = value.start,
    })

    if value then
        value.parent = catReturn
    end

    self:skipSpace()

    local key = self:parseID('LuaParser.Node.CatReturnName', false, 'yes')

    if key then
        catReturn.key = key
        key.parent = catReturn
    end

    catReturn.finish = self:getLastPos()

    return catReturn
end
