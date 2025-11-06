---@class LuaParser.Node.CatStateOverload: LuaParser.Node.Base
---@field value LuaParser.Node.CatExp
local CatStateOverload = Class('LuaParser.Node.CatStateOverload', 'LuaParser.Node.Base')

CatStateOverload.kind = 'catstateoverload'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

function Ast:parseCatStateOverload()
    local value = self:parseCatExp(true)
    if not value then
        return nil
    end

    local catOverload = self:createNode('LuaParser.Node.CatStateOverload', {
        value  = value,
        start  = value.start,
        finish = value.finish,
    })
    value.parent = catOverload

    return catOverload
end
