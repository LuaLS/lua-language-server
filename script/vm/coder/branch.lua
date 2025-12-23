---@class Coder.Branch
local M = Class 'Coder.Branch'

---@class Coder.Branch.Child
---@field exp? LuaParser.Node.Base
local C = Class 'Coder.Branch.Child'

---@param branch Coder.Branch
---@param index integer
---@param callback? fun()
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
---@param otherSide? boolean
---@return boolean
function C:checkCondition(exp, otherSide)
    self:tryTruly(exp, otherSide)

    if exp.kind == 'binary' then
        ---@cast exp LuaParser.Node.Binary
        if exp.exp1 and exp.exp2 then
            if exp.op == '==' then
                self:tryEqual(exp.exp1:trim(), exp.exp2:trim(), otherSide)
                self:tryEqual(exp.exp2:trim(), exp.exp1:trim(), otherSide)
            end
            if exp.op == '~=' then
                self:tryEqual(exp.exp1:trim(), exp.exp2:trim(), not otherSide)
                self:tryEqual(exp.exp2:trim(), exp.exp1:trim(), not otherSide)
            end
            if exp.op == 'and' then
                self:tryAndOr(exp, otherSide)
            end
            if exp.op == 'or' then
                self:tryAndOr(exp, otherSide)
            end
        end
    end

    if exp.kind == 'unary' then
        ---@cast exp LuaParser.Node.Unary
        if exp.exp then
            if exp.op == 'not' then
                local innerExp = exp.exp:trim()
                self:checkCondition(innerExp, not otherSide)
            end
        end
    end

    return false
end

---@package
---@param exp LuaParser.Node.Base
---@param otherSide? boolean
function C:tryAndOr(exp, otherSide)
    local branch = self.branch.flow:getBranch(exp)
    if not branch then
        return
    end
    for name in pairs(branch.cares) do
        self.branch:careVar(name, self:getVarKeyBeforeNarrow(name))
        self.narrowReasons[name]     = branch:getNarrowReasons(name)
        self.valueAfterNarrow[name]  = branch:getValueAfterNarrow(name)
        self.varKeyAfterNarrow[name] = branch:getVarKeyAfterNarrow(name)
        self.otherSideValueAfterNarrow[name]  = branch:getOtherSideValueAfterNarrow(name)
        self.otherSideVarKeyAfterNarrow[name] = branch:getOtherSideVarKeyAfterNarrow(name)

        if otherSide then
            -- 交换正反两侧
            self.valueAfterNarrow[name], self.otherSideValueAfterNarrow[name] =
            self.otherSideValueAfterNarrow[name], self.valueAfterNarrow[name]
            self.varKeyAfterNarrow[name], self.otherSideVarKeyAfterNarrow[name] =
            self.otherSideVarKeyAfterNarrow[name], self.varKeyAfterNarrow[name]
        end
    end
end

---@param exp? LuaParser.Node.Base
---@param method string
---@param otherSide? boolean
---@return boolean
function C:narrow(exp, method, otherSide)
    if not exp then
        return false
    end
    local var = self.branch.flow:getVar(exp)

    if not var then
        return false
    end
    self.branch:careVar(var.name, var.currentKey)

    -- truly
    local value = self.branch.coder:getCustomKey('narrow|{mode}|{index}|{uniqueKey}' % {
        mode = self.branch.mode,
        index = self.index,
        uniqueKey = exp.uniqueKey,
    })
    self.branch.coder:addLine('{narrow} = rt.narrow({value}):{method}{otherSide}' % {
        narrow = value,
        value  = self:getValueBeforeNarrow(var.name),
        method = method,
        otherSide = otherSide and ':otherSide()' or '',
    })
    local shadow = self.branch.coder:getCustomKey('shadow|{mode}|{index}|{uniqueKey}' % {
        mode = self.branch.mode,
        index = self.index,
        uniqueKey = exp.uniqueKey,
    })
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
---@param otherSide? boolean
function C:tryTruly(exp, otherSide)
    self:narrow(exp, 'truly()', otherSide)

    -- 根据字段来收窄类型
    if exp.kind == 'field' then
        ---@cast exp LuaParser.Node.Field
        local fieldCode = self.branch.coder:makeFieldCode(exp.key)
        if fieldCode then
            self:narrow(exp.last, 'matchField({key}, rt.TRULY)' % {
                key   = fieldCode,
            }, otherSide)
        end
    end
end

---@package
---@param exp LuaParser.Node.Base
---@param other LuaParser.Node.Base
---@param otherSide? boolean
function C:tryEqual(exp, other, otherSide)
    -- 收窄整个变量的类型
    self:narrow(exp, 'equalValue({other})' % {
        other = self.branch.coder:getKey(other),
    }, otherSide)

    -- 根据字段值来收窄类型
    if exp.kind == 'field' then
        ---@cast exp LuaParser.Node.Field
        local fieldCode = self.branch.coder:makeFieldCode(exp.key)
        if fieldCode then
            self:narrow(exp.last, 'matchField({key}, {other})' % {
                key   = fieldCode,
                other = self.branch.coder:getKey(other),
            }, otherSide)
        end
    end
end

---@param name string
---@return string
function C:getVarKeyBeforeNarrow(name)
    local lastChild = self.branch.childs[self.index - 1]
    if lastChild then
        if self.branch.mode == 'if' then
            return lastChild:getOtherSideVarKeyAfterNarrow(name)
        end
        if self.branch.mode == 'and' then
            return lastChild:getVarKeyAfterNarrow(name)
        end
        if self.branch.mode == 'or' then
            return lastChild:getOtherSideVarKeyAfterNarrow(name)
        end
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
        if self.branch.mode == 'if' then
            return lastChild:getOtherSideValueAfterNarrow(name)
        end
        if self.branch.mode == 'and' then
            return lastChild:getValueAfterNarrow(name)
        end
        if self.branch.mode == 'or' then
            return lastChild:getOtherSideValueAfterNarrow(name)
        end
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
        local otherSide = self.branch.coder:getCustomKey('narrow-os|{mode}|{index}|{uniqueKey}' % {
            mode = self.branch.mode,
            index = self.index,
            uniqueKey = reason.uniqueKey,
        })
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
        local shadow = self.branch.coder:getCustomKey('shadow-os|{mode}|{index}|{uniqueKey}' % {
            mode = self.branch.mode,
            index = self.index,
            uniqueKey = reason.uniqueKey,
        })
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
function C:getValueAfterNarrow(name)
    return self.valueAfterNarrow[name]
        or self:getValueBeforeNarrow(name)
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
---@param mode 'if' | 'and' | 'or'
function M:__init(flow, node, mode)
    self.flow = flow
    self.node = node
    self.mode = mode
    self.coder = self.flow.coder
    --- 保存关心的变量及其初始key
    ---@type table<string, string>
    self.cares = {}

    ---@type Coder.Branch.Child[]
    self.childs = {}

    ---@type table<string, string>
    self.varKeyAfterNarrow = {}
    ---@type table<string, string>
    self.valueAfterNarrow = {}
    ---@type table<string, string>
    self.otherSideValueAfterNarrow = {}
    ---@type table<string, string>
    self.otherSideVarKeyAfterNarrow = {}
end

function M:__close()
    self:finish()
end

---@param condition? LuaParser.Node.Exp
---@param callback? fun()
---@return Coder.Branch
function M:addChild(condition, callback)
    local exp = condition and condition:trim()

    local child = New 'Coder.Branch.Child' (self, #self.childs + 1, callback)
    self.childs[#self.childs+1] = child

    if exp then
        child.exp = exp
        self.coder:compile(exp)
        child:checkCondition(exp)
    end

    return self
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

---@param name string
---@return LuaParser.Node.Base?
function M:getNarrowReasons(name)
    local child = self.childs[#self.childs]
    if not child then
        return nil
    end
    return child.narrowReasons[name]
end

---@param name string
---@return string?
function M:getValueAfterNarrow(name)
    local child = self.childs[#self.childs]
    if not child then
        return nil
    end
    if self.mode == 'if' or self.mode == 'and' then
        return child:getValueAfterNarrow(name)
    end
    if self.mode == 'or' then
        if not self.valueAfterNarrow[name] then
            local reason = self.childs[1].narrowReasons[name]
                        or self.childs[2].narrowReasons[name]
            if not reason then
                return self.childs[1]:getValueBeforeNarrow(name)
            end
            local value1 = self.childs[1]:getValueAfterNarrow(name)
            local value2 = self.childs[2]:getValueAfterNarrow(name)
            local value = self.coder:getCustomKey('narrow|{mode}|{index}|{name}|{uniqueKey}' % {
                mode = self.mode,
                index = '*',
                name  = name,
                uniqueKey = self.node.uniqueKey,
            })
            self.coder:addLine('{value} = {value1} | {value2}' % {
                value  = value,
                value1 = value1,
                value2 = value2,
            })
            self.valueAfterNarrow[name] = value
        end
        return self.valueAfterNarrow[name]
    end
end

---@param name string
---@return string?
function M:getVarKeyAfterNarrow(name)
    local child = self.childs[#self.childs]
    if not child then
        return nil
    end
    if self.mode == 'if' or self.mode == 'and' then
        return child:getVarKeyAfterNarrow(name)
    end
    if self.mode == 'or' then
        if not self.varKeyAfterNarrow[name] then
            local reason = self.childs[1].narrowReasons[name]
                        or self.childs[2].narrowReasons[name]
            if not reason then
                return self.childs[1]:getVarKeyBeforeNarrow(name)
            end
            local value = self:getValueAfterNarrow(name)
            local shadow = self.coder:getCustomKey('shadow|{mode}|{index}|{name}|{uniqueKey}' % {
                mode = self.mode,
                index = '*',
                name  = name,
                uniqueKey = self.node.uniqueKey,
            })
            self.coder:addLine('{shadow} = {var}:shadow({value})' % {
                shadow = shadow,
                var    = self.childs[1]:getVarKeyBeforeNarrow(name),
                value  = value,
            })
            self.varKeyAfterNarrow[name] = shadow
        end
        return self.varKeyAfterNarrow[name]
    end
end

---@param name string
---@return string?
function M:getOtherSideValueAfterNarrow(name)
    local child = self.childs[#self.childs]
    if not child then
        return nil
    end
    if self.mode == 'if' or self.mode == 'or' then
        return child:getOtherSideValueAfterNarrow(name)
    end
    if self.mode == 'and' then
        if not self.otherSideValueAfterNarrow[name] then
            local reason = self.childs[1].narrowReasons[name]
                        or self.childs[2].narrowReasons[name]
            if not reason then
                return self.childs[1]:getValueBeforeNarrow(name)
            end
            local value1 = self.childs[1]:getOtherSideValueAfterNarrow(name)
            local value2 = self.childs[2]:getOtherSideValueAfterNarrow(name)
            local otherSide = self.coder:getCustomKey('narrow-os|{mode}|{index}|{name}|{uniqueKey}' % {
                mode = self.mode,
                index = '*',
                name  = name,
                uniqueKey = self.node.uniqueKey,
            })
            self.coder:addLine('{other} = {value2} | {value1}' % {
                other = otherSide,
                value1 = value1,
                value2 = value2,
            })
            self.otherSideValueAfterNarrow[name] = otherSide
        end
        return self.otherSideValueAfterNarrow[name]
    end
end

---@return string
function M:getValue()
    local child = self.childs[#self.childs]
    if not child then
        return 'rt.UNKNOWN'
    end
    if not child.exp then
        return 'rt.UNKNOWN'
    end
    return self.coder:getKey(child.exp)
end

---@param name string
---@return string?
function M:getOtherSideVarKeyAfterNarrow(name)
    local child = self.childs[#self.childs]
    if not child then
        return nil
    end
    if self.mode == 'if' or self.mode == 'or' then
        return child:getOtherSideVarKeyAfterNarrow(name)
    end
    if self.mode == 'and' then
        if not self.otherSideVarKeyAfterNarrow[name] then
            local reason = self.childs[1].narrowReasons[name]
                        or self.childs[2].narrowReasons[name]
            if not reason then
                return self.childs[1]:getVarKeyBeforeNarrow(name)
            end
            local value = self:getOtherSideValueAfterNarrow(name)
            local shadow = self.coder:getCustomKey('shadow-os|{mode}|{index}|{name}|{uniqueKey}' % {
                mode = self.mode,
                index = '*',
                name  = name,
                uniqueKey = self.node.uniqueKey,
            })
            self.coder:addLine('{shadow} = {var}:shadow({value})' % {
                shadow = shadow,
                var    = self.childs[1]:getVarKeyBeforeNarrow(name),
                value  = value,
            })
            self.otherSideVarKeyAfterNarrow[name] = shadow
        end
        return self.otherSideVarKeyAfterNarrow[name]
    end
end

---@return Coder.Branch
function M:finish()
    if self.finished then
        return self
    end
    self.finished = true

    local function runCallbacks()
        for _, child in ipairs(self.childs) do
            if child.callback then
                local newStack = self.flow:pushStack()
                child:preprocessStack(newStack)
                child.callback()
                self.flow:popStack()
            end
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
            local valueKey = self.coder:getCustomKey('value-apply|{mode}|{name}|{uniqueKey}' % {
                mode = self.mode,
                name = name,
                uniqueKey = self.node.uniqueKey,
            })
            self.coder:addLine('{value} = rt.union { {unions} }' % {
                value  = valueKey,
                unions = table.concat(unions, ', '),
            })
            local shadowKey = self.coder:getCustomKey('shadow-apply|{mode}|{name}|{uniqueKey}' % {
                mode = self.mode,
                name = name,
                uniqueKey = self.node.uniqueKey,
            })
            self.coder:addLine('{shadow} = {var}:shadow({value})' % {
                shadow = shadowKey,
                var    = self.cares[name],
                value  = valueKey,
            })
            self.flow:setVarKeyByName(name, shadowKey)
        end
    end

    if self.mode == 'if' then
        runCallbacks()

        local changedVars = collectChangedVars()

        applyChangedVars(changedVars)
    end

    return self
end
