local parser = require 'parser'

---@class VM.Coder.Flow
local M = Class 'VM.Coder.Flow'

---@class VM.Coder.Variable
---@field name string
---@field currentKey? string

---@class VM.Coder.Flow.Stack
local S = Class 'VM.Coder.Flow.Stack'

function S:__init()
    ---@type table<string, VM.Coder.Variable>
    self.variables = {}
end

function M:__init()
    ---@type VM.Coder.Flow.Stack[]
    self.stacks = {}

    self:pushStack()
end

function M:pushStack()
    self.stacks[#self.stacks+1] = New 'VM.Coder.Flow.Stack' ()
end

function M:popStack()
    local lastStack = table.remove(self.stacks)
end

function M:currentStack()
    return self.stacks[#self.stacks]
end

---@param source LuaParser.Node.AssignAble
---@param create? boolean
---@return VM.Coder.Variable?
function M:getVar(source, create)
    local name = self:getName(source)
    if not name then
        return nil
    end
    if create then
        local stack = self:currentStack()
        local var = stack.variables[name]
        if not var then
            var = {
                name = name,
            }
            stack.variables[name] = var
        end
        return var
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

---@param var LuaParser.Node.AssignAble
---@return string?
function M:getName(var)
    if var.kind == 'local' or var.kind == 'param' then
        return '{}@{}:{}' % {
            var.id,
            var.startRow,
            var.startCol,
        }
    end
    if var.kind == 'var' then
        ---@cast var LuaParser.Node.Var
        if var.loc then
            return self:getName(var.loc)
        end
        if var.env then
            local envName = self:getName(var.env)
            if not envName then
                return nil
            end
            return '{}.{}' % { envName, var.id }
        end
        return '_G.{}' % { var.id }
    end
    if var.kind == 'field' then
        ---@cast var LuaParser.Node.Field
        local parentName = self:getName(var.parent)
        if not parentName then
            return nil
        end
        local key = var.key
        if var.subtype == 'field' or var.subtype == 'method' then
            ---@cast key LuaParser.Node.FieldID
            return '{}.{}' % { parentName, key.id }
        end
        if var.subtype == 'index' then
            ---@cast key LuaParser.Node.Exp
            if key.isLiteral then
                ---@cast key LuaParser.Node.Literal
                local value = key.value
                if type(value) == 'string' then
                    if parser.isName(value) then
                        return '{}.{}' % { parentName, value }
                    else
                        return '{}[{%q}]' % { parentName, value }
                    end
                else
                    return '{}[{}]' % { parentName, tostring(value) }
                end
            end
            return nil
        end
    end
end
