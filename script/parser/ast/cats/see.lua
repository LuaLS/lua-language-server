---@class LuaParser.Node.CatStateSee: LuaParser.Node.Base
---@field value LuaParser.Node.CatSeeName
local CatStateSee = Class('LuaParser.Node.CatStateSee', 'LuaParser.Node.Base')

CatStateSee.kind = 'catstatesee'

---@class LuaParser.Node.CatSeeName: LuaParser.Node.Base
---@field id string
local CatSeeName = Class('LuaParser.Node.CatSeeName', 'LuaParser.Node.Base')

CatSeeName.kind = 'catseename'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

function Ast:parseCatStateSee()
    local value = self:parseID('LuaParser.Node.CatSeeName', true, 'yes')
    if not value then
        return nil
    end

    local catSee = self:createNode('LuaParser.Node.CatStateSee', {
        value  = value,
        start  = value.start,
        finish = value.finish,
    })
    value.parent = catSee

    return catSee
end
