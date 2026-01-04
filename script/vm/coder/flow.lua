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
            var.startRow + 1,
            var.startCol + 1,
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
        if not key then
            return nil
        end
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

---@class Coder.Variable.Link
---@field func LuaParser.Node.Base
---@field args LuaParser.Node.Base[]
---@field rets LuaParser.Node.Base[]

---@class Coder.Flow.Stack
local S = Class 'Coder.Flow.Stack'

---@param coder Coder
function S:__init(coder)
    self.coder = coder
    ---@type table<string, Coder.Variable>
    self.variables = {}
end

---@param source LuaParser.Node.Base
---@return Coder.Variable?
function S:getVar(source)
    local name = getName(source)
    if not name then
        return nil
    end
    return self:getVarByName(name)
end

---@param name string
---@return Coder.Variable?
function S:getVarByName(name)
    local var = self.variables[name]
    return var
end

---@param source LuaParser.Node.Base
---@return Coder.Variable?
function S:createVar(source)
    local name = getName(source)
    if not name then
        return nil
    end
    local key = self.coder:makeVarKey(source)
    local var = {
        name = name,
        currentKey = key,
    }
    self.variables[name] = var
    self.coder:saveVariable(name, key, source.effectStart)
    return var
end

---@param name string
---@param varKey string
---@param offset integer
---@return Coder.Variable
function S:setVarKeyByName(name, varKey, offset)
    local var = self.variables[name]
    if not var then
        var = {
            name = name,
            currentKey = varKey,
        }
        self.variables[name] = var
    else
        var.currentKey = varKey
    end
    self.coder:saveVariable(name, varKey, offset)
    return var
end

---@param coder Coder
function M:__init(coder)
    self.coder = coder
    ---@type Coder.Flow.Stack[]
    self.stacks = {}
    ---@type table<LuaParser.Node.Base, Coder.Branch>
    self.nodeBranches = {}
    --- 当前变量通过函数调用和其它变量的关联信息，用于远程收窄关联变量的类型
    ---@type table<string, Coder.Variable.Link[]>
    self.links = {}

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
---@return Coder.Variable?
function M:getVar(source)
    local name = getName(source)
    if not name then
        return nil
    end
    return self:getVarByName(name)
end

---@param source LuaParser.Node.Base
---@return Coder.Variable?
function M:getOrCreateVar(source)
    local var = self:getVar(source)
    if var then
        return var
    end
    local stack = self:currentStack()
    return stack:createVar(source)
end

---@param name string
---@return Coder.Variable?
function M:getVarByName(name)
    for i = #self.stacks, 1, -1 do
        local stack = self.stacks[i]
        local var = stack.variables[name]
        if var then
            return var
        end
    end
    return nil
end

---@param name string
---@param varKey string
---@param offset integer
function M:setVarKeyByName(name, varKey, offset)
    local stack = self:currentStack()
    stack:setVarKeyByName(name, varKey, offset)
end

---@param source LuaParser.Node.AssignAble
---@return Coder.Variable?
function M:createVar(source)
    local stack = self:currentStack()
    local var = stack:createVar(source)
    return var
end

---@param source LuaParser.Node.AssignAble
---@param varKey string
---@return boolean
function M:setVarKey(source, varKey)
    local name = getName(source)
    if not name then
        return false
    end
    self:setVarKeyByName(name, varKey, source.effectStart)
    return true
end

---@param source LuaParser.Node.Base
---@return string?
function M:getVarName(source)
    return getName(source)
end

---@param source LuaParser.Node.Base
---@param link Coder.Variable.Link
function M:addLink(source, link)
    local name = getName(source)
    if not name then
        return
    end
    local links = self.links[name]
    if not links then
        links = {}
        self.links[name] = links
    end
    links[#links+1] = link
end

---@param link Coder.Variable.Link
function M:addLinks(link)
    for _, arg in ipairs(link.args) do
        self:addLink(arg, link)
    end
    for _, ret in ipairs(link.rets) do
        self:addLink(ret, link)
    end
end

---@param source LuaParser.Node.Base
---@return Coder.Variable.Link[]?
function M:getLinks(source)
    local name = getName(source)
    if not name then
        return nil
    end
    return self.links[name]
end

---@param source LuaParser.Node.Base
---@return string?
function M:getOrCreateVarKey(source)
    local var = self:getOrCreateVar(source)
    if not var then
        return nil
    end
    return var.currentKey
end

---@param source LuaParser.Node.Base
---@return string?
function M:getVarKey(source)
    local var = self:getVar(source)
    if not var then
        return nil
    end
    return var.currentKey
end

---@param name string
---@return string?
function M:getVarKeyByName(name)
    local var = self:getVarByName(name)
    if var then
        return var.currentKey
    end
    return nil
end

---@param node LuaParser.Node.Base
---@param mode 'if' | 'and' | 'or'
---@return Coder.Branch
function M:createBranch(node, mode)
    local branch = New 'Coder.Branch' (self, node, mode)
    self.nodeBranches[node] = branch
    return branch
end

---@param node LuaParser.Node.Base
---@return Coder.Branch?
function M:getBranch(node)
    return self.nodeBranches[node]
end
