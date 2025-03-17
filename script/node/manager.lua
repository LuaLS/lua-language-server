---@class Node.Manager: Class.Base
---@overload fun(scope: Scope): Node.Manager
local M = Class 'Node.Manager'

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

    ---@overload fun(v: number): Node.Value
    ---@overload fun(v: boolean): Node.Value
    ---@overload fun(v: string, quo?: '"' | "'" | '[['): Node.Value
    ---@overload fun(v: nil): Node.Type
    function self.value(...)
        local v, quo = ...
        if v == nil then
            return scope.node.NIL
        end
        if quo == "'" then
            return self.VALUE_POOL_STR2[v]
        end
        if quo == '[[' then
            return self.VALUE_POOL_STR3[v]
        end
        return self.VALUE_POOL[v]
    end

    ---@param value Node
    ---@param len? number
    ---@return Node.Array
    function self.array(value, len)
        return New 'Node.Array' (scope, value, len)
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

    ---@param generics? Node.Generic[]
    ---@return Node.GenericPack
    function self.genericPack(generics)
        return New 'Node.GenericPack' (scope, generics)
    end

    ---@param nodes? Node[]
    ---@return Node.Intersection
    function self.intersection(nodes)
        return New 'Node.Intersection' (scope, nodes)
    end

    ---@param fields? table<string|number|boolean|Node, string|number|boolean|Node>
    ---@return Node.Table
    function self.table(fields)
        return New 'Node.Table' (scope, fields)
    end

    ---@param values? Node[]
    ---@return Node.Tuple
    function self.tuple(values)
        return New 'Node.Tuple' (scope, values)
    end

    ---@param name string
    ---@param args Node[]
    ---@return Node.Typecall
    function self.typecall(name, args)
        return New 'Node.Typecall' (scope, name, args)
    end

    ---@overload fun(nodes?: Node[]): Node
    ---@param nodes? Node[]
    ---@param filter fun(node: Node): boolean
    ---@return Node
    function self.union(nodes, filter)
        if not filter then
            if nodes then
                if #nodes == 0 then
                    return scope.node.NEVER
                end
                if #nodes == 1 then
                    return nodes[1]
                end
            end
            return New 'Node.Union' (scope, nodes)
        end
        if not nodes then
            return scope.node.NEVER
        end
        local result = {}
        for _, v in ipairs(nodes) do
            if filter(v) then
                result[#result+1] = v
            end
        end
        if #result == 0 then
            return scope.node.NEVER
        end
        if #result == 1 then
            return result[1]
        end
        return New 'Node.Union' (scope, result)
    end

    ---@generic T
    ---@param baseNode Node
    ---@param context T
    ---@param onResolve Node.Unsolve.Callback<T>
    ---@return Node.Unsolve
    function self.unsolve(baseNode, context, onResolve)
        return New 'Node.Unsolve' (scope, baseNode, context, onResolve)
    end

    ---@param name string | number | boolean | Node
    ---@param parent? Node.Variable
    ---@return Node.Variable
    function self.variable(name, parent)
        return New 'Node.Variable' (scope, name, parent)
    end
end

---@private
function M:fillPresets()
    self.TRUE = self.value(true)
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
        : addExtends(self.NUMBER)
    self.STRING = self.type 'string'
        : setConfig('basicType', true)
    self.BOOLEAN = self.type 'boolean'
        : setConfig('basicType', true)
    self.FUNCTION = self.type 'function'
        : setConfig('basicType', true)
    self.TABLE = self.type 'table'
        : setConfig('basicType', true)
        : setConfig('hideEmptyArgs', true)
    self.USERDATA = self.type 'userdata'
        : setConfig('basicType', true)
    self.THREAD = self.type 'thread'
        : setConfig('basicType', true)

    self.ANY:addField {
        key   = self.ANY,
        value = self.ANY,
        hideInView = true,
    }
    self.ANY.truly = self.TRULY
    self.ANY.falsy = self.FALSE | self.type 'nil'

    self.UNKNOWN:addField {
        key   = self.ANY,
        value = self.ANY,
        hideInView = true,
    }
    self.UNKNOWN.truly = self.TRULY
    self.UNKNOWN.falsy = self.FALSE

    self.TRULY:addField {
        key   = self.ANY,
        value = self.ANY,
        hideInView = true,
    }

    self.NIL.truly = self.NEVER
    self.NIL.falsy = self.NIL

    self.BOOLEAN.truly = self.TRUE
    self.BOOLEAN.falsy = self.FALSE

    self.FALSE.truly = self.NEVER
    self.FALSE.falsy = self.FALSE

    do
        local K = self.generic('K', self.ANY, self.ANY)
        local V = self.generic('V', self.ANY, self.ANY)
        self.TABLE:addParams { K, V }
        self.TABLE:addField {
            key   = K,
            value = V,
        }
    end

    self.USERDATA:addField {
        key   = self.ANY,
        value = self.ANY,
        hideInView = true,
    }

    self.G = self.variable '_G'
        : hideAtHead()
        : addClass(self.type '_G')
    self.type '_G'
        : addVariable(self.G)
        : addField {
            key   = self.ANY,
            value = self.ANY,
            hideInView = true,
        }
end

function M:reset()
    self:createPools()
    self:fillPresets()
    self.castCache = nil
end

---@param ... Node.Key
---@return Node.Variable
function M:globalGet(...)
    return self.G:getChild(...)
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:globalAdd(field, path)
    return self.G:addField(field, path)
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:globalRemove(field, path)
    return self.G:removeField(field, path)
end


---@type PathTable
M.castCache = nil

M.__getter.castCache = function (self)
    return ls.pathTable.create(true, false), true
end

---@type Node.CacheModule[]
M.waitFlushList = nil

---@param node Node.CacheModule
function M:collectFlushNodes(node)
    if not self.waitFlushList then
        self.waitFlushList = {}
    end
    self.waitFlushList[#self.waitFlushList+1] = node
    if self.cacheLocked == 0 then
        self:flushNodesNow()
    end
end

function M:flushNodesNow()
    self.castCache = nil
    local list = self.waitFlushList
    if not list then
        return
    end
    self.waitFlushList = nil

    local flushed = {}
    for _ = 1, 1000000 do
        local node = list[#list]
        if not node then
            break
        end
        list[#list] = nil

        if flushed[node] then
            goto continue
        end
        flushed[node] = true

        -- flush this node
        local getter = node.__getter
        for k in pairs(getter) do
            node[k] = nil
        end

        -- push children to list
        local needFlush = node.needFlush
        if needFlush then
            for child in pairs(needFlush) do
                if not flushed[child] then
                    list[#list+1] = child
                end
            end
        end
        ::continue::
    end
end

M.cacheLocked = 0

function M:lockCache()
    self.cacheLocked = self.cacheLocked + 1
end

function M:unlockCache()
    self.cacheLocked = self.cacheLocked - 1
    if self.cacheLocked == 0 then
        self:flushNodesNow()
    end
end

---@param scope Scope
---@return Node.Manager
function ls.node.createManager(scope)
    local apis = New 'Node.Manager' (scope)
    return apis
end
