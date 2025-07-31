
---@class LuaParser.Node.Param: LuaParser.Node.Local
---@field parent LuaParser.Node.Function
---@field index integer
---@field id string
---@field isSelf? boolean
local Param = Class('LuaParser.Node.Param', 'LuaParser.Node.Local')

Param.kind = 'param'

---@alias LuaParser.Node.FuncName
---| LuaParser.Node.Var
---| LuaParser.Node.Field
---| LuaParser.Node.Local

---@class LuaParser.Node.Function: LuaParser.Node.Block
---@field name? LuaParser.Node.FuncName
---@field params? LuaParser.Node.Local[]
---@field symbolPos1? integer # 左括号
---@field symbolPos2? integer # 右括号
---@field symbolPos3? integer # `end`
local Function = Class('LuaParser.Node.Function', 'LuaParser.Node.Block')

Function.kind = 'function'
Function.isFunction = true

function Function.__getter.referFunction(self)
    return self, true
end


---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param isLocal? boolean
---@return LuaParser.Node.Function?
function Ast:parseFunction(isLocal)
    local pos = self.lexer:consume 'function'
    if not pos then
        return nil
    end

    self:skipSpace()
    local name
    if isLocal then
        name = self:parseID('LuaParser.Node.Local', true)
        local nextToken, _, nextPos = self.lexer:peek()
        if nextToken == '.' or nextToken == ':' then
            ---@cast nextPos -?
            local endPos = self.code:match('^[%s%w_%.%:]+()', pos + 1)
            self.lexer:moveTo(endPos - 1)
            self:throw('UNEXPECT_LFUNC_NAME', nextPos, endPos - 1)
        end
    else
        name = self:parseFunctionName()
    end

    self:skipSpace()
    local symbolPos1 = self.lexer:consume '('

    local params, symbolPos2
    if symbolPos1 then
        self:skipSpace()
        params = self:parseParamList()
        self:skipSpace()
        symbolPos2 = self:assertSymbol ')'
    else
        self:throwMissSymbol(self:getLastPos(), '(')
    end

    if name and name.subtype == 'method' then
        ---@cast name LuaParser.Node.Field
        if not params then
            params = {}
        end
        table.insert(params, 1, self:createNode('LuaParser.Node.Param', {
            start  = name.last.start,
            finish = name.last.finish,
            dummy  = true,
            isSelf = true,
            id     = 'self',
        }))
    end

    local func = self:createNode('LuaParser.Node.Function', {
        start      = pos,
        name       = name,
        params     = params,
        symbolPos1 = symbolPos1,
        symbolPos2 = symbolPos2,
    })

    if name then
        name.parent = func
        name.value  = func
    end

    if params then
        for i = 1, #params do
            local param = params[i]
            param.parent = func
            param.index  = i
        end
    end

    if symbolPos2 then
        self:skipSpace()
        if isLocal and name then
            ---@cast name LuaParser.Node.Local
            self:initLocal(name)
        end
        self:blockStart(func)
        if params then
            for i = 1, #params do
                self:initLocal(params[i])
            end
        end
        self:blockParseChilds(func)
        self:blockFinish(func)
    end

    self:skipSpace()
    local symbolPos3 = self:assertSymbolEnd(pos, pos + #'function')

    func.symbolPos3 = symbolPos3
    func.finish     = self:getLastPos()

    return func
end

---@private
---@return LuaParser.Node.FuncName?
function Ast:parseFunctionName()
    local head = self:parseVar()

    if not head then
        return nil
    end

    ---@type LuaParser.Node.Var|LuaParser.Node.Field
    local current = head

    while true do
        self:skipSpace()

        local chain = self:parseField(current)

        if chain then
            if  current.kind == 'field'
            and current.subtype == 'method' then
                self:throwMissSymbol(current.finish, '(')
            end

            if chain.subtype == 'index' then
                self:throw('INDEX_IN_FUNC_NAME', chain.symbolPos, chain.finish)
            end

            current = chain
        else
            break
        end
    end

    return current
end

---@private
---@return LuaParser.Node.Param[]
function Ast:parseParamList()
    local list = self:parseList(false, true, self.parseParam)

    for i = 1, #list do
        local param = list[i]
        if param.id == '...' then
            for j = i + 1, #list do
                param = list[j]
                self:throw('ARGS_AFTER_DOTS', param.start, param.finish)
            end
            break
        end
    end

    return list
end

---@private
---@param required? boolean
---@return LuaParser.Node.Param?
function Ast:parseParam(required)
    local pos = self.lexer:consume '...'
    if pos then
        return self:createNode('LuaParser.Node.Param', {
            start  = pos,
            finish = pos + #'...',
            id     = '...',
        })
    end
    local param = self:parseID('LuaParser.Node.Param', required, 'warn')
    if param then
        return param
    end

    local token, tokenType, nextPos = self.lexer:peek()
    if token then
        ---@cast nextPos -?
        if tokenType ~= 'Symbol' then
            self.lexer:next()
            self:throw('UNKNOWN_SYMBOL', nextPos, nextPos + #token)
        end
    end

    return nil
end
