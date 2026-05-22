---@class Node.FCall: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node, args: Node[]): Node.FCall
local M = ls.node.register 'Node.FCall'

M.kind = 'fcall'

---@type Node
M.head = nil

---@param scope Scope
---@param head Node
---@param args Node[]
function M:__init(scope, head, args)
    self.scope = scope
    self.head = head
    self.args = args
end

---@type Node
M.value = nil

---@param self Node.FCall
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.rt.NEVER
    return self.returns, true
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:select(key)
    return self.returns:select(key)
end

---@type Node
M.returns = nil

---@param var Node.Variable
---@return boolean
local function isUndefinedGlobalVariable(var)
    if var:isDefined() then
        return false
    end
    local rt = var.scope.rt
    local current = var.masterVariable or var
    for _ = 1, 100 do
        local parent = current.parent
        if not parent then
            return false
        end
        if parent == rt.VAR_G then
            return true
        end
        if parent.kind ~= 'variable' then
            return false
        end
        ---@cast parent Node.Variable
        current = parent
    end
    return false
end

---@param var Node.Variable
---@return boolean
local function isFieldOfUndefinedGlobal(var)
    local current = var.masterVariable or var
    local parent = current.parent
    if not parent or parent.kind ~= 'variable' then
        return false
    end
    ---@cast parent Node.Variable
    return isUndefinedGlobalVariable(parent)
end

---@param head Node
---@return boolean
local function shouldUseUnknownForAnyHead(head)
    if head.kind == 'select' then
        ---@cast head Node.Select
        local selectHead = head.head
        if selectHead.kind == 'variable' then
            ---@cast selectHead Node.Variable
            return isUndefinedGlobalVariable(selectHead)
        end
        return false
    end
    if head.kind == 'variable' then
        ---@cast head Node.Variable
        return isFieldOfUndefinedGlobal(head)
    end
    return false
end

---@type Node.Function[]
M.matchedFuncs = nil

---@param self Node.FCall
---@return Node.Function[]
---@return true
M.__getter.matchedFuncs = function (self)
    local rt = self.scope.rt
    ---@type Node.Function[]
    local defs = {}
    local args = rt.list(self.args)

    self.head:addRef(self)
    args:addRef(self)

    if shouldUseUnknownForAnyHead(self.head) then
        return {}, true
    end

    self.head:each('function', function (f)
        ---@cast f Node.Function
        if not f:isDummy() then
            defs[#defs+1] = f
        end
    end)

    if #defs > 1 then
        local filtered = {}
        for _, def in ipairs(defs) do
            if args:canCast(def.paramsPack) then
                filtered[#filtered+1] = def
            end
        end
        if #filtered > 0 then
            defs = filtered
        end
    end

    if #defs == 0 then
        return {}, true
    end

    local allParams = {}
    for i, def in ipairs(defs) do
        local params = ls.util.map(def.paramsDef, function (v)
            local value = v.value
            if value.kind == 'generic' then
                ---@cast value Node.Generic
                return value.extends
            else
                return value
            end
        end)
        allParams[i] = params
    end

    local matches = rt:getBestMatchs(allParams, #self.args)
    local result = {}
    for _, match in ipairs(matches) do
        local f = defs[match]
        result[#result+1] = f:resolveGeneric(f:makeGenericMap(self.args))
    end
    return result, true
end

---@param self Node.FCall
---@return Node
---@return true
M.__getter.returns = function (self)
    local returns = {}
    ---@type integer?, integer|false|nil
    local allMin, allMax

    local rt = self.scope.rt
    local matchedFuncs = self.matchedFuncs

    if #matchedFuncs == 0 then
        local headFinal = self.head:finalValue()
        if headFinal.kind == 'type' then
            ---@cast headFinal Node.Type
            if headFinal.typeName == 'any' then
                if shouldUseUnknownForAnyHead(self.head) then
                    return rt.UNKNOWN, true
                end
                return rt.ANY, true
            end
            if headFinal.typeName == 'unknown' then
                return rt.UNKNOWN, true
            end
        end
        return rt.UNKNOWN, true
    end

    for _, f in ipairs(matchedFuncs) do
        local min, max = f:getReturnCount()
        if not allMin or allMin < min then
            allMin = min
        end
        if not max then
            allMax = false
        elseif allMax and allMax < max then
            allMax = max
        end
    end
    for _, f in ipairs(matchedFuncs) do
        for i = 1, allMin do
            returns[i] = returns[i] | (f:getReturn(i) or rt.NIL)
        end
    end

    local list = rt.list(returns, allMin, allMax)
    return list, true
end

function M:onView(viewer, options)
    return '{}({})' % {
        viewer:view(self.head, {
            needParentheses = true,
        }),
        table.concat(ls.util.map(self.args, function (arg)
            return viewer:view(arg)
        end), ', '),
    }
end
