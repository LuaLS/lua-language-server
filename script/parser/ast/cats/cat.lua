
require 'parser.ast.cats.id'
require 'parser.ast.cats.class'
require 'parser.ast.cats.type'
require 'parser.ast.cats.union'
require 'parser.ast.cats.intersection'
require 'parser.ast.cats.function'
require 'parser.ast.cats.table'
require 'parser.ast.cats.boolean'
require 'parser.ast.cats.integer'
require 'parser.ast.cats.string'

---@class LuaParser.Node.Cat: LuaParser.Node.Base
---@field subtype string
---@field symbolPos integer # @的位置
---@field attrPos1? integer # 左括号的位置
---@field attrPos2? integer # 右括号的位置
---@field attrs? LuaParser.Node.CatAttr[]
---@field value? LuaParser.Node.CatValue
---@field extends? LuaParser.Node.CatType
---@field tail? string
local Cat = Class('LuaParser.Node.Cat', 'LuaParser.Node.Base')

---@alias LuaParser.Node.CatValue
---| LuaParser.Node.CatClass
---| LuaParser.Node.CatType

---@class LuaParser.Node.CatAttr: LuaParser.Node.Base
---@field id string
local CatAttr = Class('LuaParser.Node.CatAttr', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
Ast.catParserMap = {}

---@private
---@param catType string
---@param parser fun(self: LuaParser.Ast)
function Ast:registerCatParser(catType, parser)
    Ast.catParserMap[catType] = parser
end

Ast:registerCatParser('class', Ast.parseCatClass)
Ast:registerCatParser('type',  function (self)
    ---@diagnostic disable-next-line: invisible
    return self:parseCatType(true)
end)

---@private
---@return boolean
function Ast:skipCat()
    if self:skipMultiLineCatHead()
    or self:parseCat()
    or self:parseCatBlock() then
        return true
    else
        return false
    end
end

---@private
---@return boolean
function Ast:skipMultiLineCatHead()
    if self.status ~= 'ShortCats' then
        return false
    end
    -- 下1个token是 `NL`，下2个token是 `---` 但不是 `---@`
    local _, nlType = self.lexer:peek(1)
    if nlType ~= 'NL' then
        return false
    end
    local token, _, pos = self.lexer:peek(2)
    if token ~= '--' then
        return false
    end
    if self.code:sub(pos + 1, pos + 3) ~= '---'
    or self.code:sub(pos + 4, pos + 4) == '@' then
        return false
    end
    self.lexer:fastForward(pos + 3)
    return true
end

-- 会将解析结果存放到 `Ast.cats` 中
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

    local parser = Ast.catParserMap[cat.subtype]
    if parser then
        local value = parser(self)
        if value then
            cat.value = value
            value.parent = cat
        end
    end

    cat.finish = self:getLastPos()

    cat.tail = self:parseTail()

    self.status = oldStatus

    return cat
end

-- 会将解析结果存放到 `Ast.cats` 中
function Ast:parseCatBlock()
    
end

---@return string?
function Ast:parseTail()
    local startOffset = self:getLastPos() + 1
    local tail = self.code:match('[^\r\n]+', startOffset)
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
