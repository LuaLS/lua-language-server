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
            else
                return '{}[{}]' % { lastName, 'unknown' }
            end
            return nil
        end
    end
    return nil
end


---@class Coder.Variable
---@field name string
--- 当前变量使用的key，key一定代表一个 Node.Variable
---@field currentKey string

---@class Coder.Flow.Stack
local S = Class 'Coder.Flow.Stack'

---@param coder Coder
function S:__init(coder)
    self.coder = coder
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
    return self:getVarByName(name, create and self.coder:makeVarKey(source) or nil)
end

---@param name string
---@param createKey? string
---@return Coder.Variable?
function S:getVarByName(name, createKey)
    local var = self.variables[name]
    if not var then
        if not createKey then
            return nil
        end
        var = {
            name = name,
            currentKey = createKey,
        }
        self.variables[name] = var
    end
    return var
end

---@param name string
---@param key string
---@return Coder.Variable
function S:setVarKeyByName(name, key)
    local var = self.variables[name]
    if not var then
        var = {
            name = name,
            currentKey = key,
        }
        self.variables[name] = var
    else
        var.currentKey = key
    end
    return var
end

---@param coder Coder
function M:__init(coder)
    self.coder = coder
    ---@type Coder.Flow.Stack[]
    self.stacks = {}

    self:pushStack()
end

---@return Coder.Flow.Stack
function M:pushStack()
    local newStack = New 'Coder.Flow.Stack' (self.coder)
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
    local name = getName(source)
    if not name then
        return nil
    end
    if create then
        local stack = self:currentStack()
        return stack:getVarByName(name, self.coder:makeVarKey(source))
    else
        return self:getVarByName(name)
    end
end

---@param name string
---@param createKey? string
---@return Coder.Variable?
function M:getVarByName(name, createKey)
    if createKey then
        local stack = self:currentStack()
        return stack:getVarByName(name, createKey)
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
    local var = self:getVar(source, true)
    if not var then
        return nil
    end
    return var.currentKey
end

---@param source LuaParser.Node.AssignAble
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

---@return Coder.Branch
function M:createBranch()
    local branch = New 'Coder.Branch' (self)
    return branch
end
