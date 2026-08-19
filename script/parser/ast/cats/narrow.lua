
---@class LuaParser.Node.CatStateNarrow: LuaParser.Node.Base
---@field key LuaParser.Node.CatNarrowName
---@field type? LuaParser.Node.CatExp
local CatStateNarrow = Class('LuaParser.Node.CatStateNarrow', 'LuaParser.Node.Base')

CatStateNarrow.kind = 'catstatenarrow'

---@class LuaParser.Node.CatNarrowName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatStateNarrow
---@field id string
local CatNarrowName = Class('LuaParser.Node.CatNarrowName', 'LuaParser.Node.Base')

CatNarrowName.kind = 'catnarrowname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateNarrow?
function Ast:parseCatStateNarrow()
    local key = self:parseID('LuaParser.Node.CatNarrowName', true, 'no', true)
    if not key then
        return nil
    end
    local catNarrow = self:createNode('LuaParser.Node.CatStateNarrow', {
        key = key,
        start = key.start,
    })

    key.parent = catNarrow

    self:skipSpace()

    catNarrow.type = self:parseCatExp(false)

    if catNarrow.type then
        catNarrow.type.parent = catNarrow
    end

    catNarrow.finish = self:getLastPos()

    return catNarrow
end
