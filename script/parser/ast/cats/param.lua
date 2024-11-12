
---@class LuaParser.Node.CatParam: LuaParser.Node.Base
---@field key LuaParser.Node.CatParamName
---@field value? LuaParser.Node.CatType
local CatParam = Class('LuaParser.Node.CatParam', 'LuaParser.Node.Base')

CatParam.kind = 'catparam'

---@class LuaParser.Node.CatParamName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatParam
---@field id string
local CatParamName = Class('LuaParser.Node.CatParamName', 'LuaParser.Node.Base')

CatParamName.kind = 'catparamname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatParam?
function Ast:parseCatParam()
    local key = self:parseID('LuaParser.Node.CatParamName', true, true)
    if not key then
        return nil
    end

    local catParam = self:createNode('LuaParser.Node.CatParam', {
        key = key,
        start = key.start,
    })

    key.parent = catParam

    self:skipSpace()

    catParam.value = self:parseCatType(true)

    if catParam.value then
        catParam.value.parent = catParam
    end

    catParam.finish = self:getLastPos()

    return catParam
end
