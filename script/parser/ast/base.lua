local class = require 'class'

---@class LuaParser.Node.Base: Class.Base
---@field type string
---@field ast LuaParser.Ast
---@field start integer # 开始位置（偏移）
---@field finish integer # 结束位置（偏移）
---@field left integer # 开始位置（行号与列号合并）
---@field right integer # 结束位置（行号与列号合并）
---@field startRow integer # 开始行号
---@field startCol integer # 开始列号
---@field finishRow integer # 结束行号
---@field finishCol integer # 结束列号
---@field code string # 对应的代码
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
---@field index? integer
local Base = class.declare 'LuaParser.Node.Base'

---@type boolean
Base.isBlock = false

---@type boolean
Base.isFunction = false

---@type boolean
Base.isLiteral = false

local rowcolMulti = 10000

---@param self LuaParser.Node.Base
---@return string
---@return true
Base.__getter.type = function (self)
    return class.type(self):match '[^.]+$', true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.left = function (self)
    local row, col = self.ast.lexer:rowcol(self.start)
    local start = row * rowcolMulti + col
    return start, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.right = function (self)
    local row, col = self.ast.lexer:rowcol(self.finish)
    local finish = row * rowcolMulti + col
    return finish, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.startRow = function (self)
    local startRow = self.left // rowcolMulti
    return startRow, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.startCol = function (self)
    local startCol = self.left % rowcolMulti
    return startCol, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.finishRow = function (self)
    local finishRow = self.right // rowcolMulti
    return finishRow, true
end

---@param self LuaParser.Node.Base
---@return integer
---@return true
Base.__getter.finishCol = function (self)
    local finishCol = self.right % rowcolMulti
    return finishCol, true
end

---@param self LuaParser.Node.Base
---@return string
---@return true
Base.__getter.code = function (self)
    local code = self.ast.code:sub(self.start + 1, self.finish)
    return code, true
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

---@class LuaParser.Node.Literal: LuaParser.Node.Base
---@field value? nil|boolean|number|string|integer
local Literal = class.declare('LuaParser.Node.Literal', 'LuaParser.Node.Base')

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
