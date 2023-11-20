local class = require 'class'

---@class LuaParser.Node.CatID: LuaParser.Node.Base
---@field id string
local CatID = class.declare('LuaParser.Node.CatID', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@return LuaParser.Node.CatID?
function Ast:parseCatID()
    local _, _, pos = self.lexer:peek()
    if not pos then
        return nil
    end

    local id = self.code:match('[%a\x80-\xff_][%w\x80-\xff_%.%*%-]*', pos + 1)
    if not id then
        return nil
    end

    local finish = pos + #id
    self.lexer:fastForward(finish)

    return self:createNode('LuaParser.Node.CatID', {
        id     = id,
        start  = pos,
        finish = finish,
    })
end
