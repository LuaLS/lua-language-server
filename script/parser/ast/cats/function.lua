local class = require 'class'

---@class LuaParser.Node.CatFunction: LuaParser.Node.Base
---@field params LuaParser.Node.CatParam[]
---@field returns LuaParser.Node.CatType[]
---@field funPos      integer # `fun` 的位置
---@field symbolPos1? integer # 左括号的位置
---@field symbolPos2? integer # 右括号的位置
---@field symbolPos3? integer # 冒号的位置
---@field symbolPos4? integer # 返回值左括号的位置
---@field symbolPos5? integer # 返回值右括号的位置
---@field async? boolean # 是否异步
local CatFunction = class.declare('LuaParser.Node.CatFunction', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatParam: LuaParser.Node.Base
---@field parent LuaParser.Node.CatFunction
---@field name LuaParser.Node.CatParamName
---@field symbolPos? integer # 冒号的位置
---@field value? LuaParser.Node.CatType
local CatParam = class.declare('LuaParser.Node.CatParam', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatParamName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatParam
---@field index integer
---@field id string
local CatParamName = class.declare('LuaParser.Node.CatParamName', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatReturn: LuaParser.Node.Base
---@field parent LuaParser.Node.CatFunction
---@field name LuaParser.Node.CatReturnName
---@field symbolPos? integer # 冒号的位置
---@field value? LuaParser.Node.CatType
local CatReturn = class.declare('LuaParser.Node.CatReturn', 'LuaParser.Node.Base')

---@class LuaParser.Node.CatReturnName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatReturn
---@field index integer
---@field id string
local CatReturnName = class.declare('LuaParser.Node.CatReturnName', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@private
function Ast:parseCatFunction()
    local syncPos = self.lexer:consume 'async'
    if syncPos then
        self:skipSpace()
    end

    local funPos = self.lexer:consume 'fun'
    if not funPos then
        return nil
    end

    local funNode = self:createNode('LuaParser.Node.CatFunction', {
        start   = syncPos or funPos,
        async   = syncPos and true or false,
        funPos  = funPos,
        params  = {},
        returns = {},
    })

    self:skipSpace()
    funNode.symbolPos1 = self.lexer:consume '('
    if funNode.symbolPos1 then

        self:skipSpace()
        funNode.params = self:parseCatParamList()
        for _, param in ipairs(funNode.params) do
            param.parent = funNode
        end

        self:skipSpace()
        funNode.symbolPos2 = self:assertSymbol ')'
    end

    self:skipSpace()
    self.symbolPos3 = self.lexer:consume ':'
    if self.symbolPos3 then

        self:skipSpace()
        funNode.symbolPos4 = self.lexer:consume '('
        self:skipSpace()
        funNode.returns = self:parseCatReturnList()
        for _, ret in ipairs(funNode.returns) do
            ret.parent = funNode
        end
        if funNode.symbolPos4 then
            self:skipSpace()
            funNode.symbolPos5 = self:assertSymbol ')'
        end
    end

    funNode.finish = self:getLastPos()

    return funNode
end

---@private
---@param required? boolean
---@return LuaParser.Node.CatParam?
function Ast:parseCatParam(required)
    local name

    local pos = self.lexer:consume '...'
    if pos then
        name = self:createNode('LuaParser.Node.CatParamName', {
            start  = pos,
            finish = pos + #'...',
            id     = '...',
        })
    else
        name = self:parseID('LuaParser.Node.CatParamName', required, true)
    end

    if not name then
        return nil
    end

    local param = self:createNode('LuaParser.Node.CatParam', {
        start = name.start,
        name  = name,
    })
    name.parent = param

    self:skipSpace()
    param.symbolPos = self.lexer:consume ':'
    if param.symbolPos then

        self:skipSpace()
        param.value = self:parseCatType()
        if param.value then
            param.value.parent = param
        end
    end

    param.finish = self:getLastPos()

    return param
end

---@private
---@return LuaParser.Node.CatParam[]
function Ast:parseCatParamList()
    local list = self:parseList(false, false, self.parseCatParam)

    return list
end

---@private
---@param required? boolean
---@return LuaParser.Node.CatReturn?
function Ast:parseCatReturn(required)
    local name

    local pos = self.lexer:consume '...'
    if pos then
        name = self:createNode('LuaParser.Node.CatReturnName', {
            start  = pos,
            finish = pos + #'...',
            id     = '...',
        })
    else
        local _, curType = self.lexer:peek()
        if curType == 'Word' and self.lexer:peek(1) == ':' then
            name = self:parseID('LuaParser.Node.CatReturnName', required, true)
        end
    end


    local symbolPos
    if name then
        self:skipSpace()
        symbolPos = self.lexer:consume ':'
        self:skipSpace()
    end

    local value
    if not name or symbolPos then
        value = self:parseCatType()
    end

    if not name and not value then
        return nil
    end

    local ret = self:createNode('LuaParser.Node.CatReturn', {
        name = name,
        value = value,
        start = (name or value).start,
        symbolPos = symbolPos,
        finish = self:getLastPos(),
    })

    if name then
        name.parent = ret
    end

    if value then
        value.parent = ret
    end

    return ret
end

---@private
---@return LuaParser.Node.CatReturn[]
function Ast:parseCatReturnList()
    local list = self:parseList(false, false, self.parseCatReturn)

    return list
end
