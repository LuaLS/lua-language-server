---@class Node.API
---@overload fun(scope: Scope): Node.API
local M = Class 'Node.API'

---@param scope Scope
function M:__init(scope)
    ---@private
    self.scope = scope

    self:createPools()
    self:fillAPIs()
end

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
    function self.value(v, quo)
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

    ---@overload fun(nodes?: Node[]): Node.Union
    ---@param nodes? Node[]
    ---@param filter fun(node: Node): boolean
    ---@return Node
    function self.union(nodes, filter)
        if not filter then
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

    ---@param baseNode Node
    ---@param onResolve Node.Unsolve.Callback
    ---@return Node.Unsolve
    function self.unsolve(baseNode, onResolve)
        return New 'Node.Unsolve' (scope, baseNode, onResolve)
    end
end

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
    }
    self.ANY.truly = self.TRULY
    self.ANY.falsy = self.FALSE | self.type 'nil'

    self.UNKNOWN:addField {
        key   = self.ANY,
        value = self.ANY,
    }
    self.UNKNOWN.truly = self.TRULY
    self.UNKNOWN.falsy = self.FALSE

    self.TRULY:addField {
        key   = self.ANY,
        value = self.ANY,
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
        self.TABLE:bindParams(self.genericPack { K, V })
        self.TABLE:addField {
            key   = K,
            value = V,
        }
    end

    self.USERDATA:addField {
        key   = self.ANY,
        value = self.ANY,
    }
end

---@param scope Scope
---@return Node.API
function ls.node.createAPIs(scope)
    local apis = New 'Node.API' (scope)
    return apis
end
