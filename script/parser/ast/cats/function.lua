
---@class LuaParser.Node.CatFunction: LuaParser.Node.Base, LuaParser.Node.CatGenericMaster, LuaParser.Node.Block
---@field params? LuaParser.Node.CatFuncParam[]
---@field returns? LuaParser.Node.CatFuncReturn[]
---@field funPos      integer # `fun` 的位置
---@field symbolPos1? integer # 左括号的位置
---@field symbolPos2? integer # 右括号的位置
---@field symbolPos3? integer # 冒号的位置
---@field symbolPos4? integer # 返回值左括号的位置
---@field symbolPos5? integer # 返回值右括号的位置
---@field async? boolean # 是否异步
local CatFunction = Class('LuaParser.Node.CatFunction', 'LuaParser.Node.Base')

Extends('LuaParser.Node.CatFunction', 'LuaParser.Node.CatGenericMaster')
Extends('LuaParser.Node.CatFunction', 'LuaParser.Node.Block')

CatFunction.kind = 'catfunction'

---@class LuaParser.Node.CatFuncParam: LuaParser.Node.Base
---@field parent LuaParser.Node.CatFunction
---@field name LuaParser.Node.CatFuncParamName
---@field symbolPos? integer # 冒号的位置
---@field value? LuaParser.Node.CatExp
local CatFuncParam = Class('LuaParser.Node.CatFuncParam', 'LuaParser.Node.Base')

CatFuncParam.kind = 'catfuncparam'

---@class LuaParser.Node.CatFuncParamName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatFuncParam
---@field index integer
---@field id string
local CatFuncParamName = Class('LuaParser.Node.CatFuncParamName', 'LuaParser.Node.Base')

CatFuncParamName.kind = 'catfuncparamname'

---@class LuaParser.Node.CatFuncReturn: LuaParser.Node.Base
---@field parent LuaParser.Node.CatFunction
---@field name? LuaParser.Node.CatFuncReturnName
---@field symbolPos? integer # 冒号的位置
---@field value? LuaParser.Node.CatExp
local CatFuncReturn = Class('LuaParser.Node.CatFuncReturn', 'LuaParser.Node.Base')

CatFuncReturn.kind = 'catfuncreturn'

---@class LuaParser.Node.CatFuncReturnName: LuaParser.Node.Base
---@field parent LuaParser.Node.CatFuncReturn
---@field index integer
---@field id string
---@field name? LuaParser.Node.CatFuncReturnName
---@field value LuaParser.Node.CatExp
---@field symbolPos? integer # 冒号的位置
local CatFuncReturnName = Class('LuaParser.Node.CatFuncReturnName', 'LuaParser.Node.Base')

CatFuncReturnName.kind = 'catfuncreturnname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

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
    })

    self:blockStart(funNode)
    self:parseCatGenericDef(funNode, funNode)

    self:skipSpace()
    funNode.symbolPos1 = self.lexer:consume '('
    if funNode.symbolPos1 then

        self:skipSpace()
        funNode.params = self:parseCatParamList()
        for i, param in ipairs(funNode.params) do
            param.parent = funNode
            param.index = i
        end

        self:skipSpace()
        funNode.symbolPos2 = self:assertSymbol ')'
    end

    self:skipSpace()
    funNode.symbolPos3 = self.lexer:consume ':'
    if funNode.symbolPos3 then

        self:skipSpace()
        funNode.symbolPos4 = self.lexer:consume '('
        self:skipSpace()
        funNode.returns = self:parseCatReturnList()
        for i, ret in ipairs(funNode.returns) do
            ret.parent = funNode
            ret.index = i
        end
        if funNode.symbolPos4 then
            self:skipSpace()
            funNode.symbolPos5 = self:assertSymbol ')'
        end
    end

    funNode.finish = self:getLastPos()
    self:blockFinish(funNode)

    return funNode
end

---@private
---@param required? boolean
---@return LuaParser.Node.CatFuncParam?
function Ast:parseCatFuncParam(required)
    local name

    local pos = self.lexer:consume '...'
    if pos then
        name = self:createNode('LuaParser.Node.CatFuncParamName', {
            start  = pos,
            finish = pos + #'...',
            id     = '...',
        })
    else
        name = self:parseID('LuaParser.Node.CatFuncParamName', required, true)
    end

    if not name then
        return nil
    end

    local param = self:createNode('LuaParser.Node.CatFuncParam', {
        start = name.start,
        name  = name,
    })
    name.parent = param

    self:skipSpace()
    param.symbolPos = self.lexer:consume ':'
    if param.symbolPos then

        self:skipSpace()
        param.value = self:parseCatExp()
        if param.value then
            param.value.parent = param
        end
    end

    param.finish = self:getLastPos()

    return param
end

---@private
---@return LuaParser.Node.CatFuncParam[]
function Ast:parseCatParamList()
    local list = self:parseList(false, false, self.parseCatFuncParam)

    return list
end

---@private
---@param required? boolean
---@return LuaParser.Node.CatFuncReturn?
function Ast:parseCatFuncReturn(required)
    local name

    local pos = self.lexer:consume '...'
    if pos then
        name = self:createNode('LuaParser.Node.CatFuncReturnName', {
            start  = pos,
            finish = pos + #'...',
            id     = '...',
        })
    else
        local _, curType = self.lexer:peek()
        if curType == 'Word' and self.lexer:peek(1) == ':' then
            name = self:parseID('LuaParser.Node.CatFuncReturnName', required, true)
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
        value = self:parseCatExp()
    end

    if not name and not value then
        return nil
    end

    local ret = self:createNode('LuaParser.Node.CatFuncReturn', {
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
---@return LuaParser.Node.CatFuncReturn[]
function Ast:parseCatReturnList()
    local list = self:parseList(false, false, self.parseCatFuncReturn)

    return list
end
