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

    local first = self:parseCatSubtract(required)
    if not first then
        return nil
    end

    self:parseCatDescription(first)

    self:skipSpace()
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
        local nextNode = self:parseCatSubtract(true)
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
---@param node LuaParser.Node.Base?
function Ast:parseCatDescription(node)
    if not self.lexer:consume '#' then
        return
    end
    if node then
        local tail = self.code:match('^[^\r\n]+', self:getLastPos() + 1)
        if tail then
            node.desc = tail:gsub('^%s+', ''):gsub('%s+$', '')
        end
    end
    -- 描述一直吃到行尾；只有跨行的续行前缀（`---|` / `---&`）才把 `|`/`&` 交还给 union
    local dashes = 0
    while true do
        local token, tp = self.lexer:peek()
        if not token
        or tp == 'NL' then
            break
        end
        if token == '|'
        or token == '&' then
            if dashes >= 2 then
                break
            end
            dashes = 0
            self.lexer:next()
        elseif token == '-' then
            local j = 0
            while self.lexer:peek(j) == '-' do j = j + 1 end
            local nt = self.lexer:peek(j)
            if nt == '|' or nt == '&' then
                dashes = dashes + 1
                self.lexer:next()
            else
                break
            end
        else
            dashes = 0
            self.lexer:next()
        end
    end
end
