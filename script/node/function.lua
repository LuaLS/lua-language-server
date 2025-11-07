---@class Node.Function: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope): Node.Function
local M = ls.node.register 'Node.Function'

M.kind = 'function'

---@class Node.Function.Param
---@field key string
---@field value Node
---@field optional? boolean

---@class Node.Function.Return
---@field key? string
---@field value Node
---@field optional? boolean

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    ---@type Node.Function.Param[]
    self.paramsDef = {}
    ---@type Node.Function.Return[]
    self.returnsDef = {}

    ---@type table<string, Node>
    self.paramDefMap = {}
    ---@type table<string, Node>
    self.returnDefMap = {}

    ---@type Node.List[]
    self.returnList = {}
end

function M:setAsync()
    self.async = true
    return self
end

---@param location Node.Location
---@return Node.Function
function M:setLocation(location)
    self.location = location
    return self
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if other.typeName == 'function' then
        return true
    end
end

---@type Node.List
M.paramsPack = nil

---@param self Node.Function
---@return Node.List
---@return true
M.__getter.paramsPack = function (self)
    local rt = self.scope.rt
    local params = ls.util.map(self.paramsDef, function (v, k)
        local value = v.value
        if v.optional then
            value = value | rt.NIL
        end
        return value
    end)
    local min = #params
    ---@type integer | false
    local max = #params
    if self.varargParamDef then
        params[#params+1] = self.varargParamDef
        max = false
    end

    return rt.list(params, min, max), true
end

---@type Node.List
M.returnsPack = nil

---@param self Node.Function
---@return Node.List
---@return true
M.__getter.returnsPack = function (self)
    local rt = self.scope.rt

    if #self.returnsDef > 0 then
        local returns = ls.util.map(self.returnsDef, function (v, k)
            local value = v.value
            value:addRef(self)
            if v.optional then
                value = value | rt.NIL
            end
            return value
        end)
        return rt.list(returns), true
    else
        local maxReturn = 0
        for _, list in ipairs(self.returnList) do
            list:addRef(self)
            if #list.values > maxReturn then
                maxReturn = #list.values
            end
        end
        local returns = {}
        if maxReturn == 0 then
            return rt.list(), true
        end
        for i = 1, maxReturn do
            local unionValues = {}
            for _, list in ipairs(self.returnList) do
                local value = list:select(i)
                unionValues[#unionValues+1] = value
            end
            returns[i] = rt.union(unionValues)
        end
        ---@type integer | false
        local allMax = maxReturn
        for _, list in ipairs(self.returnList) do
            local max = list.max
            if max then
                if allMax and allMax < max then
                    allMax = max
                end
            else
                allMax = false
            end
        end
        return rt.list(returns, nil, allMax), true
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.typeName == 'function' then
        return true
    end
    if other.kind == 'function' then
        ---@cast other Node.Function
        if not self.paramsPack:canCast(other.paramsPack) then
            return false
        end
        for i, oreturn in ipairs(other.returnsDef) do
            local ret = self:getReturn(i)
            if not ret then
                return false
            end
            if not ret:canCast(oreturn.value) then
                return false
            end
        end
        return true
    end
    return false
end

---@param key string
---@param value Node
---@param optional? boolean
---@return Node.Function
function M:addParamDef(key, value, optional)
    if key == '...' then
        self:addVarargParamDef(value)
        return self
    end
    self.paramsDef[#self.paramsDef+1] = { key = key, value = value, optional = optional }
    self.paramDefMap[key] = value
    return self
end

---@param key? string
---@param value Node
---@param optional? boolean
---@return Node.Function
function M:addReturnDef(key, value, optional)
    self.returnsDef[#self.returnsDef+1] = { key = key, value = value, optional = optional }
    if key then
        self.returnDefMap[key] = value
    end
    return self
end

---@param list Node.List
---@return Node.Function
function M:addReturnList(list)
    table.insert(self.returnList, list)
    return self
end

---@param value Node
---@return Node.Function
function M:addVarargParamDef(value)
    ---@type Node?
    self.varargParamDef = value
    return self
end

---@param index integer
---@return Node?
function M:getParam(index)
    local n, e = self.paramsPack:select(index)
    if e then
        return n
    end
    return nil
end

---@param index integer
---@return Node?
function M:getReturn(index)
    local n, e = self.returnsPack:select(index)
    if e then
        return n
    end
    return nil
end

---@return integer min
---@return integer? max
function M:getReturnCount()
    return self.returnsPack.min, self.returnsPack.max or nil
end

---@param self Node.Function
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.paramsPack.hasGeneric or self.returnsPack.hasGeneric, true
end

---@type Node[]?
M.typeParams = nil

---@param generic Node.Generic
---@return Node.Function
function M:addTypeParam(generic)
    if not self.typeParams then
        self.typeParams = {}
    end
    table.insert(self.typeParams, generic)
    return self
end

---@param args Node[]
---@return table<Node.Generic, Node>
function M:makeGenericMap(args)
    local map = {}
    if not self.hasGeneric then
        return map
    end
    local rt = self.scope.rt
    local argList = rt.list(args)
    self.paramsPack:inferGeneric(argList, map)
    return map
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local newFunc = self.scope.rt.func()
    if self.typeParams then
        newFunc.typeParams = ls.util.map(self.typeParams, function (v)
            return map[v] or v
        end)
    end
    for i, param in ipairs(self.paramsDef) do
        if param.value.hasGeneric then
            local newValue = param.value:resolveGeneric(map)
            newFunc.paramsDef[i] = { key = param.key, value = newValue }
            newFunc.paramDefMap[param.key] = newValue
        else
            newFunc.paramsDef[i] = param
            newFunc.paramDefMap[param.key] = param.value
        end
    end
    for i, ret in ipairs(self.returnsDef) do
        if ret.value.hasGeneric then
            local newValue = ret.value:resolveGeneric(map)
            newFunc.returnsDef[i] = { key = ret.key, value = newValue }
            if ret.key then
                newFunc.returnDefMap[ret.key] = newValue
            end
        else
            newFunc.returnsDef[i] = ret
            if ret.key then
                newFunc.returnDefMap[ret.key] = ret.value
            end
        end
    end
    if self.varargParamDef then
        if self.varargParamDef.hasGeneric then
            newFunc.varargParamDef = self.varargParamDef:resolveGeneric(map)
        else
            newFunc.varargParamDef = self.varargParamDef
        end
    end
    for i, list in ipairs(self.returnList) do
        newFunc.returnList[i] = list:resolveGeneric(map)
    end
    return newFunc
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    local value = other.value
    if value.kind == 'union' then
        ---@cast value Node.Union
        for _, sub in ipairs(value.values) do
            self:inferGeneric(sub, result)
        end
        return
    end
    local func = value:findValue { 'function' }
    if not func then
        return
    end
    ---@cast func Node.Function
    self.paramsPack:inferGeneric(func.paramsPack, result)
    self.returnsPack:inferGeneric(func.returnsPack, result)
    if self.typeParams then
        for _, param in ipairs(self.typeParams) do
            if param.kind == 'generic' then
                ---@cast param Node.Generic
                if not result[param] then
                    result[param] = self.scope.rt.UNKNOWN
                end
            end
        end
    end
end

function M:onView(viewer, options)
    if viewer.visited[self] > 1 then
        return 'function'
    end
    local params = {}
    for i, v in ipairs(self.paramsDef) do
        params[i] = string.format('%s%s: %s'
            , v.key
            , v.optional and '?' or ''
            , viewer:view(v.value, {
                skipLevel = 10,
            })
        )
    end
    if self.varargParamDef then
        params[#params+1] = string.format('...: %s', viewer:view(self.varargParamDef))
    end

    local returnPart = ''
    if #self.returnsDef > 0 then
        local returns = {}
        for i, v in ipairs(self.returnsDef) do
            if v.key then
                returns[i] = string.format('(%s%s: %s)'
                    , v.key
                    , v.optional and '?' or ''
                    , viewer:view(v.value)
                )
            else
                returns[i] = viewer:view(v.value)
            end
        end
        returnPart = table.concat(returns, ', ')
        if #returns > 1 then
            returnPart = '(' .. returnPart .. ')'
        end
        returnPart = ':' .. returnPart
    elseif #self.returnsPack.values > 0 then
        returnPart = viewer:viewAsList(self.returnsPack, {
            needParentheses = true,
        })
        returnPart = ':' .. returnPart
    end

    local typeParams = ''
    if self.typeParams and #self.typeParams > 0 then
        typeParams = '<' .. table.concat(ls.util.map(self.typeParams, function (v)
            if v.kind == 'generic' then
                ---@cast v Node.Generic
                return viewer:viewAsParam(v)
            end
            return viewer:view(v)
        end), ', ') .. '>'
    end

    local view = string.format('%sfun%s(%s)%s'
        , self.async and 'async ' or ''
        , typeParams
        , table.concat(params, ', ')
        , returnPart
    )
    if options.needParentheses and returnPart ~= '' then
        view = '(%s)' % { view }
    end
    return view
end
