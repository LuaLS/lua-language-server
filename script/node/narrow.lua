---@class Node.Narrow: Node
---@field node Node
---@field narrowType? 'value' | 'field' | 'truly' | 'falsy' | 'equal' | 'param'
---@field nvalue? Node
---@field field? Node.Key
---@field callParams? Node.Narrow.CallParams
local M = ls.node.register 'Node.Narrow'

M.kind = 'narrow'

---@alias Node.Narrow.CallParams [Node, integer, 'equal' | 'match', Node]

---@param scope Scope
---@param node Node
function M:__init(scope, node)
    self.scope = scope
    self.node  = node
end

function M:matchTruly()
    self.narrowType = 'truly'
    return self
end

function M:matchFalsy()
    self.narrowType = 'truly'
    self.isOtherSide = true
    return self
end

---@param value Node
---@return Node.Narrow
function M:matchValue(value)
    self.narrowType = 'value'
    self.nvalue = value
    return self
end

---@param key Node.Key
---@param value Node
---@return Node.Narrow
function M:matchField(key, value)
    self.narrowType = 'field'
    self.field = key
    self.nvalue = value
    return self
end

---@param value Node
---@return Node.Narrow
function M:equalValue(value)
    self.narrowType = 'equal'
    self.nvalue = value
    return self
end

---@param f Node
---@param index integer
---@param mode 'equal' | 'match'
---@param ret Node
---@return self
function M:matchParam(f, index, mode, ret)
    self.narrowType = 'param'
    self.callParams = { f, index, mode, ret }
    return self
end

---@param self Node.Narrow
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.node:addRef(self)
    if self.nvalue then
        self.nvalue:addRef(self)
    end

    return self.node.hasGeneric
        or (self.nvalue and self.nvalue.hasGeneric)
        or false, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local node = self.node:resolveGeneric(map)
    local new = self.scope.rt.narrow(node)
    new.narrowType = self.narrowType
    new.field = self.field
    if self.nvalue then
        new.nvalue = self.nvalue:resolveGeneric(map)
    end
    return new
end

---@type boolean
M.isOtherSide = false

---@param self Node.Narrow
---@return Node
---@return true
M.__getter.value = function (self)
    self.node:addRef(self)
    if self.nvalue then
        self.nvalue:addRef(self)
    end

    local rt = self.scope.rt
    local narrowType = self.narrowType
    local value = self.node
    if self.isOtherSide then
        if narrowType == 'truly' then
            return value.falsy, true
        end
        if narrowType == 'value' then
            local _, otherSide = value:narrow(self.nvalue)
            return otherSide, true
        end
        if narrowType == 'field' then
            local _, otherSide = value:narrowByField(self.field, self.nvalue)
            return otherSide, true
        end
        if narrowType == 'equal' then
            local _, otherSide = value:narrowEqual(self.nvalue)
            return otherSide, true
        end
        if narrowType == 'param' then
            local _, otherSide = self:narrowParam()
            return otherSide, true
        end
        return rt.NEVER, true
    else
        if narrowType == 'truly' then
            return value.truly, true
        end
        if narrowType == 'value' then
            return value:narrow(self.nvalue), true
        end
        if narrowType == 'field' then
            return value:narrowByField(self.field, self.nvalue), true
        end
        if narrowType == 'equal' then
            return value:narrowEqual(self.nvalue), true
        end
        if narrowType == 'param' then
            return self:narrowParam(), true
        end
        return value, true
    end
end

---@return Node.Narrow
function M:otherSide()
    local new = self.scope.rt.narrow(self.node)
    new.narrowType = self.narrowType
    new.field = self.field
    new.nvalue = self.nvalue
    new.callParams = self.callParams
    new.isOtherSide = not self.isOtherSide
    return new
end

---@return Node
---@return Node
function M:narrowParam()
    local rt = self.scope.rt
    local nodeValue = self.node:finalValue()
    if nodeValue == rt.ANY or nodeValue == rt.UNKNOWN then
        return self:narrowParamByRet()
    end
    return self:narrowParamByParam()
end

---@private
---@return Node
---@return Node
function M:narrowParamByRet()
    local rt = self.scope.rt
    local func, index, mode, ret = table.unpack(self.callParams)
    func:addRef(self)
    ret:addRef(self)
    ---@type Node.Function[]
    local defs = {}

    func:each('function', function (f)
        ---@cast f Node.Function
        if f:isDummy() then
            return
        end
        defs[#defs+1] = f
    end)

    local matches = {}
    local notMatches = {}

    -- 参数为any或unknown时，只能根据返回值来匹配原型
    for _, def in ipairs(defs) do
        local res
        local ret1 = def:getReturn(1) or rt.NIL
        if mode == 'match' then
            res = ret1:canCast(ret)
        end
        if mode == 'equal' then
            res = ret1:narrowEqual(ret) ~= rt.NEVER
        end
        if res then
            matches[#matches+1] = def
        else
            notMatches[#notMatches+1] = def
        end
    end

    local nodeValue = self.node:finalValue()

    ---@param funcs Node.Function[]
    ---@return Node
    local function makeParam(funcs)
        local result = {}

        for _, f in ipairs(funcs) do
            local v = f:getParam(index)
            if not v then
                goto continue
            end
            if nodeValue == rt.ANY then
                result[#result+1] = v
            elseif nodeValue == rt.UNKNOWN then
                result[#result+1] = v.truly
            else
                local res = self.node:narrow(v)
                result[#result+1] = res
            end
            ::continue::
        end

        return self.scope.rt.union(result)
    end

    return makeParam(matches), makeParam(notMatches)
end

---@private
---@return Node
---@return Node
function M:narrowParamByParam()
    local rt = self.scope.rt
    local func, index, mode, ret = table.unpack(self.callParams)
    func:addRef(self)
    ret:addRef(self)
    ---@type Node.Function[]
    local defs = {}

    func:each('function', function (f)
        ---@cast f Node.Function
        if f:isDummy() then
            return
        end
        defs[#defs+1] = f
    end)

    local nodeValue = self.node:finalValue()

    local passed = ls.tools.linkedTable.create()
    local all = ls.tools.linkedTable.create()

    ---@param node Node
    ---@param param Node
    ---@param def Node.Function
    local function checkDef(node, param, def)
        if not node:canCast(param) then
            return
        end
        all:pushTail(param)
        local res
        local ret1 = def:getReturn(1) or rt.NIL
        if mode == 'match' then
            res = ret1:canCast(ret)
        end
        if mode == 'equal' then
            res = ret1:narrowEqual(ret) ~= rt.NEVER
        end
        if res then
            passed:pushTail(param)
        end
    end

    -- 直接代入原型来匹配
    for _, def in ipairs(defs) do
        local param = def:getParam(index)
        if not param then
            goto continue
        end
        if nodeValue.kind == 'union' then
            ---@cast nodeValue Node.Union
            for _, nv in ipairs(nodeValue.values) do
                checkDef(nv, param, def)
            end
        else
            checkDef(nodeValue, param, def)
        end
        ::continue::
    end

    local passedNodes = passed:toArray()
    local allNodes = all:toArray()
    local notPassedNodes = ls.util.arrayDiff(allNodes, passedNodes)

    return rt.union(passedNodes), rt.union(notPassedNodes)
end
