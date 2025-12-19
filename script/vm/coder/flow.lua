local parser = require 'parser'

---@class Coder.Flow
local M = Class 'Coder.Flow'

---@param var LuaParser.Node.Base
---@return string?
local function getName(var)
    if var.kind == 'local' or var.kind == 'param' then
        ---@cast var LuaParser.Node.Local | LuaParser.Node.Param
        return '{}@{}:{}' % {
            var.id,
            var.startRow,
            var.startCol,
        }
    end
    if var.kind == 'var' then
        ---@cast var LuaParser.Node.Var
        if var.loc then
            return getName(var.loc)
        end
        if var.env then
            local envName = getName(var.env)
            if not envName then
                return nil
            end
            return '{}.{}' % { envName, var.id }
        end
        return '_G.{}' % { var.id }
    end
    if var.kind == 'field' then
        ---@cast var LuaParser.Node.Field
        local lastName = getName(var.last)
        if not lastName then
            return nil
        end
        local key = var.key
        if var.subtype == 'field' or var.subtype == 'method' then
            ---@cast key LuaParser.Node.FieldID
            return '{}.{}' % { lastName, key.id }
        end
        if var.subtype == 'index' then
            ---@cast key LuaParser.Node.Exp
            if key.isLiteral then
                ---@cast key LuaParser.Node.Literal
                local value = key.value
                if type(value) == 'string' then
                    if parser.isName(value) then
                        return '{}.{}' % { lastName, value }
                    else
                        return '{}[{%q}]' % { lastName, value }
                    end
                else
                    return '{}[{}]' % { lastName, tostring(value) }
                end
            end
            return nil
        end
    end
    return nil
end


---@class Coder.Variable
---@field name string
--- 当前变量使用的key，key一定代表一个 Node.Variable
---@field currentKey? string
--- 当前变量的收窄结果。再进入下一个分支时需要取 otherSide
---@field narrowedValue? string

---@class Coder.Flow.Stack
local S = Class 'Coder.Flow.Stack'

function S:__init()
    ---@type table<string, Coder.Variable>
    self.variables = {}
end

---@param source LuaParser.Node.Base
---@param create? boolean
---@return Coder.Variable?
function S:getVar(source, create)
    local name = getName(source)
    if not name then
        return nil
    end
    local var = self.variables[name]
    if not var then
        var = {
            name = name,
        }
        self.variables[name] = var
    end
    return var
end

function M:__init()
    ---@type Coder.Flow.Stack[]
    self.stacks = {}

    self:pushStack()
end

---@return Coder.Flow.Stack
function M:pushStack()
    local newStack = New 'Coder.Flow.Stack' ()
    self.stacks[#self.stacks+1] = newStack
    return newStack
end

---@return Coder.Flow.Stack
function M:popStack()
    local lastStack = table.remove(self.stacks)
    return lastStack
end

function M:currentStack()
    return self.stacks[#self.stacks]
end

---@param source LuaParser.Node.Base
---@param create? boolean
---@return Coder.Variable?
function M:getVar(source, create)
    if create then
        local stack = self:currentStack()
        return stack:getVar(source, true)
    end
    local name = getName(source)
    if not name then
        return nil
    end
    for i = #self.stacks, 1, -1 do
        local stack = self.stacks[i]
        local var = stack.variables[name]
        if var then
            return var
        end
    end
    return nil
end

---@param source LuaParser.Node.AssignAble
---@return string?
function M:getVarKey(source)
    local var = self:getVar(source)
    if not var then
        return nil
    end
    return var.currentKey
end

---@param source LuaParser.Node.Base
---@param key string
---@return boolean
function M:setVarKey(source, key)
    local var = self:getVar(source, true)
    if not var then
        return false
    end
    var.currentKey = key
    return true
end
