
---@class LuaParser.Node.CatID: LuaParser.Node.Base
---@field id string
---@field generic? LuaParser.Node.CatGeneric
---@field genericTemplate? table<string, LuaParser.Node.CatGeneric?>
local CatID = Class('LuaParser.Node.CatID', 'LuaParser.Node.Base')

CatID.kind = 'catid'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatID?
function Ast:parseCatID()
    local _, _, pos = self.lexer:peek()
    if not pos then
        return nil
    end

    local id = self.code:match('^[%a\x80-\xff_%`][%w\x80-\xff_%.%*%-%`]*', pos + 1)
    if not id then
        return nil
    end
    ---@cast id string

    local finish = pos + #id
    self.lexer:fastForward(finish)

    local res = self:createNode('LuaParser.Node.CatID', {
        id     = id,
        start  = pos,
        finish = finish,
    })

    local block = self.curBlock
    if block then
        local generic = block.genericMap[id]
        res.generic = generic
        if id:find('`', 1, true) then
            local templates = {}
            for start, template in id:gmatch('()`([^`]+)`') do
                ---@cast start any
                local tempGeneric = block.genericMap[template]
                if tempGeneric then
                    self:throw('UNDEFINED_GENERIC', pos + start, pos + start + #template)
                else
                    templates[template] = tempGeneric
                end
            end
            res.genericTemplate = templates
        end
    end

    return res
end
