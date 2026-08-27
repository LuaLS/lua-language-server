
---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@alias LuaParser.Node.ID
---| LuaParser.Node.Local
---| LuaParser.Node.Var
---| LuaParser.Node.FieldID
---| LuaParser.Node.TableFieldID
---| LuaParser.Node.Param
---| LuaParser.Node.LabelName
---| LuaParser.Node.AttrName
---| LuaParser.Node.CatAttr
---| LuaParser.Node.CatFuncParamName
---| LuaParser.Node.CatFuncReturnName
---| LuaParser.Node.CatSeeName

---@private
---@generic T: LuaParser.Node.ID
---@param nodeType `T`
---@param required? boolean
---@param canBeKeyword?
---| 'yes' # 可以是关键字，用于处理软关键字
---| 'no' # 不可以是关键字，解析到此中断
---| 'warn' # 语法上不可以是关键字，但解析时视为软关键字（保证不引发歧义）并给出诊断
---@param includeVarargs? boolean
---@return T?
function Ast:parseID(nodeType, required, canBeKeyword, includeVarargs)
    local token, tp, pos = self.lexer:peek()
    if token == '...' and includeVarargs then
        self.lexer:next()
        return self:createNode(nodeType or 'LuaParser.Node.Var', {
            id     = token,
            start  = pos,
            finish = pos + #token,
        })
    end
    if tp ~= 'Word' then
        if required then
            self:throw('MISS_NAME', self:getLastPos())
        end
        return nil
    end
    ---@cast token -?
    ---@cast pos -?
    if self:isKeyWord(token) then
        if canBeKeyword == 'warn' then
            self:throw('KEYWORD', pos, pos + #token)
        elseif canBeKeyword == 'no' or canBeKeyword == nil then
            if required then
                self:throw('MISS_NAME', self:getLastPos())
            end
            return nil
        end
    end
    if self:isReservedWord(token) then
        if required or canBeKeyword == 'warn' then
            self:throw('RESERVED_WORD', pos, pos + #token)
        else
            return nil
        end
    end
    if not self.unicodeName and self.status ~= 'Cats' and token:find '[\x80-\xff]' then
        self:throw('UNICODE_NAME', pos, pos + #token)
    end
    self.lexer:next()
    return self:createNode(nodeType or 'LuaParser.Node.Var', {
        id     = token,
        start  = pos,
        finish = pos + #token,
    })
end

---@private
---@generic T: LuaParser.Node.ID
---@param nodeType `T`
---@param atLeastOne? boolean
---@param greedy? boolean
---@return T[]
function Ast:parseIDList(nodeType, atLeastOne, greedy)
    return self:parseList(atLeastOne, greedy, function (_, required)
        return self:parseID(nodeType, required)
    end)
end

-- goto 单独处理（LuaJIT 中 goto 是语境关键字，仅在 `goto Word` 形态视为关键字；
-- Lua 5.2+ goto 是保留字，Lua 5.1 中是普通标识符）
---@private
---@param word string
---@return boolean
function Ast:isKeyWord(word)
    if word == 'goto' then
        if self.jit then
            local _, nextType = self.lexer:peek(1)
            return nextType == 'Word'
        end
        return self.versionNum >= 52
    end
    return ls.guide.isKeyWord(word, self.version)
end

---@private
---@param word string
---@return boolean
function Ast:isReservedWord(word)
    return ls.guide.isReservedWord(word)
end
