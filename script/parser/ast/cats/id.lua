
---@class LuaParser.Node.CatID: LuaParser.Node.Base
---@field id string
---@field asCode? boolean # 作为自动完成使用的代码。废弃特性
---@field generic? LuaParser.Node.CatGeneric
---@field genericTemplate? table<string, LuaParser.Node.CatGeneric?>
local CatID = Class('LuaParser.Node.CatID', 'LuaParser.Node.Base')

CatID.kind = 'catid'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param asExp? boolean
---@return LuaParser.Node.CatID?
function Ast:parseCatID(asExp)
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

    if id:sub(1, 1) == '`' and id:sub(-1) == '`' then
        local generic = block and block.genericMap[id:sub(2, -2)]
        if not generic then
            res.asCode = true
        end
    end

    if not res.asCode and block and asExp then
        local generic = block.genericMap[id]
        if generic then
            res.generic = generic
        end
        if id:find('`', 1, true) then
            local templates = {}
            for start, template in id:gmatch('()`([^`]+)`') do
                ---@cast start any
                local tempGeneric = block.genericMap[template]
                if tempGeneric then
                    templates[template] = tempGeneric
                else
                    self:throw('UNDEFINED_GENERIC', pos + start, pos + start + #template)
                end
            end
            res.genericTemplate = templates
        end
    end

    return res
end
