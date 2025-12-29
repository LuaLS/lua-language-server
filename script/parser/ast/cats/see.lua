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

---@private
function Ast:parseCatStateSee()
    local _, _, pos = self.lexer:peek()
    if not pos then
        return nil
    end

    local id = self.code:match('^[%a\x80-\xff_][%w\x80-\xff_%.%*%-]*', pos + 1)
    if not id then
        return nil
    end

    local finish = pos + #id
    self.lexer:moveTo(finish)

    local value = self:createNode('LuaParser.Node.CatSeeName', {
        id     = id,
        start  = pos,
        finish = finish,
    })

    local catSee = self:createNode('LuaParser.Node.CatStateSee', {
        value  = value,
        start  = value.start,
        finish = value.finish,
    })
    value.parent = catSee

    return catSee
end
