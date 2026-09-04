---@class LuaParser.Node.CatStateType: LuaParser.Node.Base
---@field exp LuaParser.Node.CatExp
---@field exps LuaParser.Node.CatExp[]  # `---@type A, B` 的多类型（首个与 exp 相同）
local CatStateType = Class('LuaParser.Node.CatStateType', 'LuaParser.Node.Base')

CatStateType.kind = 'catstatetype'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateType?
function Ast:parseCatStateType()
    local exps = self:parseList(true, false, self.parseCatExp)
    if #exps == 0 then
        return nil
    end

    local catType = self:createNode('LuaParser.Node.CatStateType', {
        exp  = exps[1],
        exps = exps,
        start = exps[1].start,
    })

    for _, e in ipairs(exps) do
        e.parent = catType
    end

    catType.finish = self:getLastPos()

    return catType
end
