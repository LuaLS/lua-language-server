---@type table<any, Custom.Context.Master>
local masterMap = ls.util.weakKTable()

---@class Custom.Context
---当使用 `Type<T>` 调用类型时，传入的类型参数会存放在此表中。
---可以使用 `args[1]` 或 `args['T']` 来访问传入的参数。
---如果传入的参数数量不足，那么不足的部分会被填充为 `never` 。
---其他索引返回 `nil`。
---如果不是类型调用，则此字段为 `nil` 。
---在 `onValue` 的回调中可以保证此字段存在且被填充。
---@field args? Node[] | table<string, Node>
---@field table fun(fields?: table<Node.Key, Node>): Node.Table
---@field field fun(name: Node.Key, value: Node, optional: boolean): Node.Field
---@field type fun(name: string): Node.Type
---@field value fun(val: string | number | boolean): Node.Value

---@class Custom.Context.Master
local M = Class 'Custom.Context.Master'

---@param node Node
---@param data? table
function M:__init(node, data)
    self.node = node
    self.rt = node.scope.rt
    self.context = self:makeDefaultContext(data or {})
    masterMap[self.context] = self
end

---@param data table
---@return tablelib
function M:makeDefaultContext(data)
    local rt = self.rt
    data.__index = data

    data.table = rt.table
    data.field = rt.field
    data.value = rt.value

    data.type = function (name)
        local t = rt.type(name)
        t:addRef(self.node)
        return t
    end

    return data
end

---@param func fun(c: Custom.Context): Node
---@param extraArgs? table
---@return Node
function M:call(func, extraArgs)
    local context = setmetatable(extraArgs or {}, self.context)
    local c1 = os.clock()
    local suc, res = pcall(func, context)
    local c2 = os.clock()
    local duration = (c2 - c1) * 1000
    if duration > 10 then
        log.warn(('[Custom] execution took %.2f ms'):format(duration))
    end
    if suc then
        return res
    end
    log.error(('[Custom] error: %s'):format(res))
    return self.rt.NEVER
end

---@param node Node
---@param data? table
---@return Custom.Context.Master
function ls.custom.contextMaster(node, data)
    local master = New 'Custom.Context.Master' (node, data)
    return master
end
