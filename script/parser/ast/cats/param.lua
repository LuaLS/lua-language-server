
---@class LuaParser.Node.CatStateParam: LuaParser.Node.Base
---@field key LuaParser.Node.CatParamName
---@field optional? boolean
---@field value? LuaParser.Node.CatExp
local CatStateParam = Class('LuaParser.Node.CatStateParam', 'LuaParser.Node.Base')

CatStateParam.kind = 'catstateparam'

---@class LuaParser.Node.CatParamName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatStateParam
---@field id string
local CatParamName = Class('LuaParser.Node.CatParamName', 'LuaParser.Node.Base')

CatParamName.kind = 'catparamname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateParam?
function Ast:parseCatStateParam()
    local key = self:parseID('LuaParser.Node.CatParamName', true, true, true)
    if not key then
        return nil
    end
    local optional = self.lexer:consume '?' and true or nil

    local catParam = self:createNode('LuaParser.Node.CatStateParam', {
        key = key,
        start = key.start,
        optional = optional,
    })

    key.parent = catParam

    self:skipSpace()

    catParam.value = self:parseCatExp(true)

    if catParam.value then
        catParam.value.parent = catParam
    end

    catParam.finish = self:getLastPos()

    return catParam
end
