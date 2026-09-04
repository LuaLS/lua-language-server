local class = require'class'

---@class LuaParser.Node.CatUnion: LuaParser.Node.Base
---@field poses integer[] # 所有 | 的位置
---@field exps LuaParser.Node.CatExp[] # 所有的子表达式
local Union = Class('LuaParser.Node.CatUnion', 'LuaParser.Node.Base')

Union.kind = 'catunion'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param required? boolean
---@return LuaParser.Node.CatExp?
function Ast:parseCatUnion(required)
    self:skipSpace()
    if self.lexer:consume '|' then
        self:skipSpace()
    end

    local first = self:parseCatIntersection(required)
    if not first then
        return nil
    end

    self:parseCatDescription(first)

    local pos = self.lexer:consume '|'
    if not pos then
        return first
    end

    ---@type LuaParser.Node.CatUnion
    local union = self:createNode('LuaParser.Node.CatUnion', {
        start = first.start,
        poses = { pos },
        exps  = { first },
    })


    while true do
        self:skipSpace()
        local nextNode = self:parseCatIntersection(true)
        union.exps[#union.exps+1] = nextNode

        self:parseCatDescription(nextNode)

        self:skipSpace()
        local nextPos = self.lexer:consume '|'
        if not nextPos then
            break
        end

        union.poses[#union.poses+1] = nextPos
    end

    union.finish = self:getLastPos()

    return union
end

---@private
---@param node LuaParser.Node.CatExp?
function Ast:parseCatDescription(node)
    if not self.lexer:consume '#' then
        return
    end
    if node then
        local tail = self.code:match('^[^|&\r\n]+', self:getLastPos() + 1)
        if tail then
            node.desc = tail:gsub('^%s+', ''):gsub('%s+$', '')
        end
    end
    while true do
        local token = self.lexer:peek()
        if not token
        or token == '|'
        or token == '&'
        or token == 'NL' then
            break
        end
        if token == '#'
        or token == '@' then
            break
        end
        if token == '-' then
            local j = 0
            while self.lexer:peek(j) == '-' do j = j + 1 end
            local nt = self.lexer:peek(j)
            if nt == '|' or nt == '&' then
                self.lexer:next()
            else
                break
            end
        else
            self.lexer:next()
        end
    end
end
