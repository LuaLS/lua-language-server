
---@class LuaParser.Node.Field: LuaParser.Node.Base
---@field subtype 'field' | 'method' | 'index'
---@field safe? boolean # 是否为可选链访问（?. ?: ?[）
---@field key LuaParser.Node.FieldID | LuaParser.Node.Exp
---@field symbolPos integer
---@field symbolPos2? integer
---@field next? LuaParser.Node.Field
---@field last? LuaParser.Node.Term
---@field value? LuaParser.Node.Exp
---@field location? Node.Location
local Field = Class('LuaParser.Node.Field', 'LuaParser.Node.Base')

Field.kind = 'field'

---@return LuaParser.Node.Var?
function Field:getFirstVar()
    local current = self.last
    for _ = 1, 1000 do
        if not current then
            return nil
        end
        if current.kind == 'var' then
            ---@cast current LuaParser.Node.Var
            return current
        end
        current = current.last
    end
end

---@class LuaParser.Node.FieldID: LuaParser.Node.Base
---@field id string
---@field parent LuaParser.Node.Field
local FieldID = Class('LuaParser.Node.FieldID', 'LuaParser.Node.Base')

FieldID.kind = 'fieldid'

---@class LuaParser.Node.TableField: LuaParser.Node.Base
---@field subtype 'field' | 'index' | 'exp'
---@field key? LuaParser.Node.TableFieldID | LuaParser.Node.Exp
---@field value? LuaParser.Node.Exp
---@field symbolPos? integer
---@field symbolPos2? integer
---@field parent LuaParser.Node.Table
local TableField = Class('LuaParser.Node.TableField', 'LuaParser.Node.Base')

TableField.kind = 'tablefield'

---@class LuaParser.Node.TableFieldID: LuaParser.Node.Base
---@field id string
---@field parent LuaParser.Node.TableField
local TableFieldID = Class('LuaParser.Node.TableFieldID', 'LuaParser.Node.Base')

TableFieldID.kind = 'tablefieldid'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@param last LuaParser.Node.Term
---@param onlyDot? boolean
---@return LuaParser.Node.Field?
function Ast:parseField(last, onlyDot)
    local token, _, pos = self.lexer:peek()
    ---@cast pos -?

    -- 可选链：? 后紧跟 . : [ （?. 安全字段 / ?: 无点号安全方法 / ?[ 无点号安全索引）
    if token == '?'
    and not onlyDot then
        local nextToken, _, nextPos = self.lexer:peek(1)

        -- ?. 安全字段访问
        if nextToken == '.'
        and nextPos == pos + 1 then
            if not self.nssymbolMap['?.'] then
                self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + 2, {
                    symbol = '?.',
                })
            end
            self.lexer:next()
            self.lexer:next()
            self:skipSpace()
            local key = self:parseID('LuaParser.Node.FieldID', true, 'warn')
            if key then
                local field = self:createNode('LuaParser.Node.Field', {
                    start     = last.start,
                    finish    = key.finish,
                    subtype   = 'field',
                    safe      = true,
                    key       = key,
                    last      = last,
                    symbolPos = pos,
                })
                last.next   = field
                last.parent = field
                key.parent  = field
                return field
            end
            return nil
        end

        -- ?: 无点号安全方法
        if nextToken == ':'
        and nextPos == pos + 1 then
            if not self.nssymbolMap['?:'] then
                self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + 2, {
                    symbol = '?:',
                })
            end
            self.lexer:next()
            self.lexer:next()
            self:skipSpace()
            local key = self:parseID('LuaParser.Node.FieldID', true, 'warn')
            if key then
                local field = self:createNode('LuaParser.Node.Field', {
                    start     = last.start,
                    finish    = key.finish,
                    subtype   = 'method',
                    safe      = true,
                    key       = key,
                    last      = last,
                    symbolPos = pos,
                })
                last.next   = field
                last.parent = field
                key.parent  = field
                return field
            end
            return nil
        end

        -- ?[ 无点号安全索引
        if nextToken == '['
        and nextPos == pos + 1 then
            if not self.nssymbolMap['?['] then
                self:throw('ERR_NONSTANDARD_SYMBOL', pos, pos + 2, {
                    symbol = '?[',
                })
            end
            self.lexer:next()
            self.lexer:next()
            self:skipSpace()
            local key = self:parseExp(true)
            self:skipSpace()
            local symbolPos2 = self:assertSymbol(']')
            local field = self:createNode('LuaParser.Node.Field', {
                start      = last.start,
                finish     = self:getLastPos(),
                subtype    = 'index',
                safe       = true,
                key        = key,
                last       = last,
                symbolPos  = pos,
                symbolPos2 = symbolPos2,
            })
            last.parent = field
            last.next   = field
            if key then
                key.parent = field
            end
            return field
        end
    end

    if token == '.'
    or (token == ':' and not onlyDot) then
        self.lexer:next()
        self:skipSpace()
        local key = self:parseID('LuaParser.Node.FieldID', true, 'warn')
        if key then
            local field = self:createNode('LuaParser.Node.Field', {
                start      = last.start,
                finish     = key.finish,
                subtype    = (token == '.') and 'field' or 'method',
                key        = key,
                last       = last,
                symbolPos  = pos,
            })
            last.next   = field
            last.parent = field
            key.parent  = field
            return field
        end
        -- 无 key：创建 dummy Field 节点，供补全检测 `var.` / `var:` 场景使用
        local field = self:createNode('LuaParser.Node.Field', {
            start     = last.start,
            finish    = pos + 1,
            subtype   = (token == '.') and 'field' or 'method',
            last      = last,
            symbolPos = pos,
            dummy     = true,
        })
        last.next   = field
        last.parent = field
        return field
    end
    if token == '[' and not onlyDot then
        local nextChar = self.code:sub(pos + 2, pos + 2)
        if nextChar == '['
        or nextChar == '=' then
            -- 长字符串？
            return nil
        end
        self.lexer:next()
        self:skipSpace()
        local key = self:parseExp(true)

        self:skipSpace()
        local symbolPos2 = self:assertSymbol(']')
        local field = self:createNode('LuaParser.Node.Field', {
            start      = last.start,
            finish     = self:getLastPos(),
            subtype    = 'index',
            key        = key,
            last       = last,
            symbolPos  = pos,
            symbolPos2 = symbolPos2,
        })
        last.parent = field
        last.next   = field
        if key then
            key.parent  = field
        end
        return field
    end
    return nil
end

---@private
---@return LuaParser.Node.TableField?
function Ast:parseTableField()
    return self:parseTableFieldAsField()
        or self:parseTableFieldAsIndex()
        or self:parseTableFieldAsExp()
end

---@private
---@return LuaParser.Node.TableField?
function Ast:parseTableFieldAsField()
    local savePoint = self.lexer:savePoint()
    local key = self:parseID('LuaParser.Node.TableFieldID')
    if not key then
        return nil
    end
    self:skipSpace()
    if not self.lexer:consume '=' then
        self:removeNode(key)
        savePoint()
        return nil
    end
    self:skipSpace()
    local value = self:parseExp(true)
    local tfield = self:createNode('LuaParser.Node.TableField', {
        subtype = 'field',
        key     = key,
        value   = value,
        start   = key.start,
        finish  = self:getLastPos(),
    })
    key.parent = tfield
    if value then
        value.parent = tfield
    end
    return tfield
end

---@private
---@return LuaParser.Node.TableField?
function Ast:parseTableFieldAsIndex()
    local token, _, pos = self.lexer:peek()
    if token ~= '[' then
        return nil
    end
    local nextChar = self.code:sub(pos + 2, pos + 2)
    if nextChar == '['
    or nextChar == '=' then
        -- 长字符串？
        return nil
    end
    self.lexer:next()
    self:skipSpace()
    local key = self:parseExp(true)
    self:skipSpace()
    local pos2 = self:assertSymbol ']'
    self:skipSpace()
    local eqPos = self:assertSymbol '='
    local value
    if eqPos then
        self:skipSpace()
        value = self:parseExp(true)
    end
    local tfield = self:createNode('LuaParser.Node.TableField', {
        subtype = 'index',
        key     = key,
        value   = value,
        start   = pos,
        finish  = self:getLastPos(),
        symbolPos  = pos,
        symbolPos2 = pos2,
    })
    if key then
        key.parent = tfield
    end
    if value then
        value.parent = tfield
    end
    return tfield
end

---@private
---@return LuaParser.Node.TableField?
function Ast:parseTableFieldAsExp()
    local exp = self:parseExp()
    if not exp then
        return nil
    end
    local tfield = self:createNode('LuaParser.Node.TableField', {
        subtype = 'exp',
        value   = exp,
        start   = exp.start,
        finish  = exp.finish,
    })
    exp.parent = tfield
    return tfield
end
