
---@class LuaParser.Node.Base: Class.Base
---@field ast LuaParser.Ast
---@field start integer # 开始位置（偏移）
---@field finish integer # 结束位置（偏移）
---@field left integer # 开始位置（行号与列号合并，仅用于测试）
---@field right integer # 结束位置（行号与列号合并，仅用于测试）
---@field where string # 位置描述（仅用于测试）
---@field startRow integer # 开始行号
---@field startCol integer # 开始列号
---@field finishRow integer # 结束行号
---@field finishCol integer # 结束列号
---@field code string # 对应的代码
---@field uniqueKey string # 形如"string@2:10"
---@field parent? unknown
---@field parentBlock LuaParser.Node.Block | false # 向上搜索一个block
---@field parentFunction LuaParser.Node.Function | false # 向上搜索一个function
---@field referBlock LuaParser.Node.Block | false # 如果自己是block，则是自己；否则向上搜索一个block
---@field referFunction LuaParser.Node.Function | false # 如果自己是function，则是自己；否则向上搜索一个function
---@field asNumber? number
---@field asString? string
---@field asBoolean? boolean
---@field asInteger? integer
---@field toNumber? number
---@field toString? string
---@field toInteger? integer
---@field isTruly? boolean
---@field dummy? boolean
---@field optional? boolean
---@field index? integer
local Base = Class 'LuaParser.Node.Base'

---@alias LuaParser.StateKind
---| 'break'
---| 'continue'
---| 'do'
---| 'for'
---| 'function'
---| 'if'
---| 'label'
---| 'goto'
---| 'localdef'
---| 'repeat'
---| 'return'
---| 'assign'
---| 'singleexp'
---| 'while'
---| 'call'

---@alias LuaParser.ExpKind
---| 'local'
---| 'select'
---| 'literal'
---| 'binary'
---| 'boolean'
---| 'call'
---| 'paren'
---| 'float'
---| 'integer'
---| 'string'
---| 'table'
---| 'unary'
---| 'var'
---| 'varargs'

---@alias LuaParser.CatKind
---| 'cat'
---| 'catstateclass'
---| 'catstatefield'
---| 'catstatealias'
---| 'catstateparam'
---| 'catstatereturn'
---| 'catstategeneric'
---| 'catboolean'
---| 'catattr'
---| 'catfunction'
---| 'catfuncparam'
---| 'catfuncparamname'
---| 'catfuncreturn'
---| 'catfuncreturnname'
---| 'catid'
---| 'catinteger'
---| 'catintersection'
---| 'catstring'
---| 'cattable'
---| 'cattablefield'
---| 'cattablefieldid'
---| 'catparen'
---| 'catarray'
---| 'catcall'
---| 'catunion'
---| 'catseename'

---@alias LuaParser.OtherKind
---| 'param'
---| 'ifchild'
---| 'attr'
---| 'attrname'
---| 'block'
---| 'comment'
---| 'error'
---| 'parenbase'
---| 'field'
---| 'fieldid'
---| 'tablefield'
---| 'tablefieldid'
---| 'labelname'
---| 'main'

---@alias LuaParser.Node.AssignAble
---| LuaParser.Node.Local
---| LuaParser.Node.Var
---| LuaParser.Node.Field
---| LuaParser.Node.Param

---@type LuaParser.StateKind | LuaParser.ExpKind | LuaParser.CatKind | LuaParser.OtherKind
Base.kind = nil

---@type boolean
Base.isBlock = false

---@type boolean
Base.isFunction = false

---@type boolean
Base.isLiteral = false

local rowcolMulti = 10000

---@param self LuaParser.Node.Base
---@return integer
Base.__getter.left = function (self)
    local row, col = self.startRow, self.startCol
    local start = row * rowcolMulti + col
    return start
end

---@param self LuaParser.Node.Base
---@return integer
Base.__getter.right = function (self)
    local row, col = self.finishRow, self.finishCol
    local finish = row * rowcolMulti + col
    return finish
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.startRow = function (self)
    self.startRow, self.startCol = self.ast.lexer:rowcol(self.start)
    return self.startRow, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.startCol = function (self)
    self.startRow, self.startCol = self.ast.lexer:rowcol(self.start)
    return self.startCol, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.finishRow = function (self)
    self.finishRow, self.finishCol = self.ast.lexer:rowcol(self.finish)
    return self.finishRow, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.finishCol = function (self)
    self.finishRow, self.finishCol = self.ast.lexer:rowcol(self.finish)
    return self.finishCol, true
end

---@param self LuaParser.Node.Base
---@return string
Base.__getter.where = function (self)
    return string.format('%s:(%s:%s-%s:%s) %s'
        , self.ast.source
        , self.startRow + 1
        , self.startCol
        , self.finishRow + 1
        , self.finishCol
        , self.code
    )
end

---@param self LuaParser.Node.Base
---@return string
Base.__getter.code = function (self)
    local code = self.ast.code:sub(self.start + 1, self.finish)
    return code
end
---@param self LuaParser.Node.Base
---@return string
---@return true
Base.__getter.uniqueKey = function (self)
    if self.dummy then
        return string.format('dummy|%s@%d:%d-%d:%d', self.kind, self.startRow + 1, self.startCol + 1, self.finishRow + 1, self.finishCol), true
    else
        return string.format('%s@%d:%d-%d:%d', self.kind, self.startRow + 1, self.startCol + 1, self.finishRow + 1, self.finishCol), true
    end
end

---@param self LuaParser.Node.Base
---@return LuaParser.Node.Block | false
---@return true
Base.__getter.parentBlock = function (self)
    local parent = self.parent
    if not parent then
        return false, true
    end
    if parent.isBlock then
        return parent, true
    end
    return parent.parentBlock, true
end

---@param self LuaParser.Node.Base
---@return LuaParser.Node.Block | false
---@return true
Base.__getter.referBlock = function (self)
    return self.parentBlock, true
end

---@param self LuaParser.Node.Base
---@return LuaParser.Node.Function | false
---@return true
Base.__getter.parentFunction = function (self)
    local parent = self.parent
    if not parent then
        return false, true
    end
    if parent.isFunction then
        return parent, true
    end
    return parent.parentFunction, true
end

---@param self LuaParser.Node.Base
---@return LuaParser.Node.Function | false
---@return true
function Base.__getter.referFunction(self)
    return self.parentFunction, true
end

function Base:trim()
    return self
end

---@class LuaParser.Node.Literal: LuaParser.Node.Base
---@field value? nil|boolean|number|string|integer
local Literal = Class('LuaParser.Node.Literal', 'LuaParser.Node.Base')

Literal.kind = 'literal'
Literal.isLiteral = true

---@param self LuaParser.Node.Literal
---@return string
---@return true
function Literal.__getter.toString(self)
    return tostring(self.value), true
end

---@param self LuaParser.Node.Literal
---@return number?
---@return true
function Literal.__getter.toNumber(self)
    return tonumber(self.value), true
end

---@param self LuaParser.Node.Literal
---@return integer?
---@return true
function Literal.__getter.tointeger(self)
    return math.tointeger(self.value), true
end

---@param self LuaParser.Node.Literal
---@return boolean
---@return true
function Literal.__getter.isTruly(self)
    return self.value and true or false, true
end
