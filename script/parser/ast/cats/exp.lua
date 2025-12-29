
---@alias LuaParser.Node.CatExp
---| LuaParser.Node.CatID
---| LuaParser.Node.CatParen
---| LuaParser.Node.CatArray
---| LuaParser.Node.CatIndex
---| LuaParser.Node.CatCall
---| LuaParser.Node.CatUnion
---| LuaParser.Node.CatIntersection
---| LuaParser.Node.CatFunction
---| LuaParser.Node.CatTable
---| LuaParser.Node.CatBoolean
---| LuaParser.Node.CatInteger
---| LuaParser.Node.CatString
---| LuaParser.Node.CatTuple
---| LuaParser.Node.CatFCall
---| LuaParser.Node.CatTernary

---@class LuaParser.Node.CatParen: LuaParser.Node.ParenBase
---@field value? LuaParser.Node.CatExp
---@field symbolPos? integer # 右括号的位置
local CatParen = Class('LuaParser.Node.CatParen', 'LuaParser.Node.ParenBase')

CatParen.kind = 'catparen'

function CatParen:trim()
    if not self.value then
        return self
    end
    return self.value:trim()
end

---@class LuaParser.Node.CatArray: LuaParser.Node.Base
---@field node LuaParser.Node.CatExp
---@field symbolPos1 integer # 左括号的位置
---@field symbolPos2? integer # 右括号的位置
local CatArray = Class('LuaParser.Node.CatArray', 'LuaParser.Node.Base')

CatArray.kind = 'catarray'

---@class LuaParser.Node.CatIndex: LuaParser.Node.Base
---@field node LuaParser.Node.CatExp
---@field symbolPos1 integer # 左括号的位置
---@field symbolPos2? integer # 右括号的位置
---@field index? LuaParser.Node.CatExp
local CatIndex = Class('LuaParser.Node.CatIndex', 'LuaParser.Node.Base')

CatIndex.kind = 'catindex'

---@class LuaParser.Node.CatCall: LuaParser.Node.Base
---@field node LuaParser.Node.CatID
---@field args LuaParser.Node.CatExp[]
---@field symbolPos1 integer # 左括号的位置
---@field symbolPos2? integer # 右括号的位置
local CatCall = Class('LuaParser.Node.CatCall', 'LuaParser.Node.Base')

CatCall.kind = 'catcall'

---@class LuaParser.Node.CatFCall: LuaParser.Node.Base
---@field head LuaParser.Node.CatExp
---@field args LuaParser.Node.CatExp[]
---@field symbolPos1 integer # 左括号的位置
---@field symbolPos2? integer # 右括号的位置
local CatFCall = Class('LuaParser.Node.CatFCall', 'LuaParser.Node.Base')

CatFCall.kind = 'catfcall'

---@class LuaParser.Node.CatTernary: LuaParser.Node.Base
---@field cond LuaParser.Node.CatExp
---@field thenExp LuaParser.Node.CatExp
---@field elseExp LuaParser.Node.CatExp
---@field symbolPos1 integer # ? 的位置
---@field symbolPos2 integer # : 的位置
local CatTernary = Class('LuaParser.Node.CatTernary', 'LuaParser.Node.Base')

CatTernary.kind = 'catternary'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param required? boolean
---@return LuaParser.Node.CatExp?
function Ast:parseCatExp(required)
    local catType = self:parseCatTernary(required)
    return catType
end

---@private
---@param required? boolean
---@return LuaParser.Node.CatExp?
function Ast:parseCatTernary(required)
    local cond = self:parseCatUnion(required)
    if not cond then
        return nil
    end

    self:skipSpace()
    if self.lexer:peek() == '?' then
        local nextToken, nextType = self.lexer:peek(1)
        local isTernaryHead = (nextType == 'Word' or nextType == 'Num'
            or nextToken == '(' or nextToken == '{' or nextToken == '['
            or nextToken == '"' or nextToken == '\'' or nextToken == '-')

        if isTernaryHead then
            local posQ = self.lexer:consume '?'
            self:skipSpace()
            local thenExp = self:parseCatExp(true)
            self:skipSpace()
            local posColon = self.lexer:consume ':'
            if posColon and thenExp then
                self:skipSpace()
                local elseExp = self:parseCatExp(true)
                if elseExp then
                    local tern = self:createNode('LuaParser.Node.CatTernary', {
                        start = cond.start,
                        cond = cond,
                        thenExp = thenExp,
                        elseExp = elseExp,
                        symbolPos1 = posQ,
                        symbolPos2 = posColon,
                    })
                    cond.parent = tern
                    thenExp.parent = tern
                    elseExp.parent = tern
                    tern.finish = self:getLastPos()
                    return tern
                end
            end
        end
    end

    return cond
end

---@private
---@param required? boolean
---@return LuaParser.Node.CatExp?
function Ast:parseCatTerm(required)
    local head = self:parseCatParen()
            or   self:parseCatFunction()
            or   self:parseCatTable()
            or   self:parseCatTuple()
            or   self:parseCatBoolean()
            or   self:parseCatInteger()
            or   self:parseCatString()
            or   self:parseCatID(true)

    if not head then
        if required then
            self:throw('MISS_CAT_NAME', self:getLastPos())
        end
        return nil
    end

    ---@type LuaParser.Node.CatExp
    local current = head
    while true do
        self:skipSpace()

        local chain = self:parseCatArray(current)
                or    self:parseCatIndex(current)
                or    self:parseCatCall(current)
                or    self:parseCatFCall(current)

        if chain then
            current = chain
        else
            break
        end
    end

    -- 可选标记：消费 '?' 前先 peek 下一个 token，判断是否可能为三元的开始
    self:skipSpace()
    if self.lexer:peek() == '?' then
        local nextToken, nextType = self.lexer:peek(1)
        local isTernaryHead =  nextType == 'Word'
                            or nextType == 'Num'
                            or nextToken == '('
                            or nextToken == '{'
                            or nextToken == '['
                            or nextToken == '"'
                            or nextToken == '\''
                            or nextToken == '-'

        if not isTernaryHead then
            -- 下一个 token 不像类型开始，消费 '?' 作为可选后缀
            self.lexer:consume '?'
            current.optional = true
        end
        -- 否则留给上层（交集解析）处理三元
    end

    return current
end

---@private
---@param atLeastOne? boolean
---@return LuaParser.Node.CatExp[]
function Ast:parseCatTypeList(atLeastOne)
    return self:parseList(atLeastOne, false, self.parseCatExp)
end

---@private
---@return LuaParser.Node.CatParen?
function Ast:parseCatParen()
    local plPos = self.lexer:consume '('
    if not plPos then
        return nil
    end

    self:skipSpace()
    local value = self:parseCatExp(true)
    local paren = self:createNode('LuaParser.Node.CatParen', {
        start = plPos,
        value = value,
    })

    if value then
        value.parent = paren
    end

    self:skipSpace()
    paren.symbolPos = self:assertSymbol ')'
    paren.finish    = self:getLastPos()

    return paren
end

---@private
---@param head LuaParser.Node.CatExp
---@return LuaParser.Node.CatArray?
function Ast:parseCatArray(head)
    if self.lexer:peek(0) ~= '['
    or self.lexer:peek(1) ~= ']' then
        return nil
    end
    local pos1 = self.lexer:consume '['
    if not pos1 then
        return nil
    end
    local array = self:createNode('LuaParser.Node.CatArray', {
        start = head.start,
        node = head,
        symbolPos1 = pos1,
    })

    head.parent = array

    array.symbolPos2 = self:assertSymbol ']'
    array.finish = self:getLastPos()

    return array
end

---@private
---@param head LuaParser.Node.CatExp
---@return LuaParser.Node.CatIndex?
function Ast:parseCatIndex(head)
    local pos1 = self.lexer:consume '['
    if not pos1 then
        return nil
    end
    local index = self:createNode('LuaParser.Node.CatIndex', {
        start = head.start,
        node = head,
        symbolPos1 = pos1,
    })

    head.parent = index

    self:skipSpace()
    index.index = self:parseCatExp(true)

    index.symbolPos2 = self:assertSymbol ']'
    index.finish = self:getLastPos()

    return index
end

---@private
---@param head LuaParser.Node.CatExp
---@return LuaParser.Node.CatCall?
function Ast:parseCatCall(head)
    local pos1 = self.lexer:consume '<'
    if not pos1 then
        return nil
    end

    local call = self:createNode('LuaParser.Node.CatCall', {
        start = head.start,
        node  = head,
        symbolPos1 = pos1,
    })
    head.parent = call

    self:skipSpace()
    local args = self:parseCatTypeList(true)
    call.args = args

    for i = 1, #args do
        local arg = args[i]
        arg.parent = call
    end

    self:skipSpace()
    call.symbolPos2 = self:assertSymbol '>'
    call.finish = self:getLastPos()

    if head.kind ~= 'catid' then
        self:throw('UNEXPECT_CAT_CALL', pos1, call.finish)
    end

    return call
end

---@private
---@param head LuaParser.Node.CatExp
---@return LuaParser.Node.CatFCall?
function Ast:parseCatFCall(head)
    local pos1 = self.lexer:consume '('
    if not pos1 then
        return nil
    end
    local fcall = self:createNode('LuaParser.Node.CatFCall', {
        start = head.start,
        head  = head,
        symbolPos1 = pos1,
    })
    head.parent = fcall

    self:skipSpace()
    local args = self:parseCatTypeList(true)
    fcall.args = args

    for i = 1, #args do
        local arg = args[i]
        arg.parent = fcall
    end

    self:skipSpace()
    fcall.symbolPos2 = self:assertSymbol ')'
    fcall.finish = self:getLastPos()

    return fcall
end
