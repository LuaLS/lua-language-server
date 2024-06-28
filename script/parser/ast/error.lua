
---@class LuaParser.Node.Error: LuaParser.Node.Base
---@field extra? table
local Error = Class('LuaParser.Node.Error', 'LuaParser.Node.Base')

Error.code = 'UNKNOWN'

---@class LuaParser.Ast
---@field extra? table
local Ast = Class 'LuaParser.Ast'

-- 添加错误信息
---@param errorCode string
---@param start integer
---@param finish integer?
---@param extra table?
function Ast:throw(errorCode, start, finish, extra)
    self.errors[#self.errors+1] = self:createNode('LuaParser.Node.Error', {
        code   = errorCode,
        start  = start,
        finish = finish or start,
        extra  = extra,
    })
end

-- 添加错误“缺少符号”
---@param start integer
---@param symbol string
function Ast:throwMissSymbol(start, symbol)
    self:throw('MISS_SYMBOL', start, start, {
        symbol = symbol,
    })
end

-- 添加错误“缺少表达式”
---@param start integer
function Ast:throwMissExp(start)
    self:throw('MISS_EXP', start, start)
end

-- 断言下个符号，如果成功则消耗，否则报错
---@private
---@param symbol string
---@return integer? pos
function Ast:assertSymbol(symbol)
    local pos = self.lexer:consume(symbol)
    if not pos then
        self:throwMissSymbol(self:getLastPos(), symbol)
    end
    return pos
end

-- 断言下个符号是 `end`，如果成功则消耗，否则报错
---@private
---@param relatedStart integer
---@param relatedFinish integer
---@return integer? pos
function Ast:assertSymbolEnd(relatedStart, relatedFinish)
    local pos = self.lexer:consume 'end'
    if not pos then
        local lastPos = self:getLastPos()
        self:throw('MISS_SYMBOL', lastPos, lastPos, {
            symbol = 'end',
            related = {
                start = relatedStart,
                finish = relatedFinish,
            }
        })
        self:throw('MISS_END', relatedStart, relatedFinish, {
            start = lastPos,
            finish = lastPos,
        })
    end
    return pos
end

---@private
---@param needThrowMissSymbol? boolean
---@return integer? pos
function Ast:assertSymbolThen(needThrowMissSymbol)
    local pos = self.lexer:consume 'then'
    if pos then
        return pos
    end
    pos = self.lexer:consume 'do'
    if pos then
        self:throw('ERR_THEN_AS_DO', pos, pos + #'do')
        return pos
    end
    if needThrowMissSymbol then
        self:throwMissSymbol(self:getLastPos(), 'then')
    end
    return nil
end

---@private
---@param needThrowMissSymbol? boolean
---@return integer? pos
function Ast:assertSymbolDo(needThrowMissSymbol)
    local pos = self.lexer:consume 'do'
    if pos then
        return pos
    end
    pos = self.lexer:consume 'then'
    if pos then
        self:throw('ERR_DO_AS_THEN', pos, pos + #'then')
        return pos
    end
    if needThrowMissSymbol then
        self:throwMissSymbol(self:getLastPos(), 'do')
    end
    return nil
end
