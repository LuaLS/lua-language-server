
---@class LuaParser.Node.CatStateReturn: LuaParser.Node.Base
---@field key? LuaParser.Node.CatReturnName
---@field value LuaParser.Node.CatExp
---@field returns? LuaParser.Node.CatStateReturnItem[]
local CatStateReturn = Class('LuaParser.Node.CatStateReturn', 'LuaParser.Node.Base')

CatStateReturn.kind = 'catstatereturn'

---@class LuaParser.Node.CatReturnName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatStateReturn | LuaParser.Node.CatStateReturnItem
---@field id string
local CatReturnName = Class('LuaParser.Node.CatReturnName', 'LuaParser.Node.Base')

CatReturnName.kind = 'catreturnname'

---@class LuaParser.Node.CatStateReturnItem: LuaParser.Node.Base
---@field parent LuaParser.Node.CatStateReturn
---@field key? LuaParser.Node.CatReturnName
---@field value LuaParser.Node.CatExp
local CatStateReturnItem = Class('LuaParser.Node.CatStateReturnItem', 'LuaParser.Node.Base')

CatStateReturnItem.kind = 'catstatereturnitem'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param required? boolean
---@return LuaParser.Node.CatStateReturnItem?
function Ast:parseCatStateReturnItem(required)
    local value = self:parseCatExp(required)
    if not value then
        return nil
    end

    local ret = self:createNode('LuaParser.Node.CatStateReturnItem', {
        value = value,
        start = value.start,
    })
    value.parent = ret

    self:skipSpace()

    -- 兼容 `---@return string? name`：当 `?` 后紧跟返回名时，把 `?` 视作类型可选后缀。
    if self.lexer:consume '?' then
        value.optional = true
        self:skipSpace()
    end

    local key = self:parseID('LuaParser.Node.CatReturnName', false, 'yes')
    if key then
        ret.key = key
        key.parent = ret
    end

    ret.finish = self:getLastPos()

    return ret
end

---@private
---@return LuaParser.Node.CatStateReturn?
function Ast:parseCatStateReturn()
    local returns = self:parseList(true, false, self.parseCatStateReturnItem)
    if #returns == 0 then
        return nil
    end

    local first = returns[1]
    local last = returns[#returns]

    local catReturn = self:createNode('LuaParser.Node.CatStateReturn', {
        value = first.value,
        key = first.key,
        returns = returns,
        start = first.start,
    })

    for _, ret in ipairs(returns) do
        ret.parent = catReturn
    end

    catReturn.finish = last and last.finish or self:getLastPos()

    return catReturn
end
