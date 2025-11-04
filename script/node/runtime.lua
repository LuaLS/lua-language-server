---@class Node.Runtime: Class.Base
---@overload fun(scope: Scope): Node.Runtime
local M = Class 'Node.Runtime'

---@param scope Scope
function M:__init(scope)
    ---@private
    self.scope = scope

    self:fillAPIs()
end

---@private
function M:createPools()
    local scope = self.scope
    self.TYPE_POOL  = setmetatable({}, {
        __mode = 'v',
        __index = function (t, k)
            local v = New 'Node.Type' (scope, k)
            t[k] = v
            return v
        end,
    })
    self.VALUE_POOL = setmetatable({}, {
        __mode = 'v',
        __index = function (t, k)
            local v = New 'Node.Value' (scope, k)
            t[k] = v
            return v
        end,
    })
    self.VALUE_POOL_STR2 = setmetatable({}, {
        __mode = 'v',
        __index = function (t, k)
            local v = New 'Node.Value' (scope, k, "'")
            t[k] = v
            return v
        end,
    })
    self.VALUE_POOL_STR3 = setmetatable({}, {
        __mode = 'v',
        __index = function (t, k)
            local v = New 'Node.Value' (scope, k, '[[')
            t[k] = v
            return v
        end,
    })
end

---@private
function M:fillAPIs()
    local scope = self.scope
    ---@param name string
    ---@return Node.Type
    function self.type(name)
        return self.TYPE_POOL[name]
    end

    ---@param name string
    ---@param params? Node.Generic[]
    ---@param extends? Node.Class.ExtendAble[]
    ---@return Node.Class
    function self.class(name, params, extends)
        return New 'Node.Class' (scope, name, params, extends)
    end

    ---@param name string
    ---@param params? Node.Generic[]
    ---@param value? Node
    ---@return Node.Alias
    function self.alias(name, params, value)
        return New 'Node.Alias' (scope, name, params, value)
    end

    ---@overload fun(v: number): Node.Value
    ---@overload fun(v: boolean): Node.Value
    ---@overload fun(v: string, quo?: '"' | "'" | '[['): Node.Value
    function self.value(...)
        local v, quo = ...
        if quo == "'" then
            return self.VALUE_POOL_STR2[v]
        end
        if quo == '[[' then
            return self.VALUE_POOL_STR3[v]
        end
        return self.VALUE_POOL[v]
    end

    ---@param value Node
    ---@return Node.Array
    function self.array(value)
        return New 'Node.Array' (scope, value)
    end

    ---@param head Node
    ---@param index Node.Key
    ---@return Node.Index
    function self.index(head, index)
        return New 'Node.Index' (scope, head, index)
    end

    ---@param head Node
    ---@param key Node.Key
    ---@return Node.Select
    function self.select(head, key)
        return New 'Node.Select' (scope, head, key)
    end

    function self.func()
        return New 'Node.Function' (scope)
    end

    ---@param name string
    ---@param extends? Node
    ---@param default? Node
    ---@return Node.Generic
    function self.generic(name, extends, default)
        return New 'Node.Generic' (scope, name, extends, default)
    end

    ---@param nodes Node[]
    ---@return Node
    function self.intersection(nodes)
        if #nodes == 0 then
            return scope.rt.NEVER
        end
        if #nodes == 1 then
            return nodes[1]
        end
        return New 'Node.Intersection' (scope, nodes)
    end

    ---@param fields? table<string|number|boolean|Node, string|number|boolean|Node>
    ---@return Node.Table
    function self.table(fields)
        return New 'Node.Table' (scope, fields)
    end

    ---@param values? Node[] | Node.List
    ---@return Node.Tuple
    function self.tuple(values)
        return New 'Node.Tuple' (scope, values)
    end

    ---@param values? Node[]
    ---@param min? integer
    ---@param max? integer
    ---@return Node.List
    function self.list(values, min, max)
        return New 'Node.List' (scope, values, min, max)
    end

    ---@param head string
    ---@param args Node[]
    ---@return Node.Call
    function self.call(head, args)
        return New 'Node.Call' (scope, head, args)
    end

    ---@param head Node
    ---@param args Node[]
    ---@return Node.FCall
    function self.fcall(head, args)
        return New 'Node.FCall' (scope, head, args)
    end

    ---@overload fun(nodes?: Node[]): Node
    ---@param nodes? Node[]
    ---@param filter fun(node: Node): boolean
    ---@return Node
    function self.union(nodes, filter)
        if not filter then
            if nodes then
                if #nodes == 0 then
                    return scope.rt.NEVER
                end
                if #nodes == 1 then
                    return nodes[1]
                end
            end
            return New 'Node.Union' (scope, nodes)
        end
        if not nodes then
            return scope.rt.NEVER
        end
        local result = {}
        for _, v in ipairs(nodes) do
            if filter(v) then
                result[#result+1] = v
            end
        end
        if #result == 0 then
            return scope.rt.NEVER
        end
        if #result == 1 then
            return result[1]
        end
        return New 'Node.Union' (scope, result)
    end

    ---@param name string | number | boolean | Node
    ---@param parent? Node.Variable
    ---@return Node.Variable
    function self.variable(name, parent)
        return New 'Node.Variable' (scope, name, parent)
    end

    ---@param name string
    ---@param params table<string, Node.Generic?>
    ---@return Node.Template
    function self.template(name, params)
        return New 'Node.Template' (scope, name, params)
    end

    ---@param options? Node.Viewer.Options
    ---@return Node.Viewer
    function self.viewer(options)
        return New 'Node.Viewer' (options)
    end
end

---@private
function M:fillPresets()
    self.TRUE  = self.value(true)
    self.FALSE = self.value(false)

    self.NEVER = self.type 'never'
        : setConfig('basicType', true)
    self.ANY = self.type 'any'
        : setConfig('onCanCast', function (_, other)
            return true
        end)
        : setConfig('onCanBeCast', function (_, other)
            return true
        end)
        : setConfig('basicType', true)
    self.UNKNOWN = self.type 'unknown'
        : setConfig('onCanCast', function (_, other)
            if other.value ~= self.NIL then
                return true
            end
        end)
        : setConfig('onCanBeCast', function (_, other)
            if other.value ~= self.NIL then
                return true
            end
        end)
    self.TRULY = self.type 'truly'
        : setConfig('onCanCast', function (_, other)
            if  other.value ~= self.NIL
            and other.value ~= self.FALSE then
                return true
            end
        end)
        : setConfig('onCanBeCast', function (_, other)
            if  other.value ~= self.NIL
            and other.value ~= self.FALSE then
                return true
            end
        end)
        : setConfig('basicType', true)
    self.NIL = self.type 'nil'
        : setConfig('basicType', true)
    self.NUMBER = self.type 'number'
        : setConfig('basicType', true)
    self.INTEGER = self.type 'integer'
        : setConfig('basicType', true)
        : addClass(self.class('integer', nil, { self.NUMBER }))
    self.STRING = self.type 'string'
        : setConfig('basicType', true)
    self.BOOLEAN = self.type 'boolean'
        : setConfig('basicType', true)
    self.FUNCTION = self.type 'function'
        : setConfig('basicType', true)
    self.TABLE = self.type 'table'
        : setConfig('basicType', true)
    self.USERDATA = self.type 'userdata'
        : setConfig('basicType', true)
    self.THREAD = self.type 'thread'
        : setConfig('basicType', true)

    local anykv = self.class 'anykv'
        : addField {
            key   = self.ANY,
            value = self.ANY,
            hideInView = true,
        }

    self.ANY:addClass(anykv)
    self.ANY.truly = self.TRULY
    self.ANY.falsy = self.FALSE | self.type 'nil'


    self.UNKNOWN:addClass(anykv)
    self.UNKNOWN.truly = self.TRULY
    self.UNKNOWN.falsy = self.FALSE

    self.TRULY:addClass(anykv)

    self.NIL.truly = self.NEVER
    self.NIL.falsy = self.NIL

    self.BOOLEAN.truly = self.TRUE
    self.BOOLEAN.falsy = self.FALSE

    self.FALSE.truly = self.NEVER
    self.FALSE.falsy = self.FALSE

    do
        local K = self.generic('K', self.ANY, self.ANY)
        local V = self.generic('V', self.ANY, self.ANY)
        local table0 = self.class('table0')
            : addField {
                key   = self.ANY,
                value = self.ANY,
                hideInView = true,
            }

        local table1 = self.class('table1', { K })
            : addField {
                key   = K,
                value = self.TRUE,
            }

        local table2 = self.class('table2', { K, V })
            : addField {
                key   = K,
                value = V,
            }

        self.TABLE:addClass(table0)
        self.TABLE:addClass(table1)
        self.TABLE:addClass(table2)
    end

    self.USERDATA:addClass(anykv)

    self.TYPE_G = self.type '_G'
    self.VAR_G = self.variable '_G'
        : hideAtHead()

    do
        local G = self.class '_G'
            : addVariable(self.VAR_G)
            : addField {
                key    = self.value '_G',
                value  = self.TYPE_G,
            }
        self.TYPE_G:addClass(G)
        self.VAR_G:addClass(G)
    end
end

function M:reset()
    self:createPools()
    self:fillPresets()
    self.castCache = nil
end

---@param ... Node.Key
---@return Node.Variable
function M:globalGet(...)
    return self.VAR_G:getChild(...)
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:globalAdd(field, path)
    return self.VAR_G:addField(field, path)
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:globalRemove(field, path)
    return self.VAR_G:removeField(field, path)
end


---@type PathTable
M.castCache = nil

M.__getter.castCache = function (self)
    return ls.tools.pathTable.create(true, false), true
end

---@type table<Node.RefModule, true>
M.waitFlushList = nil

---@param node Node.RefModule
function M:collectFlushNodes(node)
    if not self.waitFlushList then
        self.waitFlushList = setmetatable({}, ls.util.MODE_K)
    end
    self.waitFlushList[node] = true
    if self.cacheLocked == 0 then
        self:flushCacheNow()
    end
end

function M:flushCacheNow()
    self.castCache = nil
    local list = self.waitFlushList
    if not list then
        return
    end
    self.waitFlushList = nil
    local flushed = {}

    ---@param node Node.RefModule
    local function flushOne(node)
        if flushed[node] then
            return
        end
        flushed[node] = true

        local getter = node.__getter
        for k in pairs(getter) do
            node[k] = nil
        end

        local refMap = node.refMap
        if refMap then
            node.refMap = nil

            for child in pairs(refMap) do
                flushOne(child)
            end
        end
    end

    for node in pairs(list) do
        flushOne(node)
    end
end

---@param node Node.Type | Node.Call
---@return Node.Class.ExtendAble[]
function M:calcFullExtends(node)
    ---@type Node.Class.ExtendAble[]
    local results = {}
    local visited = {}

    ---@param t Node.Type | Node.Call
    ---@param nextQueue (Node.Type | Node.Call)[]
    local function searchOnce(t, nextQueue)
        if visited[t] then
            return
        end
        visited[t] = true
        for _, ext in ipairs(t.extends) do
            results[#results+1] = ext
            if ext.kind == 'type'
            or ext.kind == 'call' then
                ---@cast ext -Node.Table
                nextQueue[#nextQueue+1] = ext
            end
        end
    end

    local queue = { node }
    while #queue > 0 do
        local nextQueue = {}
        for _, t in ipairs(queue) do
            searchOnce(t, nextQueue)
        end
        queue = nextQueue
    end

    for _, result in ipairs(results) do
        result:addRef(node)
    end

    return results
end


---@param params (Node?)[][]
---@param n integer
---@return integer[]
function M:getBestMatchs(params, n)
    local matchs = {}
    for i = 1, #params do
        matchs[i] = i
    end

    ---@param a Node
    ---@param b Node
    ---@return boolean?
    local function isMoreExact(a, b)
        if a == b then
            return nil
        end
        if a == self.ANY then
            return false
        end
        if b == self.ANY then
            return true
        end
        local a2b = a >> b
        local b2a = b >> a
        if a2b == b2a then
            return nil
        end
        return a2b
    end

    table.sort(matchs, function (a, b)
        local paramsA = params[a]
        local paramsB = params[b]
        for i = 1, n do
            local moreExact = isMoreExact(paramsA[i] or self.ANY, paramsB[i] or self.ANY)
            if moreExact ~= nil then
                return moreExact
            end
        end
        return false
    end)

    local bestN = 1
    local bestI = matchs[1]
    local bestParams = params[bestI]

    local function isAllSame(paramsA, paramsB)
        for i = 1, n do
            if (paramsA[i] or self.ANY) ~= (paramsB[i] or self.ANY) then
                return false
            end
        end
        return true
    end

    for i = 2, #matchs do
        local currI = matchs[i]
        local currParams = params[currI]
        if isAllSame(bestParams, currParams) then
            bestN = bestN + 1
        else
            break
        end
    end

    for i = bestN + 1, #matchs do
        matchs[i] = nil
    end

    return matchs
end

M.cacheLocked = 0

function M:lockCache()
    self.cacheLocked = self.cacheLocked + 1
end

function M:unlockCache()
    self.cacheLocked = self.cacheLocked - 1
    if self.cacheLocked == 0 then
        self:flushCacheNow()
    end
end

---@param scope Scope
---@return Node.Runtime
function ls.node.createRuntime(scope)
    local apis = New 'Node.Runtime' (scope)
    return apis
end
