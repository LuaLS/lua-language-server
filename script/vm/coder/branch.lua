---@class Coder.Branch
local M = Class 'Coder.Branch'

---@class Coder.Branch.Child
local C = Class 'Coder.Branch.Child'

---@param branch Coder.Branch
---@param index integer
---@param callback fun()
function C:__init(branch, index, callback)
    self.branch = branch
    self.index = index
    self.callback = callback
    ---@type table<string, string>
    self.varKeyAfterNarrow = {}
    ---@type table<string, string>
    self.valueAfterNarrow = {}
    ---@type table<string, string>
    self.otherSideValueAfterNarrow = {}
    ---@type table<string, string>
    self.otherSideVarKeyAfterNarrow = {}
    ---@type table<string, LuaParser.Node.Base>
    self.narrowReasons = {}
end

---@package
---@param exp LuaParser.Node.Base
---@return boolean
function C:checkCondition(exp)
    self:tryTruly(exp)

    if exp.kind == 'binary' then
        ---@cast exp LuaParser.Node.Binary
        if exp.op == '==' and exp.exp1 and exp.exp2 then
            return self:tryEqual(exp.exp1:trim(), exp.exp2:trim())
                or self:tryEqual(exp.exp2:trim(), exp.exp1:trim())
        end
    end

    return false
end

---@param exp LuaParser.Node.Base
---@param method string
---@return boolean
function C:narrow(exp, method)
    local var = self.branch.flow:getVar(exp)

    if not var then
        return false
    end
    self.branch:careVar(var.name, var.currentKey)

    -- truly
    local value = self.branch.coder:getCustomKey('narrow|{}|{}' % { self.index, exp.uniqueKey })
    self.branch.coder:addLine('{narrow} = rt.narrow({value}):{method}' % {
        narrow = value,
        value  = self:getValueBeforeNarrow(var.name),
        method = method,
    })
    local shadow = self.branch.coder:getCustomKey('shadow|{}|{}' % { self.index, exp.uniqueKey })
    self.branch.coder:addLine('{shadow} = {var}:shadow({value})' % {
        shadow = shadow,
        var    = self:getVarKeyBeforeNarrow(var.name),
        value  = value,
    })
    self.varKeyAfterNarrow[var.name] = shadow
    self.valueAfterNarrow[var.name]  = value
    self.narrowReasons[var.name] = exp

    return true
end

---@package
---@param exp LuaParser.Node.Base
---@return boolean
function C:tryTruly(exp)
    return self:narrow(exp, 'truly()')
end

---@package
---@param exp LuaParser.Node.Base
---@param other LuaParser.Node.Base
---@return boolean
function C:tryEqual(exp, other)
    return self:narrow(exp, 'equalValue({other})' % {
        other = self.branch.coder:getKey(other),
    })
end

---@param name string
---@return string
function C:getVarKeyBeforeNarrow(name)
    local lastChild = self.branch.childs[self.index - 1]
    if lastChild then
        return lastChild:getOtherSideVarKeyAfterNarrow(name)
    end
    local currentVar = self.branch.flow:getVarByName(name)
    assert(currentVar)
    return currentVar.currentKey
end

---@param name string
---@return string
function C:getValueBeforeNarrow(name)
    local lastChild = self.branch.childs[self.index - 1]
    if lastChild then
        return lastChild:getOtherSideValueAfterNarrow(name)
    end
    local currentVar = self.branch.flow:getVarByName(name)
    assert(currentVar)
    return currentVar.currentKey
end

---@param name string
---@return string
function C:getOtherSideValueAfterNarrow(name)
    if not self.otherSideValueAfterNarrow[name] then
        local reason = self.narrowReasons[name]
        if not reason then
            return self:getValueBeforeNarrow(name)
        end
        local value = self.valueAfterNarrow[name]
        local otherSide = self.branch.coder:getCustomKey('narrow-os|{}|{}' % { self.index, reason.uniqueKey })
        self.branch.coder:addLine('{other} = {value}:otherSide()' % {
            other = otherSide,
            value = value,
        })
        self.otherSideValueAfterNarrow[name] = otherSide
    end
    return self.otherSideValueAfterNarrow[name]
end

---@param name string
---@return string
function C:getOtherSideVarKeyAfterNarrow(name)
    if not self.otherSideVarKeyAfterNarrow[name] then
        local reason = self.narrowReasons[name]
        if not reason then
            return self:getVarKeyBeforeNarrow(name)
        end
        local value = self:getOtherSideValueAfterNarrow(name)
        local shadow = self.branch.coder:getCustomKey('shadow-os|{}|{}' % { self.index, reason.uniqueKey })
        self.branch.coder:addLine('{shadow} = {var}:shadow({value})' % {
            shadow = shadow,
            var    = self:getVarKeyBeforeNarrow(name),
            value  = value,
        })
        self.otherSideVarKeyAfterNarrow[name] = shadow
    end
    return self.otherSideVarKeyAfterNarrow[name]
end

---@param name string
---@return string
function C:getVarKeyAfterNarrow(name)
    return self.varKeyAfterNarrow[name]
        or self:getVarKeyBeforeNarrow(name)
end

---@param name string
---@return string
function C:getVarKeyAfterCallback(name)
    local stackVar = self.callbackStack.variables[name]
    if stackVar then
        return stackVar.currentKey
    end
    return self:getVarKeyAfterNarrow(name)
end

---@param stack Coder.Flow.Stack
function C:preprocessStack(stack)
    self.callbackStack = stack

    for name in ls.util.sortPairs(self.branch.cares) do
        local varKey = self:getVarKeyAfterNarrow(name)
        stack:setVarKeyByName(name, varKey)
    end
end

---@param flow Coder.Flow
---@param node LuaParser.Node.Base
function M:__init(flow, node)
    self.flow = flow
    self.node = node
    self.coder = self.flow.coder
    --- 保存关心的变量及其初始key
    ---@type table<string, string>
    self.cares = {}

    ---@type Coder.Branch.Child[]
    self.childs = {}
end

function M:__close()
    self:finish()
end

---@param condition? LuaParser.Node.Exp
---@param callback fun()
function M:addChild(condition, callback)
    local exp = condition and condition:trim()

    local child = New 'Coder.Branch.Child' (self, #self.childs + 1, callback)
    self.childs[#self.childs+1] = child

    if exp then
        self.coder:compile(exp)
        child:checkCondition(exp)
    end
end

---@package
---@param name string
---@param varKey string
function M:careVar(name, varKey)
    if self.cares[name] then
        return
    end
    self.cares[name] = varKey
end

function M:finish()
    if self.finished then
        return
    end
    self.finished = true

    local function runCallbacks()
        for _, child in ipairs(self.childs) do
            local newStack = self.flow:pushStack()
            child:preprocessStack(newStack)
            child.callback()
            self.flow:popStack()
        end
    end

    local function collectChangedVars()
        ---@type table<string, boolean>
        local changed = {}
        for name in ls.util.sortPairs(self.cares) do
            for _, child in ipairs(self.childs) do
                local before = child:getVarKeyAfterNarrow(name)
                local after  = child:getVarKeyAfterCallback(name)
                if before ~= after then
                    changed[name] = true
                end
            end
        end
        return changed
    end

    ---@param changed table<string, boolean>
    local function applyChangedVars(changed)
        for name in ls.util.sortPairs(changed) do
            local unions = {}
            for i, child in ipairs(self.childs) do
                unions[i] = child:getVarKeyAfterCallback(name)
            end
            local valueKey = self.coder:getCustomKey('value-apply|{}|{}' % { name, self.node.uniqueKey })
            self.coder:addLine('{value} = rt.union { {unions} }' % {
                value  = valueKey,
                unions = table.concat(unions, ', '),
            })
            local shadowKey = self.coder:getCustomKey('shadow-apply|{}|{}' % { name, self.node.uniqueKey })
            self.coder:addLine('{shadow} = {var}:shadow({value})' % {
                shadow = shadowKey,
                var    = self.cares[name],
                value  = valueKey,
            })
            self.flow:setVarKeyByName(name, shadowKey)
        end
    end

    runCallbacks()

    local changedVars = collectChangedVars()

    applyChangedVars(changedVars)
end
