
require 'parser.ast.cats.generic-master'
require 'parser.ast.cats.id'
require 'parser.ast.cats.generic'
require 'parser.ast.cats.class'
require 'parser.ast.cats.exp'
require 'parser.ast.cats.field'
require 'parser.ast.cats.type'
require 'parser.ast.cats.alias'
require 'parser.ast.cats.union'
require 'parser.ast.cats.intersection'
require 'parser.ast.cats.function'
require 'parser.ast.cats.table'
require 'parser.ast.cats.boolean'
require 'parser.ast.cats.integer'
require 'parser.ast.cats.string'
require 'parser.ast.cats.tuple'
require 'parser.ast.cats.param'
require 'parser.ast.cats.return'

---@class LuaParser.Node.Cat: LuaParser.Node.Base
---@field subtype string
---@field symbolPos integer # @的位置
---@field attrPos1? integer # 左括号的位置
---@field attrPos2? integer # 右括号的位置
---@field attrs? LuaParser.Node.CatAttr[]
---@field value? LuaParser.Node.CatValue
---@field extends? LuaParser.Node.CatExp
---@field tail? string
---@field used? boolean
local Cat = Class('LuaParser.Node.Cat', 'LuaParser.Node.Base')

Cat.kind = 'cat'

---@alias LuaParser.Node.CatValue
---| LuaParser.Node.CatStateClass
---| LuaParser.Node.CatExp
---| LuaParser.Node.CatStateField
---| LuaParser.Node.CatStateAlias
---| LuaParser.Node.CatStateParam
---| LuaParser.Node.CatStateReturn

---@class LuaParser.Node.CatAttr: LuaParser.Node.Base
---@field id string
local CatAttr = Class('LuaParser.Node.CatAttr', 'LuaParser.Node.Base')

CatAttr.kind = 'catattr'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@type table<string, LuaParser.Node.CatConfig>
Ast.catParserMap = {}

---@class LuaParser.Node.CatConfig
---@field asState? boolean
---@field parser fun(self: LuaParser.Ast)

---@private
---@param catType string
---@param config LuaParser.Node.CatConfig
function Ast:registerCatParser(catType, config)
    Ast.catParserMap[catType] = config
end

Ast:registerCatParser('class', {
    asState = true,
    parser = Ast.parseCatStateClass,
})
Ast:registerCatParser('type',  {
    parser = Ast.parseCatStateType,
})
Ast:registerCatParser('field', {
    asState = true,
    parser = Ast.parseCatStateField,
})
Ast:registerCatParser('alias', {
    asState = true,
    parser = Ast.parseCatStateAlias,
})
Ast:registerCatParser('param', {
    asState = true,
    parser = Ast.parseCatStateParam,
})
Ast:registerCatParser('return', {
    asState = true,
    parser = Ast.parseCatStateReturn,
})
Ast:registerCatParser('generic', {
    asState = true,
    parser = Ast.parseCatStateGeneric,
})

---@private
---@return boolean
function Ast:skipCat()
    local cat = self:parseCat()
            or  self:parseCatBlock()
    if not cat then
        return false
    end
    return true
end

---@private
---@return LuaParser.Node.Cat?
function Ast:parseCat()
    local token, _, pos = self.lexer:peek()
    ---@cast pos -?
    if token ~= '--' then
        return nil
    end

    -- 检查 `---@` 开头
    local symbolPos, subtype = self.code:match('^%-[ \t]*()@(%a+)', pos + 3)
    if not symbolPos then
        return nil
    end

    ---@type LuaParser.Status
    local oldStatus = self.status
    if oldStatus == 'Lua' then
        self.status = 'ShortCats'
    elseif oldStatus == 'LongCats' then
    else
        return nil
    end

    local nextPos = symbolPos + #subtype
    self.lexer:fastForward(nextPos)

    local cat = self:createNode('LuaParser.Node.Cat', {
        start = pos,
        subtype = subtype,
        symbolPos = symbolPos - 1,
    })

    if self.code:sub(nextPos + 1, nextPos + 1) == '(' then
        cat.attrPos1 = nextPos
        self.lexer:fastForward(nextPos + 1)
        cat.attrs = self:parseIDList('LuaParser.Node.CatAttr', true, false)
        for _, attr in ipairs(cat.attrs) do
            attr.parent = cat
        end
        cat.attrPos2 = self.lexer:consume ')'
    end

    local config = Ast.catParserMap[cat.subtype]
    if config then
        local value = config.parser(self)
        if value then
            cat.value = value
            value.parent = cat
        end
    end

    cat.finish = self:getLastPos()

    cat.tail = self:parseTail()

    self.status = oldStatus

    local curBlock = self.curBlock
    if curBlock then
        local cats = curBlock.cats
        if not cats then
            cats = {}
            curBlock.cats = cats
        end
        cats[#cats+1] = cat
    end

    return cat
end

---@private
function Ast:parseCatBlock()
    
end

---@private
---@return string?
function Ast:parseTail()
    local startOffset = self:getLastPos() + 1
    local tail = self.code:match('^[^\r\n]+', startOffset)
    if not tail then
        return nil
    end

    self.lexer:fastForward(startOffset + #tail)

    tail = tail:gsub('^%s*[@#]?%s*', '')

    if tail == '' then
        return nil
    end

    return tail
end
